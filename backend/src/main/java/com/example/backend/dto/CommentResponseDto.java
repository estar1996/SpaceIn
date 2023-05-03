package com.example.backend.dto;

import com.example.backend.domain.Comment;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class CommentResponseDto {

    private Long commentId;

    private String userId;

    private String userName;

    private Long postId;

    private String commentText;

    private LocalDateTime commentDate;

    public CommentResponseDto(Comment comment) {
        commentId = comment.getCommentId();
        userName = comment.getUser().getUserNickname();
        postId = comment.getPost().getPostId();
        commentText = comment.getCommentText();

    }
}
