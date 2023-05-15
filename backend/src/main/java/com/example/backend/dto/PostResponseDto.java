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

    private String fileUrl;

    private Double postLatitude;

    private Double postLongitude;

    private LocalDate postDate;

    private Integer postLikes;


    public PostResponseDto(Post post) {
        postId = post.getPostId();
        userId = post.getUser().getId();
        userNickname = post.getUser().getUserNickname();
        regionId = post.getRegion().getRegionId();
        fileUrl = post.getFileUrl();
        postLatitude = post.getPostLatitude();
        postLongitude = post.getPostLongitude();
        postDate = post.getPostDate();
        postLikes = post.getPostLikes();

    }
}
