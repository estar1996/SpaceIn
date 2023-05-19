package com.example.backend.controller;

import org.springframework.web.bind.annotation.*;

@RestController //API 테스트를 위해 임시로 만든 컨트롤러로 추후 필요없을 시 삭제 예정
@RequestMapping(value = "/hello", produces = "application/json")
public class HelloController {
//    @GetMapping("/start")
//    public String startGet(){
//        return "로그인 하세요";
//    }
//
//    @PostMapping("/start")
//    public String startPost(@RequestParam("name") String name) {
//        return name;
//    }

}
