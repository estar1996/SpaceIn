package com.example.backend.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/hello", produces = "application/json")
public class HelloController {
    @GetMapping("/start")
    public String startGet(){
        return "로그인 하세요";
    }

    @PostMapping("/start")
    public String startPost(@RequestParam("name") String name) {
        return name;
    }

}
