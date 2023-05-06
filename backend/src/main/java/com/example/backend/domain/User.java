package com.example.backend.domain;

import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long Id;
    @Column(nullable = false)
    private String username;
    @Column(nullable = false)
    private String userNickname;
    @Column(nullable = false)
    private String userPassword;
    @Column(nullable = false)
    private Integer userValid;
    @Column(columnDefinition = "VARCHAR(255)")
    private String userImg;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Item> userItems;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Post> userPosts;
    @OneToMany(mappedBy = "user")
    private List<PostLike> postLikes = new ArrayList<>();

    @OneToMany(mappedBy = "user")
    private List<Comment> comments = new ArrayList<>();

    @Column(nullable = false)
    private Integer userMoney;

    private Integer userAdmin;

}
