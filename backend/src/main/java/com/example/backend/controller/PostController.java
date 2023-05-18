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
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.NoSuchElementException;

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

        PostDto postDto = new PostDto(userId, postContent, postLatitude, postLongitude,regionId);
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
    @GetMapping("/{userId}/posts")
    @Operation(summary = "유저별 게시물 조회", description = "<strong> 사용자 ID</strong>를 통해 사용자별 게시물을 조회한다.")
    public List<PostResponseDto> getUserPost(@PathVariable Long userId) {
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


}
