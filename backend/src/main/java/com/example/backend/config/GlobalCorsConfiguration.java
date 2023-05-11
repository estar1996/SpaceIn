package com.example.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class GlobalCorsConfiguration implements WebMvcConfigurer {

    public void addCorsMappings(CorsRegistry registry) {
                // 모든 경로에 대해 CORS 정책 적용
        registry.addMapping("/**")
                // 모든 도메인에서의 요청 허용
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTION")
                // 모든 헤더 허용
                .allowedHeaders("*")
                // 쿠키 자격 증명 정보 허용
                .allowCredentials(true)
                .maxAge(3600);
    }
}
