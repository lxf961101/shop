package com.dj.shop.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.dj.shop.common.ResultModel;
import com.dj.shop.common.SystemConstant;
import com.dj.shop.mapper.ShopMapper;
import com.dj.shop.pojo.Shop;
import com.dj.shop.pojo.User;
import com.dj.shop.pojo.UserShop;
import com.dj.shop.service.ShopService;
import com.dj.shop.service.UserService;
import com.dj.shop.service.UserShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

@Service
@Transactional(rollbackFor = Exception.class)
public class ShopServiceImpl extends ServiceImpl<ShopMapper, Shop> implements ShopService {

    @Autowired
    private UserShopService userShopService;

    @Autowired
    private UserService userService;

    @Override
    public void userShopSaveAndUserUpdateAndShopUpdate(UserShop userShop, Integer shopId) throws Exception {
        Shop shop = this.getById(shopId);
        Double sumPrice = shop.getPrice() * userShop.getNumber();
        User user = userService.getById(userShop.getUserId());
        userShop.setPrice(shop.getPrice());
        userShop.setProductName(shop.getProductName());
        userShop.setBuyTime(new Date());
        userShopService.save(userShop);
        Double balance = user.getMoney() - sumPrice;
        UpdateWrapper<User> updateWrapper1 = new UpdateWrapper();
        updateWrapper1.set("money", balance);
        updateWrapper1.eq("id", userShop.getUserId());
        userService.update(updateWrapper1);
        Integer number = shop.getNumber() - userShop.getNumber();
        UpdateWrapper<Shop> updateWrapper = new UpdateWrapper();
        updateWrapper.set("number", number);
        updateWrapper.eq("id", shop.getId());
        this.update(updateWrapper);
    }
}
