package com.example.backend.domain;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;


import javax.persistence.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Getter @Setter
@DynamicInsert
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Column
    private String username;
    @Column
    private String userNickname;
    @Column(nullable = true)
    private String userImg;

    @ManyToMany
    @JoinTable(
            name = "user_item",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "item_itemId"))
    private Set<Item> items = new HashSet<>();

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

    @ColumnDefault("false")
    private Boolean userAdmin;
}
