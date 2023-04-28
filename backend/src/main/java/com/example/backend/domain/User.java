package com.example.backend.domain;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter @Setter
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false)
    private String username;
    @Column(nullable = false)
    private String userNickname;
    @Column(nullable = false)
    private String userPassword;
    @Column(nullable = false)
    private Integer userValid;
    @Column
    private String userImg;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Item> userItems;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Post> userPosts;
    @OneToMany(mappedBy = "user")
    private List<Like> likes = new ArrayList<>();

    @OneToMany(mappedBy = "user")
    private List<Comment> comments = new ArrayList<>();

    @Column(nullable = false)
    private Integer userMoney;

    private Boolean userAdmin;
}
