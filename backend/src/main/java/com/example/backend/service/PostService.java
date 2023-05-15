package com.example.backend.service;

import com.example.backend.domain.Post;
import com.example.backend.domain.Region;
import com.example.backend.domain.User;
import com.example.backend.dto.PostDto;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.repository.PostRepository;
import com.example.backend.repository.RegionRepository;
import com.example.backend.repository.UserRepository;
import com.sun.xml.bind.v2.runtime.Coordinator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private S3Service s3Service;

    @Autowired
    private RegionRepository regionRepository;


    public PostResponseDto savePost(String url, PostDto postDto) {
        User user = userRepository.findById(postDto.getUserId())
                .orElseThrow(() -> new NoSuchElementException("User not found"));

        Post post = Post.builder().
                user(user).
                fileUrl(url).
                postLatitude(postDto.getPostLatitude()).
                postLongitude(postDto.getPostLongitude()).
                postDate(LocalDate.now()).
                postLikes(0).
                build();

        Post savedPost = postRepository.save(post);
        return new PostResponseDto(savedPost);

    }
    public List<PostResponseDto> getUserPosts(Long userId) {
        List<Post> posts = postRepository.findByUserId(userId);
        return posts.stream().map(PostResponseDto::new).collect(Collectors.toList());
    }

    public PostResponseDto getPost(Long postId, Double latitude, Double longitude) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new NoSuchElementException("Post not found with id: " + postId));

        if (isWithinRadius(post.getPostLatitude(), post.getPostLongitude(), latitude, longitude, 1.0)) {
            throw new IllegalArgumentException("The post is not within the acceptable range.");
        }


        return new PostResponseDto(post);
    }

    public void deletePost(Long postId) {
        postRepository.deleteById(postId);
    }



    private boolean isWithinRadius(Double postLatitude, Double postLongitude, double latitude, double longitude, double radiusInKm) {
        double postLat = postLatitude;
        double postLng = postLongitude;

        final int EARTH_RADIUS = 6371;
        double dLat = Math.toRadians(latitude - postLat);
        double dLng = Math.toRadians(longitude - postLng);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(postLat)) * Math.cos(Math.toRadians(latitude))
                * Math.sin(dLng / 2) * Math.sin(dLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distance = EARTH_RADIUS * c;

        return distance <= radiusInKm;
    }

    public List<PostResponseDto> getNearbyPosts(Double latitude, Double longitude, double radiusInKm) {
        List<Post> posts = postRepository.findAll();
        List<PostResponseDto> nearbyPosts = new ArrayList<>();

        for (Post post : posts) {
            if (isWithinRadius(post.getPostLatitude(), post.getPostLongitude(), latitude, longitude, radiusInKm)) {
                nearbyPosts.add(new PostResponseDto(post));
            }
        }
        return nearbyPosts;

    }

    public List<PostResponseDto> getSameSamePosts(Double latitude, Double longitude) {
        List<Post> posts = postRepository.findByPostLatitudeAndPostLongitude(latitude, longitude);
        List<PostResponseDto> samesamePosts = new ArrayList<>();
        for (Post post : posts) {
            samesamePosts.add(new PostResponseDto(post));
        }
        return samesamePosts;
    }
    public List<PostResponseDto> getAllPosts() {
        List<Post> posts = postRepository.findAll();
        return posts.stream()
                .map(PostResponseDto::fromEntity)
                .collect(Collectors.toList());
    }
    public List<PostResponseDto> getPostsByUserId(Long userId) {
        List<Post> posts = postRepository.findAllByUserId(userId);
        return posts.stream()
                .map(PostResponseDto::fromEntity)
                .collect(Collectors.toList());
    }






}
