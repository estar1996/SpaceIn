package com.example.backend.controller;

import com.example.backend.domain.Post;
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
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api/posts")
public class PostController {

    @Autowired
    private PostService postService;

    @Autowired
    private S3Service s3Service;

    @Autowired
    private LoginService loginService;

    @Autowired
    private UserService userService;



    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public PostResponseDto savePost(@RequestPart MultipartFile multipartFile, @RequestPart PostDto postDto) throws IOException {
        String url = s3Service.upload(multipartFile, "spacein", "space");
        PostResponseDto newPost = postService.savePost(url, postDto);
        return newPost;

    }





    @GetMapping("/{postId}")
    public PostResponseDto getPost(@PathVariable Long postId, @RequestParam Double latitude, @RequestParam Double longitude) {
        return postService.getPost(postId, latitude, longitude);
    }


    @GetMapping("/all")
    public ResponseEntity<List<PostResponseDto>> getAllPosts() {
        List<PostResponseDto> posts = postService.getAllPosts();
        return ResponseEntity.ok(posts);
    }

    @DeleteMapping("/{postId}")
    public ResponseEntity<Void> deletePost(@PathVariable Long postId) {
        postService.deletePost(postId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/nearby")
    public List<PostResponseDto> getNearbyPosts(@RequestParam Double latitude, @RequestParam Double longitude, @RequestParam double radiusKm) {
        return postService.getNearbyPosts(latitude, longitude, radiusKm);
    }

    @GetMapping("/samesame")
    public List<PostResponseDto> getSameSamePosts(@RequestParam Double latitude, @RequestParam Double longitude) {
        return postService.getSameSamePosts(latitude, longitude);
    }

    @PostMapping("/{postId}/likes") // 좋아요 관련
    public ResponseEntity<Map<String, Boolean>> getPost(@RequestHeader String token, @PathVariable Long postId) {

        Map<String, Boolean> response = new HashMap<>();

        // 토큰에서 유저정보 파싱, 해당 POST에 좋아요를 했는지 중개테이블을 통해 확인
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        System.out.println("유저아이디"+user.getId()+"포스트아이디"+postId);
        boolean isLike = postService.isLikeExists(user.getId(),postId); // 여기 로직 들어감
        System.out.println("좋아요여부"+isLike);

        // 확인 후 좋아요가 안 되어있으면 false, 좋아요가 되어있으면 true를 isLike변수에 할당

        // 좋아요를 아직 안 했다면 해당 요청이 왔을때 중개 테이블에 추가, 해당 글의 Like += 1
        // return "좋아요 완료"

        // 좋아요를 했다면 해당 요청이 왔을 때 중개 테이블에서 삭제 및 좋아요 Like -= 1
        // return "좋아요 취소 완료"

        // 프론트의 경우, 최초 가져올 때 해당 유저가 좋아요 했는지 아닌지 여부를 전달
        // 반환값을 받으면 버튼 모양을 좋아요 <-> 좋아요 취소로 변경하도록 설정
        response.put("응답", isLike);
        return ResponseEntity.ok()
                .body(response);
    }
}
