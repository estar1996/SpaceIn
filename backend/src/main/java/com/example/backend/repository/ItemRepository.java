package com.example.backend.repository;

import com.example.backend.domain.Item;
import com.example.backend.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ItemRepository extends JpaRepository<Item,Long> {
    Item findByItemId(long itemId);

}
