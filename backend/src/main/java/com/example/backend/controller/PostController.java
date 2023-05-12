package com.example.backend.controller;

import com.example.backend.domain.Post;
import com.example.backend.dto.PostDto;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.repository.PostRepository;
import com.example.backend.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/posts")
public class PostController {

    @Autowired
    private PostService postService;
    private PostRepository postRepository;
    @PostMapping
    public ResponseEntity<PostResponseDto> createPost(@RequestBody PostDto postDto) {
        PostResponseDto newPost = postService.createPost(postDto, postDto.getUserId());
        return new ResponseEntity<>(newPost, HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PostResponseDto> getPost(@PathVariable Long id) {
        PostResponseDto post = postService.getPost(id);
        return new ResponseEntity<>(post, HttpStatus.OK);
    }
    @GetMapping
    public List<PostResponseDto> getAllPosts() {
        return postService.getAllPosts();
    }

    @GetMapping("/user/{userId}")
    public List<PostResponseDto> getPostsByUserId(@PathVariable Long userId) {
        return postService.getPostsByUserId(userId);
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
