package com.example.backend.dto;


import com.example.backend.domain.Post;
import com.example.backend.domain.Region;
import com.example.backend.domain.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
public class PostDto {
    private Long userId;

    private Double postLatitude;

    private Double postLongitude;


}
