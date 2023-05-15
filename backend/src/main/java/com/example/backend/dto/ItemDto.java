package com.example.backend.dto;

import com.example.backend.domain.Item;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ItemDto {
    private Long itemId;
    private String itemName;
    private Integer itemPrice;

    private String itemImg;

    private boolean haveItem;

    public ItemDto(Long itemId, String itemName, Integer itemPrice, String itemImg, boolean haveItem) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.itemPrice = itemPrice;
        this.itemImg = itemImg;
        this.haveItem = haveItem;
    }
}


