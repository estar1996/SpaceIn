package com.example.backend.filter;

import com.example.backend.provider.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.GenericFilterBean;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RequiredArgsConstructor
public class JwtAuthenticationFilter extends GenericFilterBean {
    private final JwtTokenProvider jwtTokenProvider;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        // 1. Request Header 에서 JWT 토큰 추출
        String token = resolveToken((HttpServletRequest) request);
        // 2. validateToken 으로 토큰 유효성 검사
        if (token != null && jwtTokenProvider.validateToken(token)) {
            // 토큰이 유효할 경우 토큰에서 Authentication 객체를 가지고 와서 SecurityContext 에 저장
            Authentication authentication = jwtTokenProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } else if (token != null && jwtTokenProvider.isExpired(token)) { //다른에러가 아니라 만료되었을 경우,
            // 특정 에러코드 응답, 해당 에러코드 발생시 리프레쉬 토큰을 특정 api로 보내, 엑세스 토큰을 재발급 받는다.
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.setStatus(HttpStatus.UNAUTHORIZED.value()); // 401 Unauthorized
            httpResponse.getWriter().write("Access token expired");
            //해당 코드를 응답받았으면 리프레쉬 토큰을 특정 API에 보낸다.
            //해당 API에 리프레쉬 토큰을 보내면 decode해서, 엑세스토큰을 보내줌.
            return;
        }
        chain.doFilter(request, response);
    }

    //Bearer 토큰인지 확인하고, 7번째 인덱스(실제 토큰이 들어있는 부분)을 잘라주는 메서드
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (StringUtils.hasText(bearerToken)) {
            return bearerToken.substring(7); //앞부분 Bearer 부분을 떼고 토큰값만 취함
        }
        return null;
    }
}
