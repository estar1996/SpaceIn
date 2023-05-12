package com.example.backend.controller;

import com.example.backend.domain.Item;
import com.example.backend.service.LoginService;
import com.example.backend.service.UserService;
import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/shop")
public class ShopController { //조회 알고리즘, 구매 알고리즘 구현

    @Autowired
    LoginService loginService;

    @Autowired
    UserService userService;

    // 조회 알고리즘, 유저의 정보를 받아 아이템의 번호를 list에 담아 응답
    @PostMapping("/checkitem")
    public Set<Item> checkItem(@RequestHeader String token) {
        //header의 token을 받아 유저정보 파악
        List<?> mylist = new ArrayList<>();
        Claims claims = loginService.getClaimsFromToken(token);
        System.out.println(claims);
        //claim에서 유저정보를 확인, 해당 유저가 보유한 아이템 출력
        Set<Item> items = userService.findItemsByUserId(1L);

        return items;
    };

    // 구매 알고리즘, 중개 테이블의 column 추가(데이터 삽입)
    // 프론트에서 해당하는 아이템 id를 알고있다는 전제하에 사용된다.
    // 유저 정보는 Header의 토큰에 있는 유저정보를 통해 사용한다.(타인의 구매 리퀘스트 방지)
    // user_id, item_id 가 가진 column을 만듦으로서 구매정보를 저장할 수 있다.

//    @PostMapping("/buyitem")

}
