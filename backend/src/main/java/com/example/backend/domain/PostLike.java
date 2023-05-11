package com.example.backend.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter @Setter
@NoArgsConstructor
public class PostLike {


    @Id @GeneratedValue(strategy = GenerationType.AUTO)
    private Long postLikeId;


    @ManyToOne
    private User user;


}
