package com.example.backend.controller;

import com.example.backend.domain.Comment;
import com.example.backend.domain.Post;
import com.example.backend.dto.CommentDto;
import com.example.backend.dto.CommentResponseDto;
import com.example.backend.repository.CommentRepository;
import com.example.backend.service.CommentService;
import lombok.RequiredArgsConstructor;
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

    @Transactional
    @PostMapping()
    public List<CommentResponseDto> saveComment(@RequestBody CommentDto commentDto) throws IOException {
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
