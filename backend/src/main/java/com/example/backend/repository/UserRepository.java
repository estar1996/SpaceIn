package com.example.backend.repository;

import com.example.backend.domain.Item;
import com.example.backend.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public interface UserRepository extends JpaRepository<User,Long> {

    @Modifying //유저의 userMoney수정하는 추상 메서드
    @Query("UPDATE User u SET u.userMoney = u.userMoney + :amount WHERE u.id = :userId")
    void changeUserMoney(@Param("userId") Long userId, @Param("amount") int amount);

    @Query("SELECT u.items FROM User u WHERE u.id = :userId")
    Set<Item> findItemsByUserId(@Param("userId") Long userId);
    User findByEmail(String email);
    boolean existsByEmail(String email);
    boolean existsByUserNickname(String userNickname);

    void deleteById(Long id);

    @Modifying
    @Query("UPDATE User u SET u.userNickname = :nickname WHERE u.id = :userId")
    void updateUserNickname(@Param("userId") Long userId, @Param("nickname") String nickname);



}
