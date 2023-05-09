package com.example.backend.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Value;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class RefreshToken {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String email;

    @Column(name = "expiration_date")
    private LocalDateTime expirationDate;

    private String token;

    // getters, setters, constructors
    public RefreshToken(String email, String token, LocalDateTime expirationDate) {
        this.email = email;
        this.token = token;
        this.expirationDate = expirationDate;
    }
}