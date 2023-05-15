package com.example.backend.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

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
    private String fileUrl;

    private String postContent;
    private Double postLatitude;
    private Double postLongitude;
    private LocalDate postDate;
    private Integer postLikes;

    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL)
    private List<Comment> comments = new ArrayList<>();

    @Builder
    public Post(User user, String fileUrl, Double postLatitude, Double postLongitude, LocalDate postDate, Integer postLikes, String postContent) {
        this.user = user;
        this.fileUrl = fileUrl;
        this.postLatitude = postLatitude;
        this.postLongitude = postLongitude;
        this.postDate = postDate;
        this.postLikes = postLikes;
        this.postContent = postContent;
    }

}
