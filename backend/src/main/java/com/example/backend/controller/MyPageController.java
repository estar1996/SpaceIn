package com.example.backend.controller;


import com.example.backend.domain.Item;
import com.example.backend.domain.User;
import com.example.backend.dto.ItemDto;
import com.example.backend.service.ItemService;
import com.example.backend.service.LoginService;
import com.example.backend.service.UserService;
import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/mypage")
public class MyPageController {

    @Autowired
    LoginService loginService;

    @Autowired
    UserService userService;

    @Autowired
    ItemService itemService;

    @GetMapping ("/getdata")
    public ResponseEntity<Map<String, Object>> getData(@RequestHeader String token) {
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);

        HashMap<String, Object> response = new HashMap<>(); //response를 담을 객체
        // 1. 유저의 데이터들 제공
        response.put("userNickname",user.getUserNickname());
        response.put("userMoney",user.getUserMoney());
        response.put("userImage",user.getUserImg());

        // 2. 유저의 아이템 중 보유한것만 보내줌
        List<Item> itemList = itemService.getItemList(); // 모든 아이템 리스트
        Set<Item> items = userService.findItemsByUserId(user.getId()); // 유저가 가진 아이템 리스트

        List<ItemDto> itemDtoList = new ArrayList<>();
        for (Item item : itemList) {
            boolean haveItem = itemService.hasItemWithId(item.getItemId(), items);// 이 부분을 유저의 소유여부로 판단
            if (haveItem) { // 유저가 아이템을 가지고 있을 때,
                ItemDto itemDto = new ItemDto(item.getItemId(), item.getItemName(), item.getItemPrice(), item.getItemImg(), haveItem);
                itemDtoList.add(itemDto);
            }
        }
        response.put("itemList", itemDtoList);

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);

    }


}
