package com.example.backend.service;

import com.example.backend.domain.Post;
import com.example.backend.domain.PostLike;
import com.example.backend.domain.Region;
import com.example.backend.domain.User;
import com.example.backend.dto.PostDto;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.repository.PostLikeRepository;
import com.example.backend.repository.PostRepository;
import com.example.backend.repository.RegionRepository;
import com.example.backend.repository.UserRepository;
import com.sun.xml.bind.v2.runtime.Coordinator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;
import java.util.stream.Collectors;
@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PostLikeRepository postLikeRepository;

    @Autowired
    private S3Service s3Service;

    @Autowired
    private RegionRepository regionRepository;

    @Autowired
    private NaverReverseGeocodingService naverReverseGeocodingService;

    public PostResponseDto savePost(String url, PostDto postDto) {
        User user = userRepository.findById(postDto.getUserId())
                .orElseThrow(() -> new NoSuchElementException("User not found"));
        String regionName = naverReverseGeocodingService.getReverseGeocode(postDto.getPostLatitude(), postDto.getPostLongitude());

        Region region = regionRepository.findByRegionName(regionName);
        if (region == null) {
            region = new Region();
            region.setRegionName(regionName);
            regionRepository.save(region); // 새로 만든 지역을 저장합니다.
        }

        Post post = Post.builder().
                user(user).
                region(region).
                fileUrl(url).
                postLatitude(postDto.getPostLatitude()).
                postLongitude(postDto.getPostLongitude()).
                postDate(LocalDate.now()).
                postLikes(0).
                postContent(postDto.getPostContent()).
                build();

        Post savedPost = postRepository.save(post);
        return new PostResponseDto(savedPost);

    }
    public List<PostResponseDto> getUserPosts(Long userId) {
        List<Post> posts = postRepository.findByUserId(userId);
        return posts.stream().map(PostResponseDto::new).collect(Collectors.toList());
    }

    public List<PostResponseDto> getAllPosts() {
        List<Post> posts = postRepository.findAll();
        return posts.stream()
                .map(PostResponseDto::new)
                .collect(Collectors.toList());
    }

    public PostResponseDto getPost(Long postId, Double latitude, Double longitude) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new NoSuchElementException("Post not found with id: " + postId));

        if (!isWithinRadius(post.getPostLatitude(), post.getPostLongitude(), latitude, longitude, 50.0)) {
            throw new IllegalArgumentException("The post is not within the acceptable range.");
        }


        return new PostResponseDto(post);
    }

    public List<PostResponseDto> getUserPost(Long userId) {
        List<Post> posts = postRepository.findByUserId(userId);
        if (!posts.isEmpty()) {
            return posts.stream().map(PostResponseDto::new).collect(Collectors.toList());
        } else {
            throw new NoSuchElementException("No posts found for user");
        }
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


    public List<String> getPostContentsByRegionName(String regionName) {
        Region region = regionRepository.findByRegionName(regionName);
        return postRepository.findByRegion(region).stream()
                .map(Post::getPostContent)
                .collect(Collectors.toList());

    public boolean isLikeExists(Long userId, Long postId) {
        return postLikeRepository.existsByUser_IdAndPost_PostId(userId, postId);
    }

    @Transactional
    public void removePostLikeByUserIdAndPostId(Long userId, Long postId) {
        PostLike postLike = postLikeRepository.findByUser_IdAndPost_PostId(userId, postId);
        if (postLike != null) {
            postLikeRepository.delete(postLike);
        }

    }

    @Transactional
    public void addPostLikeByUserIdAndPostId(Long userId, Long postId) {
        User user = userRepository.findById(userId).orElse(null);
        Post post = postRepository.findById(postId).orElse(null);

        if (user != null && post != null) {
            PostLike postLike = new PostLike();
            postLike.setUser(user);
            postLike.setPost(post);
            postLikeRepository.save(postLike);
        }
    }
    @Transactional
    public void changePostLikes(Long postId, int value) {
        Post post = postRepository.findById(postId).orElse(null);
        if (post != null) {
            post.setPostLikes(post.getPostLikes() + value);  // 새로운 postlikes 값을 설정
            postRepository.save(post);  // 변경된 내용을 저장
        }
    }
}
