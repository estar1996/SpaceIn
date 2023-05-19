package com.example.backend.repository;

import com.example.backend.domain.Region;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RegionRepository extends JpaRepository<Region,Long> {
    @Query("SELECT r FROM Region r WHERE r.regionName = :regionName")
    Region findByRegionName(@Param("regionName") String regionName);

    @Query("SELECT p.postContent FROM Post p JOIN p.region r WHERE r.regionName = :regionName")
    List<String> findPostContentsByRegionName(@Param("regionName") String regionName);






}
