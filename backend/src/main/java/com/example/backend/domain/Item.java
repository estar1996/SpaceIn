package com.example.backend.domain;


import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter @Setter
public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String itemImg;

    private Integer itemPrice;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

}
