package com.example.backend.controller;

import com.example.backend.domain.Post;
import com.example.backend.dto.PostDto;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.repository.PostRepository;
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

@RestController
@RequestMapping("/api/posts")
public class PostController {

    @Autowired
    private PostService postService;

    @Autowired
    private S3Service s3Service;


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
    @GetMapping
    public List<PostResponseDto> getAllPosts() {
        return postService.getAllPosts();
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
