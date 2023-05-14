package com.example.backend.controller;

import com.example.backend.domain.RefreshToken;
import com.example.backend.domain.User;
import com.example.backend.dto.UserDto;
import com.example.backend.repository.RefreshTokenRepository;
import com.example.backend.repository.UserRepository;
import com.example.backend.service.LoginService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Optional;

//회원 가입용 로직
@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    LoginService loginService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    RefreshTokenRepository refreshTokenRepository;

    @Value("${jwt.secret}") //secret
    private String secretKey;

    @GetMapping("/start")
    public String startGet(){
        return "로그인 하세요";
    }

    @PostMapping("/signup") //회원가입이 안 되어있을 때, DB에 회원가입 정보를 추가하는 코드
    public ResponseEntity<?> createUser(@RequestBody UserDto userDto) {
        // 이메일과 닉네임이 이미 사용 중인지 확인
        if (userRepository.existsByEmail(userDto.getEmail())) {
            return ResponseEntity.badRequest().body("이미 등록된 이메일입니다.");
        }
        if (userRepository.existsByUserNickname(userDto.getUserNickname())) {
            return ResponseEntity.badRequest().body("이미 사용 중인 닉네임입니다.");
        }

        // User 객체 생성 및 DB에 저장
        User user = new User();
        user.setEmail(userDto.getEmail());
        user.setUserNickname(userDto.getUserNickname());
        user.setUserMoney(0);
        System.out.println(user);
        userRepository.save(user);

        return ResponseEntity.ok("사용자가 등록되었습니다.");
    }
    @PostMapping("/updatetoken") // 업데이트 토큰과 새 리프레쉬 토큰을 반환 //갱신
    public ResponseEntity<Map<String, String>> updatetoken (@RequestHeader String refreshToken){
        //리프레쉬 토큰을 복호화, DB에 있는 값과 대조

        Map<String, String> response = new HashMap<>();

        try {
            Jws<Claims> jwsClaims = Jwts.parserBuilder()
                    .setSigningKey(secretKey.getBytes())
                    .build()
                    .parseClaimsJws(refreshToken);
            // 여기서 만약 refreshtoken이 만료되었을 경우, ExpiredJwtException 발생

            Claims claims = jwsClaims.getBody(); // claim 정보 추출
            String email = claims.getSubject();

            Optional<RefreshToken> refreshTokenOpt = refreshTokenRepository.findByToken(refreshToken);
            if (refreshTokenOpt.isEmpty()) {
                throw new NoSuchElementException("Refresh token not found in database");
            } // 만약 DB에 토큰이 등록되지 않았다면 해당 오류를 반환함.

            // response.put을 통해, 새로 만들어진 토큰을 반환
            // loginService의 토큰 생성 메서드 호출하여, 엑세스토큰과 리프레시토큰을 만들어줌
            String newToken= loginService.generateToken(email,"roles");
            String newRefreshToken = loginService.generateRefreshToken(email);
            response.put("accessToken",newToken);
            response.put("newRefreshToken",newRefreshToken);

            loginService.deleteRefreshToken(email); //먼저 기록되어있는 refreshtoken을 삭제
            loginService.saveRefreshToken(email, newRefreshToken); // 새로운 리프레시토큰을 저장
            System.out.println(newRefreshToken);

            }// 파싱된 JWS 객체 반환
        catch (ExpiredJwtException e) {
            // 만약 refreshtoken도 만료되었을 경우 try~catch 문을 통해 다른 에러코드 응답 ->
            // 프론트단에서 재 로그인 요청하도록 만듬
                response.put("refreshToken","expired");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response); // 해당 응답코드 고치기
        } // DB에 없는 RefreshToken인 경우, 401 응답코드를 반환함.
        catch (NoSuchElementException e) {
            response.put("refreshToken","notExist");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response); // 해당 응답코드 고치기
        }; // 다른 오류에 대한 예외처리도 할것

        // 만약, refreshtoken이 만료되지 않았을 경우, 해당정보를 파싱해, DB에 있는 값과 비교.


        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);

    }
}
