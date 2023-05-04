package com.example.backend.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter @Setter
@DynamicInsert
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column
    private String username;
    @Column
    private String userNickname;
    @Column
    private String userPassword;
    @Column
    private Integer userValid;
    @Column
    private String userImg;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Item> userItems;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Post> userPosts;
    @OneToMany(mappedBy = "user")
    private List<PostLike> postLikes = new ArrayList<>();

    @OneToMany(mappedBy = "user")
    private List<Comment> comments = new ArrayList<>();

    @Column
    @ColumnDefault("0")
    private Integer userMoney;

    @Column
    private String email;

    private Boolean userAdmin;
}
