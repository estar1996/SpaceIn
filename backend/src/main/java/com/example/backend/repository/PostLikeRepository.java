package com.example.backend.repository;

import com.example.backend.domain.Post;
import com.example.backend.domain.PostLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PostLikeRepository extends JpaRepository<PostLike, Long> {
    boolean existsByUser_IdAndPost_PostId(Long userId, Long postId);

    PostLike findByUser_IdAndPost_PostId(Long userId, Long postId);
    void delete(PostLike postLike);

    PostLike save(PostLike postLike);


}
