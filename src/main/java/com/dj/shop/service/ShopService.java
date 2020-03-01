package com.dj.shop.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.dj.shop.pojo.Shop;
import com.dj.shop.pojo.UserShop;

public interface ShopService extends IService<Shop> {


    void userShopSaveAndUserUpdateAndShopUpdate(UserShop userShop, Integer shopId) throws Exception;
}
