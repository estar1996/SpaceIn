package com.example.backend.domain;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter @Setter
@NoArgsConstructor
public class Accessory {

    @Id @GeneratedValue
    @Column(name = "accessory_id")
    private Long id;
    private String accessoryImg;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

}
