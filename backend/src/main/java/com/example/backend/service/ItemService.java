package com.example.backend.service;

import com.example.backend.domain.Item;
import com.example.backend.domain.User;
import com.example.backend.repository.ItemRepository;
import com.example.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
public class ItemService {
    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private UserRepository userRepository;

    public boolean hasItemWithId(Long id, Set<Item> items) {
        for (Item item : items) {
            if (item.getItemId().equals(id)) {
                return true;
            }
        }
        return false;
    }

    public List<Item> getItemList() {
        return itemRepository.findAll();
    }

    public String buyItem (Item item, User user) {
       int itemPrice = item.getItemPrice();
       int userMoney = user.getUserMoney();
       if (userMoney >= itemPrice) {
           Long id = user.getId();
           userMoney -= itemPrice;
           user.setUserMoney(userMoney);
           Set<Item> items = userRepository.findItemsByUserId(id);
           items.add(item);
           user.setItems(items);
           userRepository.save(user);

           return "Success";
       } else {
           return "Fail";
       }

    };

    public Item getItemByItemId(Long itemId) {
        return itemRepository.findByItemId(itemId);
    }
}
