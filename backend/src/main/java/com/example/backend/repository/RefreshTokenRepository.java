package com.example.backend.repository;

import com.example.backend.domain.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {

    Optional<RefreshToken> findByToken(String token);

    void deleteByEmail(String email);


    default RefreshToken saveToken(String email, String token, Long refreshExpirationTime) {
        LocalDateTime expirationDateTime = LocalDateTime.now().plusSeconds(refreshExpirationTime);
        RefreshToken refreshToken = new RefreshToken(email, token, expirationDateTime);
        return save(refreshToken);
    }
}
