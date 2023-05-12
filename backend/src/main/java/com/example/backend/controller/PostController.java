package com.example.backend.controller;

import com.example.backend.domain.Post;
import com.example.backend.dto.PostDto;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.service.PostService;
import com.example.backend.service.S3Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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
    @PostMapping
    public PostResponseDto createPost(@RequestPart MultipartFile multipartFile, @RequestPart PostDto postDto) throws IOException {

        String url = s3Service.upload(multipartFile, "spacein","spacein");
        PostResponseDto newPost = postService.createPost(url, postDto);
        return postService.getPost(postDto.getUserId());
    }

    @GetMapping("/{id}")
    public ResponseEntity<PostResponseDto> getPost(@PathVariable Long id) {
        PostResponseDto post = postService.getPost(id);
        return new ResponseEntity<>(post, HttpStatus.OK);
    }


    @GetMapping("/{id}/near")
    public ResponseEntity<List<PostResponseDto>> getNearbyPosts(@RequestParam("latitude") double userLatitude, @RequestParam("longitude") double userLongitude) {
        List<PostResponseDto> nearbyPosts = postService.getNearbyPost(userLatitude, userLongitude, 5.0);
        return new ResponseEntity<>(nearbyPosts, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePost(@PathVariable Long id) {
        postService.deletePost(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}
