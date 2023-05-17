package com.example.backend.repository;

import com.example.backend.domain.Region;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface RegionRepository extends JpaRepository<Region,Long> {
    @Query("SELECT r FROM Region r WHERE r.regionName = :regionName")
    Region findByRegionName(String regionName);


}
