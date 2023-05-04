package com.example.backend.controller;

import com.example.backend.domain.User;
import com.example.backend.service.LoginService;
import com.example.backend.service.UserService;
import io.jsonwebtoken.Claims;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/login/oauth2", produces = "application/json")
public class LoginController {

    LoginService loginService;
    UserService userService;


    public LoginController(LoginService loginService, UserService userService) {
        this.loginService = loginService;
        this.userService = userService;
    }

    @GetMapping("/code/{registrationId}")
    public String googleLogin(@RequestParam String code, @PathVariable String registrationId) {
        String email = loginService.socialLogin(code, registrationId);
        User user = userService.getUserByEmail(email);
        // 유저 확인 후 토큰 생성
        if (user == null) {
            System.out.println("유저 정보가 없습니다");
            return "loginFailed";
        } else {
            // 정보가 있을 경우
            System.out.println("소셜 로그인 성공");
            // 이하 토큰 발급 코드

            String token = loginService.generateToken("id", email, "nickname", "roles");
            Claims claims = loginService.getClaimsFromToken(token);
            System.out.println(claims);
            return token;
        }
    }
}