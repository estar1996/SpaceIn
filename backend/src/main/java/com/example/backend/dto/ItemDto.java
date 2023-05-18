package com.example.backend.dto;

import com.example.backend.domain.Item;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ItemDto {
    private Long itemId;
    private String itemFileName;
    private Integer itemPrice;

    private boolean haveItem;

    public ItemDto(Long itemId, String itemFileName, Integer itemPrice, boolean haveItem) {
        this.itemId = itemId;
        this.itemFileName = itemFileName;
        this.itemPrice = itemPrice;
        this.haveItem = haveItem;
    }
}


