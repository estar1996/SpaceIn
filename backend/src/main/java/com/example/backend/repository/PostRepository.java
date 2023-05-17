package com.example.backend.repository;

import com.example.backend.domain.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PostRepository extends JpaRepository<Post,Long> {

    @Query("select r from Post r where r.user.id = :userId")
    List<Post> findByUserId(@Param("userId") Long userId);

    @Query("select r from Post r where r.postLatitude = :latitude and r.postLongitude = :longitude")
    List<Post> findByPostLatitudeAndPostLongitude(@Param("latitude") double latitude, @Param("longitude") double longitude);


}
