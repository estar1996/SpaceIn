package com.example.backend.repository;

import com.example.backend.domain.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {


    @Query("select r from Comment r where r.post.postId = :postId")
    List<Comment> findAllByPostId(@Param("postId") Long postId);

}
