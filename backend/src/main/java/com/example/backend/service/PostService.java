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
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserRepository userRepository;


    @Autowired
    private RegionRepository regionRepository;

    public PostResponseDto createPost(String url, PostDto postDto) {
//        User user = userRepository.findById(postDto.getUserId())
//                .orElseThrow(() -> new IllegalArgumentException("User not found with id:" );

//        Post post = postDto.toEntity(user);
        Post post = Post.builder().
                postContent(postDto.getPostContent()).
                postImage(url).
                postLatitude(postDto.getPostLatitude()).
                postLongitude(postDto.getPostLongitude()).
                build();
        postRepository.save(post);
        return PostResponseDto.fromEntity(post);
    }


//    public  PostResponseDto createPost(String url, PostDto postDto) {
//        User user = userRepository.findById(postDto.getUserId())
//                .orElseThrow(() -> new IllegalArgumentException("User not found with id:"));
//        Post post = Post.builder().
//                postContent(postDto.getPostContent()).
//                postImage(url).
//                postLatitude(postDto.getPostLatitude()).
//                postLongitude(postDto.getPostLongitude()).
//                build();
//    }


    public PostResponseDto getPost(Long id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Post not found with id" + id));
        return PostResponseDto.fromEntity(post);
    }

    public List<PostResponseDto> getNearbyPost(double latitude, double longitude, double radiusInKm) {
        List<Post> posts = postRepository.findAll();
        return posts.stream()
                .filter(post -> isWithinRadius(post.getPostLatitude(), post.getPostLongitude(), latitude, longitude, radiusInKm))
                .map(PostResponseDto::fromEntity)
                .collect(Collectors.toList());
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
//    private boolean isWithinRadius(String postLatitude,String postLongitude, double latitude, double longitude, double radiusInKm) {
//        double postLat = Double.parseDouble(postLatitude);
//        double postLng = Double.parseDouble(postLongitude);
//
//        final int EARTH_RADIUS = 6371;
//        double dLat = Math.toRadians(latitude - postLat);
//        double dLng = Math.toRadians(longitude - postLng);
//
//        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
//                + Math.cos(Math.toRadians(postLat)) * Math.cos(Math.toRadians(latitude))
//                * Math.sin(dLng / 2) * Math.sin(dLng / 2);
//        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
//        double distance = EARTH_RADIUS * c;
//
//        return distance <= radiusInKm;
//    }

    public void deletePost(Long id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Post not found with id" + id));
        postRepository.delete(post);
    }



}
