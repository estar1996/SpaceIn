package com.example.backend.dto;


import com.example.backend.domain.Post;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
public class PostResponseDto {

    private Long postId;
    private Long userId;
    private String userNickname;
    private Long regionId;

    private String postContent;

    private Double postLatitude;

    private Double postLongitude;

    private LocalDate postDate;

    private Integer postLikes;


    public static PostResponseDto fromEntity(Post post) {
        PostResponseDto postResponseDto = new PostResponseDto();
        postResponseDto.setPostId(post.getPostId());
        postResponseDto.setUserId(post.getUser().getId());
        postResponseDto.setUserNickname(post.getUser().getUserNickname());
        postResponseDto.setRegionId(post.getRegion().getRegionId());
        postResponseDto.setPostContent(post.getPostContent());
        postResponseDto.setPostLatitude(post.getPostLatitude());
        postResponseDto.setPostLongitude(post.getPostLongitude());
        postResponseDto.setPostDate(post.getPostDate());
        postResponseDto.setPostLikes(post.getPostLikes());
        return postResponseDto;
    }
}
