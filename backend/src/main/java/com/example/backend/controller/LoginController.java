package com.example.backend.controller;

import com.example.backend.domain.User;
import com.example.backend.service.LoginService;
import com.example.backend.service.UserService;
import io.jsonwebtoken.Claims;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping(value = "/login/oauth2", produces = "application/json")
public class LoginController {

    LoginService loginService;
    UserService userService;


    public LoginController(LoginService loginService, UserService userService) {
        this.loginService = loginService;
        this.userService = userService;
    }

    @PostMapping ("/code/{registrationId}") //소셜 로그인 시, DB에 사용자 등록이 되어있는지 일차적으로 확인함
    //email을 받고, 이미 구현해놓은 로직을 통해 유저정보가 DB에 존재하는지 확인한다.
    public ResponseEntity<Map<String, String>> googleLogin(@RequestHeader String accessToken, @PathVariable String registrationId) {
        String email = loginService.socialLogin(accessToken, registrationId); //코드를 받아 서버에 요청하여 이메일을 받아옴.
        User user = userService.getUserByEmail(email); //
        // 유저 확인 후 토큰 생성
        // 만약 유저정보가 없을 경우, 유저정보가 없다는 응답을 반환한다.
        if (user == null) {
            System.out.println("유저 정보가 없습니다");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build(); // 유저 정보가 없을 경우 401 Unauthorized 응답 반환 //해당 부분 응답을 받아, 프론트에서 회원가입 로직 구현 필요
            // 지정해준 특정 문자열을 응답받으면 or 응답 코드가 401이면, 회원가입하게 만드는 페이지로 이동> 해당 페이지에서 회원가입 API 요청 하도록 함
            // DB에 등록하는 API 만들고 프론트에게 말해주기
        } else {
            // 정보가 있을 경우
            System.out.println("소셜 로그인 성공");
            // 이하 토큰 발급 코드

            String token = loginService.generateToken(email, "roles");
            //발급된 refreshToken을 DB에 저장하는 로직도 포함됨
            String refreshToken = loginService.generateRefreshToken(email);

            // token에 정보들을 담아야 하는데, 어떤 데이터들을 담을지 더 생각해보고 추후 코드 수정
            // 아래는 Claim이 제대로 들어갔는지 확인하는 함수(최종 시 삭제할 것)
            Claims claims = loginService.getClaimsFromToken(token);
            Map<String, String> response = new HashMap<>();
            response.put("token","Bearer "+token);
            response.put("refreshToken", refreshToken);

            System.out.println(claims);

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
    }


}