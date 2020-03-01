package com.dj.shop.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.dj.shop.mapper.UserMapper;
import com.dj.shop.mapper.UserShopMapper;
import com.dj.shop.pojo.UserShop;
import com.dj.shop.service.UserShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(rollbackFor = Exception.class)
public class UserShopServiceImpl extends ServiceImpl<UserShopMapper, UserShop> implements UserShopService {

    @Autowired
    private UserMapper userMapper;



}
