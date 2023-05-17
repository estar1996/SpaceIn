package com.example.backend.service;

import com.example.backend.domain.Item;
import com.example.backend.domain.User;
import com.example.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;

@Service
@Transactional
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // 아래는 userId별 보유 아이템을 반환하는 코드
    public Set<Item> findItemsByUserId(Long userId) {
        return userRepository.findItemsByUserId(userId);
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public boolean deleteById(Long id) {
        try {
            userRepository.deleteById(id);
            return true; // 삭제 성공
        } catch (Exception e) {
            e.printStackTrace();
            return false; // 삭제 실패
        }
    }
    public void updateUserNickname(Long userId, String nickname) {
        userRepository.updateUserNickname(userId, nickname);
    }
}
