package com.dj.shop.web;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.dj.shop.common.ResultModel;
import com.dj.shop.common.SystemConstant;
import com.dj.shop.pojo.Shop;
import com.dj.shop.pojo.User;
import com.dj.shop.pojo.UserShop;
import com.dj.shop.service.ShopService;
import com.dj.shop.service.UserService;
import com.dj.shop.service.UserShopService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jdk.nashorn.internal.ir.ReturnNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@RequestMapping("/shop/")
@RestController
public class ShopController {

    @Autowired
    private ShopService shopService;

    @Autowired
    private UserShopService userShopService;

    @Autowired
    private UserService userService;
    /**
     * 超市管理展示
     * @param shop
     * @param price1
     * @param pageNo
     * @param session
     * @return
     */
    @RequestMapping("list")
    public ResultModel<Object> list(Shop shop, Integer price1, Integer pageNo, HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        User user = (User) session.getAttribute("user");
        try {
            PageHelper.startPage(pageNo, SystemConstant.NUMBER_FOUR);
            QueryWrapper<Shop> wrapper = new QueryWrapper<>();
            if (!StringUtils.isEmpty(shop.getProductName())) {
                wrapper.like("product_name", shop.getProductName());
            }
            if (null != shop.getStatus()) {
                wrapper.eq("status", shop.getStatus());
            }
            if (null != shop.getPrice() && null != price1) {
                wrapper.between("price", shop.getPrice(), price1);
            }
            wrapper.eq("is_del", shop.getIsDel());
            if  (!user.getRole().equals(SystemConstant.NUMBER_THREE)) {
                wrapper.eq("user_id", user.getId());
            }
            List<Shop> shopList = shopService.list(wrapper);
            PageInfo<Shop> pageInfo = new PageInfo<Shop>(shopList);
            map.put("totalNum", pageInfo.getPages());
            map.put("shopList", shopList);
            return new ResultModel<>().success(map);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 修改
     * @param shop
     * @return
     */
    @RequestMapping("update")
    public ResultModel<Object> update(Shop shop) {
        try {
            shopService.updateById(shop);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 商品名去重
     */
    @RequestMapping("findByProductName")
    public Boolean findByUsername (String productName) {
        try {
            QueryWrapper queryWrapper = new QueryWrapper();
            queryWrapper.eq("product_name", productName);
            queryWrapper.eq("is_del", SystemConstant.NUMBER_ONE);
            Shop shop = shopService.getOne(queryWrapper);
            if (shop == null) {
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 商品新增
     * @param shop
     * @return
     */
    @RequestMapping("add")
    public ResultModel<Object> add(Shop shop) {
        try {
            shopService.save(shop);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 批量伪删除(或恢复)
     * @param ids
     * @return
     */
    @RequestMapping("delByIds")
    public ResultModel<Object> delByIds(Integer[] ids, Integer isDel) {
        try {
            UpdateWrapper<Shop> updateWrapper = new UpdateWrapper();
            updateWrapper.set("is_del", isDel);
            updateWrapper.in("id", ids);
            shopService.update(updateWrapper);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 超市管理展示
     * @param shop
     * @param price1
     * @param pageNo
     * @param session
     * @return
     */
    @RequestMapping("show")
    public ResultModel<Object> show(Shop shop, Integer price1, Integer pageNo, HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        User user = (User) session.getAttribute("user");
        try {
            PageHelper.startPage(pageNo, SystemConstant.NUMBER_TWO);
            QueryWrapper<Shop> wrapper = new QueryWrapper<>();
            if (!StringUtils.isEmpty(shop.getProductName())) {
                wrapper.like("product_name", shop.getProductName());
            }
            if (null != shop.getStatus()) {
                wrapper.eq("status", shop.getStatus());
            }
            if (null != shop.getPrice() && null != price1) {
                wrapper.between("price", shop.getPrice(), price1);
            }
            wrapper.eq("is_del", SystemConstant.NUMBER_ONE);
            wrapper.eq("status", SystemConstant.NUMBER_ONE);
            List<Shop> shopList = shopService.list(wrapper);
            PageInfo<Shop> pageInfo = new PageInfo<Shop>(shopList);
            map.put("totalNum", pageInfo.getPages());
            map.put("shopList", shopList);
            return new ResultModel<>().success(map);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 修改库存
     * @param shop
     * @return
     */
    @RequestMapping("updateNumberById")
    public ResultModel<Object> updateNumberById(Shop shop) {
        try {
            Shop shop1 = shopService.getById(shop.getId());
            Integer number = shop.getNumber() + shop1.getNumber();
            shop.setNumber(number);
            shopService.updateById(shop);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 用户购买商品
     * @param userShop
     * @return
     */
    @RequestMapping("addUserShop")
    public ResultModel<Object> addUserShop(UserShop userShop, Integer shopId) {
        try {
            Shop shop = shopService.getById(shopId);
            if (shop.getNumber() < userShop.getNumber()) {
                return new ResultModel<>().error(SystemConstant.NOT_NUMBER);
            }
            Double sumPrice = shop.getPrice() * userShop.getNumber();
            User user = userService.getById(userShop.getUserId());
            if (user.getMoney() < sumPrice) {
                return new ResultModel<>().error(SystemConstant.Not_MONEY);
            }
            shopService.userShopSaveAndUserUpdateAndShopUpdate(userShop, shopId);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 充值金额
     * @param user
     * @return
     */
    @RequestMapping("updateMoneyById")
    public ResultModel<Object> updateMoneyById(User user) {
        try {
            User user1 = userService.getById(user.getId());
            user.setMoney(Double.valueOf(user.getMoney() + user1.getMoney()));
            userService.updateById(user);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 获取用户剩余金额
     * @param id
     * @return
     */
    @RequestMapping("getMoneyById/{id}")
    public ResultModel<Object> getMoneyById(@PathVariable Integer id) {
        try {
            User user = userService.getById(id);
            return new ResultModel<>().success(user.getMoney());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }
}
