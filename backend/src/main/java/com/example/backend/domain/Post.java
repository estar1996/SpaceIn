package com.example.backend.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter @Setter
@NoArgsConstructor
public class Post {

    @Id @GeneratedValue
    @Column(name = "post_id")
    private Long postId;
    @ManyToOne
    private User user;
    @ManyToOne
    private Region region;
    private String postContent;
    private String postImage;
    private Double postLatitude;
    private Double postLongitude;
    private LocalDate postDate;
    private Integer postLikes;

    @Builder
    public Post(User user, String postContent, String postImage, Double postLatitude, Double postLongitude, LocalDate postDate, Integer postLikes) {
        this.user = user;
        this.postContent = postContent;
        this.postImage = postImage;
        this.postLatitude = postLatitude;
        this.postLongitude = postLongitude;
        this.postDate = postDate;
        this.postLikes = postLikes;
    }

}
