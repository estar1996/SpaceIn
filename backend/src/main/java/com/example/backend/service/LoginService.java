package com.example.backend.service;

import com.example.backend.domain.RefreshToken;
import com.example.backend.domain.User;
import com.example.backend.repository.RefreshTokenRepository;
import com.example.backend.repository.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
public class LoginService {

    //application.properties에 있는 설정 데이터 불러옴
    @Value("${jwt.secret}")
    private String secretKey;

    @Value("${jwt.expiration}")
    private Long expirationTime;

    @Value("${jwt.refresh.expiration}")
    private Long refreshExpirationTime;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Autowired
    private UserRepository userRepository;


    private final Environment env;
    private final RestTemplate restTemplate = new RestTemplate();

    public LoginService(Environment env) {
        this.env = env;
    }

    public Map<String, String> socialLogin(String accessToken, String registrationId) {
//        String accessToken = getAccessToken(code, registrationId);
        JsonNode userResourceNode = getUserResource(accessToken, registrationId);
        System.out.println("accessToken = " + accessToken);
        System.out.println("userResourceNode = " + userResourceNode);

        String id = userResourceNode.get("id").asText();
        String email = userResourceNode.get("email").asText();
        String nickname = userResourceNode.get("name").asText();
        String userImg = userResourceNode.get("picture").asText();
        System.out.println("id = " + id);
        System.out.println("email = " + email);
        System.out.println("nickname = " + nickname);

        Map<String, String> userData = new HashMap<>();
        userData.put("email", email);
        User user = userRepository.findByEmail(email);
        user.setUserImg(userImg);
        userRepository.save(user); // 이미지 삽입

        return userData; // email을 리턴해서 이걸 기준으로 로그인 처리
    }

    private String getAccessToken(String authorizationCode, String registrationId) {
        String clientId = env.getProperty("oauth2." + registrationId + ".client-id");
        String clientSecret = env.getProperty("oauth2." + registrationId + ".client-secret");
        String redirectUri = env.getProperty("oauth2." + registrationId + ".redirect-uri");
        String tokenUri = env.getProperty("oauth2." + registrationId + ".token-uri");

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("code", authorizationCode);
        params.add("client_id", clientId);
        params.add("client_secret", clientSecret);
        params.add("redirect_uri", redirectUri);
        params.add("grant_type", "authorization_code");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        HttpEntity entity = new HttpEntity(params, headers);

        ResponseEntity<JsonNode> responseNode = restTemplate.exchange(tokenUri, HttpMethod.POST, entity, JsonNode.class);
        JsonNode accessTokenNode = responseNode.getBody();
        return accessTokenNode.get("access_token").asText();
    }

    private JsonNode getUserResource(String accessToken, String registrationId) {
//        String resourceUri = env.getProperty("oauth2." + registrationId + ".resource-uri");
        String resourceUri = "https://www.googleapis.com/oauth2/v2/userinfo";

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity entity = new HttpEntity(headers);
        return restTemplate.exchange(resourceUri, HttpMethod.GET, entity, JsonNode.class).getBody();
    }

    //토큰을 생성하는 코드
    public String generateToken(String email, String roles) {
        Date now = new Date();
        Date expiration = new Date(now.getTime() + expirationTime);


        JwtBuilder builder = Jwts.builder()
                .setSubject(email)
                .setIssuedAt(now)
                .setExpiration(expiration)
                .claim("roles", roles)
                .claim("auth", "MEMBER") // 추후 admin이 생길 경우 수정
                .signWith(SignatureAlgorithm.HS256, secretKey.getBytes());

        return builder.compact();
    }

    public String generateRefreshToken(String email) { //해당 코드에 findbyemail로 코드삭제 하는거만 하면됨
        Date now = new Date();
        Date expiration = new Date(now.getTime() + refreshExpirationTime);

        JwtBuilder builder = Jwts.builder()
                .setSubject(email)
                .setIssuedAt(now)
                .setExpiration(expiration)
                .signWith(SignatureAlgorithm.HS256, secretKey.getBytes());

        String token = builder.compact();
        saveRefreshToken(email, token);

        return token;
    }

    public Claims getClaimsFromToken(String token) {
        return Jwts.parser()
                .setSigningKey(secretKey.getBytes())
                .parseClaimsJws(token)
                .getBody();
    }

    public void saveRefreshToken(String email, String token) { //토큰 저자
        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setEmail(email);
        refreshToken.setToken(token);
        refreshTokenRepository.saveToken(email, token, refreshExpirationTime);
    }

    @Transactional //트랜젝션? 더 알아보자.
    public void deleteRefreshToken(String email) {
        refreshTokenRepository.deleteByEmail(email);
        System.out.println("Loginservice.java에서 성공적으로 삭제:" + email);
    }

}