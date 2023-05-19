package com.example.backend.controller;

import com.example.backend.domain.User;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.service.LoginService;
import com.example.backend.service.NaverSentimentService;
import com.example.backend.service.PostService;
import com.example.backend.service.UserService;
import io.jsonwebtoken.Claims;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@RestController
public class NaverSentimentController {
    @Autowired
    private NaverSentimentService naverSentimentService;
    @Autowired
    private PostService postService;
    @Autowired
    private LoginService loginService;

    @Autowired
    private UserService userService;


    @GetMapping("/keyword")
    @Operation(summary = "유저가 속한 지역 키워드", description = "유저의 게시물들이 가장 많이 속한 지역의 감정을 분석한다.")
    public String getCombinedPostContentByUser(@RequestHeader String Authorization) {
        String token = Authorization.substring(7);
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        Long userId = user.getId();
        List<PostResponseDto> userPosts = postService.getUserPosts(userId);
        if (userPosts.isEmpty()) {
            throw new NoSuchElementException("No posts found for user");
        }

        // 유저의 게시물들이 가장 많이 속한 지역 찾기
        Map<String, Long> regionCountMap = userPosts.stream()
                .collect(Collectors.groupingBy(PostResponseDto::getRegionName, Collectors.counting()));

        String mostCommonRegion = regionCountMap.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElseThrow(() -> new NoSuchElementException("No region found"));


        String combinedPostContent = postService.getCombinedPostContentsByRegionName(mostCommonRegion);
        String sentimentResult = naverSentimentService.analyzeSentiment(combinedPostContent).getBody();



        return sentimentResult;
    }











}
