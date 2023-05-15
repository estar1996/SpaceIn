package com.example.backend.service;

import com.example.backend.domain.Item;
import com.example.backend.repository.ItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
public class ItemService {
    @Autowired
    private ItemRepository itemRepository;

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
}
