package com.dj.shop.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.dj.shop.mapper.RoleResourceMapper;
import com.dj.shop.pojo.RoleResource;
import com.dj.shop.service.RoleResourceService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(rollbackFor = Exception.class)
public class RoleResourceServiceImpl extends ServiceImpl<RoleResourceMapper, RoleResource> implements RoleResourceService {


}
