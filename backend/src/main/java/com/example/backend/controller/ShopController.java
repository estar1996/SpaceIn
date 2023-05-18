package com.example.backend.controller;

import com.example.backend.domain.Item;
import com.example.backend.domain.User;
import com.example.backend.dto.BuyItemRequestDto;
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
@RequestMapping("/shop")
public class ShopController { //조회 알고리즘, 구매 알고리즘 구현

    @Autowired
    LoginService loginService;

    @Autowired
    UserService userService;

    @Autowired
    ItemService itemService;
//    조회 알고리즘, 응답예시:
//    userPoint: 유저가 가진 활동 포인트
//    itemList: 유저가 가진 이미지 리스트
//            [
//    {imagetype: 1,
//            imageName: 'Star',
//            imageHave: bool,
//            imagePrice: int}
//    ],
//    }
    @PostMapping("/checkitem")
    public ResponseEntity<HashMap<String,Object>> checkItem(@RequestHeader String Authorization) {
        //header의 token을 받아 유저정보 파악
        String token = Authorization.substring(7);
        List<?> mylist = new ArrayList<>();

        Claims claims = loginService.getClaimsFromToken(token);
        System.out.println(claims);
        String email = claims.get("sub", String.class);
        System.out.println("1차 테스트");

        // claim에서 유저 email 추출, email을 통해 id를 가져옴

        User user = userService.getUserByEmail(email);
        Long id = user.getId();

        // 불러온 user에 대해 usermoney 확인
        Integer userMoney = user.getUserMoney(); //usermoney

        // 아이쳄 리스트 출력
        List<Item> itemList = itemService.getItemList(); // 모든 아이템 리스트
        Set<Item> items = userService.findItemsByUserId(id); // 유저가 가진 아이템 리스트

        List<ItemDto> itemDtoList = new ArrayList<>();
        for (Item item : itemList) {
            System.out.println("아이템 출력"+item.getItemId());
            boolean haveItem = itemService.hasItemWithId(item.getItemId(), items);// 이 부분을 유저의 소유여부로 판단

            ItemDto itemDto = new ItemDto(item.getItemId(), item.getItemName(), item.getItemPrice(), item.getItemImg(), haveItem);
            itemDtoList.add(itemDto);
        }
        HashMap<String, Object> response = new HashMap<>();
        response.put("userMoney", userMoney);
        response.put("itemList", itemDtoList);

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
    }

    @PostMapping("/buyitem")
    public ResponseEntity<Map<String, Object>> buyItem(@RequestHeader String Authorization, @RequestBody BuyItemRequestDto request) {
        String token = Authorization.substring(7);
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        Long itemId = request.getItemId();
        Item item = itemService.getItemByItemId(itemId);
        String result = itemService.buyItem(item, user);


        HashMap<String, Object> response = new HashMap<>();
        response.put("result", result);

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
    };

}
