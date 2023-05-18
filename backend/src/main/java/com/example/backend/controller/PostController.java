package com.example.backend.controller;

import com.example.backend.domain.Post;
import com.example.backend.domain.Region;
import com.example.backend.dto.PostDto;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.repository.RegionRepository;
import com.example.backend.service.NaverReverseGeocodingService;
import com.example.backend.service.PostService;
import com.example.backend.service.S3Service;
import io.swagger.v3.oas.annotations.Operation;

import com.example.backend.domain.User;
import com.example.backend.dto.PostDto;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.service.LoginService;
import com.example.backend.service.PostService;
import com.example.backend.service.S3Service;
import com.example.backend.service.UserService;
import io.jsonwebtoken.Claims;

import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.apache.tomcat.util.http.parser.Authorization;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.*;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/posts")
@Tag(name = "Post", description = "post API 입니다")
public class PostController {

    @Autowired
    private PostService postService;
    @Autowired
    private S3Service s3Service;
    @Autowired
    private NaverReverseGeocodingService naverReverseGeocodingService;

    @Autowired
    private RegionRepository regionRepository;

    @Autowired
    private LoginService loginService;

    @Autowired
    private UserService userService;


//    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
//    public PostResponseDto savePost(@RequestParam MultipartFile multipartFile, @RequestParam PostDto postDto) throws IOException {
//        String url = s3Service.upload(multipartFile, "spacein", "space");
//        PostResponseDto newPost = postService.savePost(url, postDto);
//        return newPost;
//
//    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "게시물 저장"
            , description = "게시물을 저장한다.")
    public PostResponseDto savePost(@RequestPart("multipartFile") MultipartFile multipartFile,
                                    @RequestParam("userId") Long userId,
                                    @RequestParam("postContent") String postContent,
                                    @RequestParam("postLatitude") double postLatitude,
                                    @RequestParam("postLongitude") double postLongitude) throws IOException {

        String regionName = naverReverseGeocodingService.getReverseGeocode(postLatitude, postLongitude);
        Region region = regionRepository.findByRegionName(regionName);
        if (region == null) {
            throw new RuntimeException("Region not found for the given region name: " + regionName);
        }
        Long regionId = region.getRegionId();

        PostDto postDto = new PostDto(userId, postContent, postLatitude, postLongitude, regionId);
        String url = s3Service.upload(multipartFile, "spacein", "space");
        PostResponseDto newPost = postService.savePost(url, postDto);
        return newPost;
    }


    @GetMapping("/{postId}")
    @Operation(summary = "게시물 조회"
            , description = "<strong>게시물 ID</strong>과 <strong>사용자의 위도,경도</strong>를 통해 게시물을 조회한다.")
    public PostResponseDto getPost(@PathVariable Long postId, @RequestParam Double latitude, @RequestParam Double longitude) {
        return postService.getPost(postId, latitude, longitude);
    }

    //유저별 게시물 조회
    @GetMapping("/myPosts")
    @Operation(summary = "유저별 게시물 조회", description = "<strong> 사용자 ID</strong>를 통해 사용자별 게시물을 조회한다.")
    public List<PostResponseDto> getUserPost(@RequestHeader String Authorization) {
        String token = Authorization.substring(7);
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        Long userId = user.getId();
        return postService.getUserPost(userId);
    }


    @GetMapping("/all")
    @Operation(summary = "모든 게시물 조회", description = "모든 게시물 정보를 가져온다.")
    public ResponseEntity<List<PostResponseDto>> getAllPosts() {
        List<PostResponseDto> posts = postService.getAllPosts();
        return ResponseEntity.ok(posts);
    }

    @DeleteMapping("/{postId}")
    @Operation(summary = "게시물 삭제", description = "<strong>게시물 ID</strong>를 통해 게시물을 삭제한다.")
    public ResponseEntity<Void> deletePost(@PathVariable Long postId) {
        postService.deletePost(postId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/nearby")
    @Operation(summary = "근처 게시물 조회", description = "<strong>사용자 위도,경도</strong>를 기준으로 <strong>radiusKm</strong> 안에 있는 게시물을 조회한다.")
    public List<PostResponseDto> getNearbyPosts(@RequestParam Double latitude, @RequestParam Double longitude, @RequestParam double radiusKm) {
        return postService.getNearbyPosts(latitude, longitude, radiusKm);
    }

    @GetMapping("/samesame")
    @Operation(summary = "같은 위치 게시물 조회", description = "<strong>게시물 위도,경도</strong>를 통해 같은 위치에 있는 게시물을 모두 조회한다.")
    public List<PostResponseDto> getSameSamePosts(@RequestParam Double latitude, @RequestParam Double longitude) {
        return postService.getSameSamePosts(latitude, longitude);
    }

    @GetMapping("/reverseGeocode")
    @Operation(summary = "주소 조회", description = "<strong>위도,경도</strong>를 입력하면 주소를 조회한다.")
    public String getAddress(@RequestParam("latitude") double latitude, @RequestParam("longitude") double longitude) {
        return naverReverseGeocodingService.getReverseGeocode(latitude, longitude);
    }

    @GetMapping("/posts/region/{regionName}/contents")
    @Operation(summary = "지역별 게시물 내용 리스트 조회", description = "<strong>지역 이름</strong>을 통해 그 지역에 속한 게시물의 내용을 모두 조회한다.")
    public List<String> getPostContentByRegion(@PathVariable String regionName) {
        return postService.getPostContentsByRegionName(regionName);
    }


    @PostMapping("/{postId}/likes") // 좋아요 관련
    public ResponseEntity<Map<String, String>> getPost(@RequestHeader String Authorization, @PathVariable Long postId) {

        String token = Authorization.substring(7);
        Map<String, String> response = new HashMap<>();

        // 토큰에서 유저정보 파싱, 해당 POST에 좋아요를 했는지 중개테이블을 통해 확인
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        Long userId = user.getId();
        // 확인 후 좋아요가 안 되어있으면 false, 좋아요가 되어있으면 true를 isLike변수에 할당
        boolean isLike = postService.isLikeExists(userId, postId); // 여기 로직 들어감


        if (isLike) { // 좋아요를 했다면 해당 요청이 왔을 때 중개 테이블에서 삭제 및 좋아요 Like -= 1
            postService.removePostLikeByUserIdAndPostId(userId, postId);
            postService.changePostLikes(postId, -1); // 좋아요 갯수 -1
            // return "좋아요 취소 완료"
            response.put("좋아요", "취소됨");
            return ResponseEntity.ok()
                    .body(response);

        } else { // 좋아요를 아직 안 했다면 해당 요청이 왔을때 중개 테이블에 추가, 해당 글의 Like += 1
            postService.addPostLikeByUserIdAndPostId(userId, postId);
            postService.changePostLikes(postId, 1); // 좋아요 갯수 + 1
            // return "좋아요 완료"
            response.put("좋아요", "추가됨");
            return ResponseEntity.ok()
                    .body(response);
        }


        // 프론트의 경우, 최초 가져올 때 해당 유저가 좋아요 했는지 아닌지 여부를 전달
        // 반환값을 받으면 버튼 모양을 좋아요 <-> 좋아요 취소로 변경하도록 설정
    }

    @GetMapping("/randomPost")
    public ResponseEntity<Map<String, Object>> Randompost(@RequestHeader String Authorization, @RequestParam double latitude, @RequestParam double longitude) {
        // 유저 불러옴

        String token = Authorization.substring(7);
        System.out.println(token);
        Claims claims = loginService.getClaimsFromToken(token);
        System.out.println(claims);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        Long userId = user.getId();

        Set<PostResponseDto> randomPosts = postService.randomPickPosts(userId, latitude, longitude);

        HashMap<String, Object> response = new HashMap<>();
        response.put("postList", randomPosts);
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
    }


}
