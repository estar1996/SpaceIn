package com.example.backend.dto;

import com.example.backend.domain.Comment;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class CommentResponseDto {

    private Long commentId;

    private String userId;

    private String userName;

    private Long postId;

    private String commentText;

    private Integer commentCount;

    public CommentResponseDto(Comment comment, int commentCount) {
        commentId = comment.getCommentId();
        userId = comment.getUser().getId().toString();
        userName = comment.getUser().getUserNickname();
        postId = comment.getPost().getPostId();
        commentText = comment.getCommentText();
        this.commentCount = commentCount;

    }
}
