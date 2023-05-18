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
    private String regionName;

    private String fileUrl;

    private Double postLatitude;

    private Double postLongitude;

    private LocalDate postDate;
    private String postContent;
    private Integer postLikes;


    public PostResponseDto(Post post) {
        postId = post.getPostId();
        if (post.getUser() != null) {
            userId = post.getUser().getId();
            userNickname = post.getUser().getUserNickname();
        }
        if (post.getRegion() != null) {
            regionId = post.getRegion().getRegionId();
            regionName = post.getRegion().getRegionName();
        }
        fileUrl = post.getFileUrl();
        postLatitude = post.getPostLatitude();
        postLongitude = post.getPostLongitude();
        postDate = post.getPostDate();
        postContent = post.getPostContent();
        postLikes = post.getPostLikes();

    }
}
