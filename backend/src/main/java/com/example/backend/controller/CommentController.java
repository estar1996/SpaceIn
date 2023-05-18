package com.example.backend.controller;

import com.example.backend.domain.Comment;
import com.example.backend.domain.Post;
import com.example.backend.domain.User;
import com.example.backend.dto.CommentDto;
import com.example.backend.dto.CommentMakeDto;
import com.example.backend.dto.CommentResponseDto;
import com.example.backend.repository.CommentRepository;
import com.example.backend.service.CommentService;
import com.example.backend.service.LoginService;
import com.example.backend.service.UserService;
import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.http.parser.Authorization;
import org.springframework.web.bind.annotation.*;

import javax.transaction.Transactional;
import java.io.IOException;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/comment")
public class CommentController {

    private final CommentService commentService;
    private final CommentRepository commentRepository;

    private final UserService userService;
    private final LoginService loginService;

    @Transactional
    @PostMapping()
    public List<CommentResponseDto> saveComment(@RequestHeader String Authorization, @RequestBody CommentMakeDto commentMakeDto) throws IOException {
        String token = Authorization.substring(7);
        Claims claims = loginService.getClaimsFromToken(token);
        String email = claims.get("sub", String.class);
        User user = userService.getUserByEmail(email);
        Long userId = user.getId();
        userService.changeUserMoney(userId,50);
        String commentText = commentMakeDto.getCommentText();
        Long postId = commentMakeDto.getPostId();

        CommentDto commentDto = new CommentDto();
        commentDto.setPostId(postId);
        commentDto.setUserId(userId);
        commentDto.setCommentText(commentText);

        commentService.saveComment(commentDto);
        return commentService.getCommentList(commentDto.getPostId());
    }

    @GetMapping("/comments/{postId}")
    public List<CommentResponseDto> getCommentList(@PathVariable Long postId) throws IOException {
        return commentService.getCommentList(postId);
    }

    @Transactional
    @DeleteMapping("/{commentId}")
    public List<CommentResponseDto> deleteComment(@PathVariable Long commentId) {
        Comment comment = commentRepository.findById(commentId).get();
        Post post = comment.getPost();

        commentService.deleteComment(commentId);

        return commentService.getCommentList(post.getPostId());
    }
}
