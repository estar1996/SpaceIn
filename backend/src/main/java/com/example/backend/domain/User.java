package com.example.backend.domain;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class User {

    @Id @GeneratedValue
    @Column(name = "user_id")
    private Long userId;

    @Column(nullable = false)
    private String userName;

    private String userPassword;

    private String userImage;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Accessory> accessory = new ArrayList<>();
    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL)
    private List<Comment> comments = new ArrayList<>();


}
