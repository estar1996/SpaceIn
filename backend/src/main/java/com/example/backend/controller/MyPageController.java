package com.example.backend.controller;


import com.example.backend.domain.Item;
import com.example.backend.domain.User;
import com.example.backend.dto.ChangeNickNameRequestDto;
import com.example.backend.dto.ItemDto;
import com.example.backend.dto.PostResponseDto;
import com.example.backend.service.ItemService;
import com.example.backend.service.LoginService;
import com.example.backend.service.PostService;
import com.example.backend.service.UserService;
import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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

    @Autowired
    PostService postService;

    @GetMapping ("/getData")
    public ResponseEntity<Map<String, Object>> getData(@RequestHeader String Authorization) {
        String token = Authorization.substring(7);
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);

        HashMap<String, Object> response = new HashMap<>();
        // 1. 유저의 데이터들 제공
        response.put("userNickname",user.getUserNickname());
        response.put("userMoney",user.getUserMoney());
        response.put("userImage",user.getUserImg());

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
    }
    @GetMapping("/getItem")
    public ResponseEntity<Map<String, Object>> getItem(@RequestHeader String Authorization) {
        String token = Authorization.substring(7);
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);

        HashMap<String, Object> response = new HashMap<>();
        List<Item> itemList = itemService.getItemList(); // 모든 아이템 리스트
        Set<Item> items = userService.findItemsByUserId(user.getId()); // 유저가 가진 아이템 리스트

        List<ItemDto> itemDtoList = new ArrayList<>();
        for (Item item : itemList) {
            boolean haveItem = itemService.hasItemWithId(item.getItemId(), items);// 이 boolean값을 유저의 소유여부로 판단
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

    @GetMapping("/getPost")
    public ResponseEntity<Map<String, Object>> getPost(@RequestHeader String Authorization) {
        String token = Authorization.substring(7);
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        HashMap<String, Object> response = new HashMap<>();

        List<PostResponseDto> myPostList = new ArrayList<>(); // 유저가 쓴 글을 집어넣는 리스트
        List<PostResponseDto> postResponseDtoList = postService.getAllPosts();
        for (PostResponseDto postResponseDto: postResponseDtoList) {
            if (Objects.equals(postResponseDto.getUserId(), user.getId())) {
                myPostList.add(postResponseDto);
            }
        }
        response.put("postList", myPostList);
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);

    }

        // 회원탈퇴
    @PostMapping("/deleteUser")
    public ResponseEntity<Map<String, Object>> deleteUser(@RequestHeader String Authorization) {
        String token = Authorization.substring(7);
        HashMap<String, Object> response = new HashMap<>();
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        Long id = user.getId();

        boolean deletionResult = userService.deleteById(id);
        if (deletionResult) {
            response.put("result","회원탈퇴가 완료되었습니다.");
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);

        } else {
            response.put("result","회원탈퇴가 성공적으로 수행되지 못했습니다.");
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(response);
        }
    }

    // 닉네임변경
    @PostMapping("/changeNickname")
    public ResponseEntity<Map<String, Object>> deleteUser(@RequestHeader String Authorization, @RequestBody ChangeNickNameRequestDto request) {
        String token = Authorization.substring(7);
        HashMap<String, Object> response = new HashMap<>();
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        Long id = user.getId();
        String nickName = request.getNickName();

        try {
            // 사용자 닉네임 업데이트 로직
            userService.updateUserNickname(id, nickName);

            response.put("result", "닉네임" + nickName + "(으)로 변경 완료");
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        } catch (Exception e) {

            e.printStackTrace();
            response.put("result", "닉네임 변경에 실패하였습니다");
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(response);
        }

    }
}
