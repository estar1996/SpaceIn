package com.example.backend.controller;

import com.example.backend.domain.Post;
import com.example.backend.dto.PostDto;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.service.PostService;
import com.example.backend.service.S3Service;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Schema;
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
public class PostController {

    @Autowired
    private PostService postService;

    @Autowired
    private S3Service s3Service;


//    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
//    public PostResponseDto savePost(@RequestParam MultipartFile multipartFile, @RequestParam PostDto postDto) throws IOException {
//        String url = s3Service.upload(multipartFile, "spacein", "space");
//        PostResponseDto newPost = postService.savePost(url, postDto);
//        return newPost;
//
//    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public PostResponseDto savePost(@RequestPart("multipartFile") MultipartFile multipartFile,
                                      @RequestParam("userId") Long userId,
                                      @RequestParam("postContent") String postContent,
                                      @RequestParam("postLatitude") double postLatitude,
                                      @RequestParam("postLongitude") double postLongitude) throws IOException {
        System.out.println(multipartFile.getSize());
        System.out.println(multipartFile.getName());
        PostDto postDto = new PostDto(userId, postContent, postLatitude, postLongitude);
        String url = s3Service.upload(multipartFile, "spacein", "space");
        PostResponseDto newPost = postService.savePost(url, postDto);
        return newPost;
    }
//    @ModelAttribute


    @GetMapping("/{postId}")
    public PostResponseDto getPost(@PathVariable Long postId, @RequestParam Double latitude, @RequestParam Double longitude) {
        return postService.getPost(postId, latitude, longitude);
    }

    //유저별 게시물 조회
    @GetMapping("/{userId}/posts")
    public List<PostResponseDto> getUserPost(@PathVariable Long userId) {
        return postService.getUserPost(userId);
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
}
