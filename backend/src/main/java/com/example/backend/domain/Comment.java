package com.example.backend.domain;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter @Setter
public class Comment {
    @Id @GeneratedValue
    @Column(name = "comment_id")
    private Long commentId;

    @ManyToOne
    private Post post;

    @ManyToOne
    private User user;


    private String commentText;

    private LocalDate commentDate;



}
