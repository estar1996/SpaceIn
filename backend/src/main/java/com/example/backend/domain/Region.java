package com.example.backend.domain;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.List;

@Entity
@Getter @Setter
public class Region {

    @Id @GeneratedValue
    @Column(name = "region_id")
    private Long regionId;

    private String regionKeyward;

    private String regionName;

    @OneToMany
    private List<Post> posts;


}
