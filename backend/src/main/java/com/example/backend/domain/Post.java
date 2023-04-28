package com.example.backend.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter @Setter
@Builder
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
    private String postLatitude;
    private String postLongitude;
    private LocalDate postDate;
    private Integer postLikes;



}
