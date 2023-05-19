package com.example.backend.service;

import com.example.backend.domain.Comment;
import com.example.backend.domain.Post;
import com.example.backend.domain.User;
import com.example.backend.dto.CommentDto;
import com.example.backend.dto.CommentResponseDto;
import com.example.backend.repository.CommentRepository;
import com.example.backend.repository.PostRepository;
import com.example.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.persistence.Id;
import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
@Transactional
public class CommentService {

    private final CommentRepository commentRepository;

    private final UserRepository userRepository;

    private final PostRepository postRepository;

    public void saveComment(CommentDto commentDto) {

        Long postId = commentDto.getPostId();
        Long userId = commentDto.getUserId();

        Post post = postRepository.findById(postId).orElseThrow(() -> new NoSuchElementException());
        User user = userRepository.findById(userId).orElseThrow(() -> new NoSuchElementException());

        Comment comment = Comment.builder().
                post(post).
                user(user).
                commentText(commentDto.getCommentText()).
                commentDate(LocalDateTime.now()).
                build();
        commentRepository.save(comment);

    }

    public List<CommentResponseDto> getCommentList(Long postId) {
        List<Comment> commentList = commentRepository.findAllByPostId(postId);
        int commentCount = commentList.size();

        List<CommentResponseDto> postCommnetList = commentList.stream()
                .map(r -> new CommentResponseDto(r,commentCount))
                .collect(Collectors.toList());
        return postCommnetList;
    }

    public void deleteComment(Long commentId) {
        commentRepository.deleteById(commentId);
    }
}
