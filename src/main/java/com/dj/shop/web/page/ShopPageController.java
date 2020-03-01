package com.dj.shop.web.page;

import com.dj.shop.common.PasswordSecurityUtil;
import com.dj.shop.pojo.Shop;
import com.dj.shop.pojo.UserShop;
import com.dj.shop.service.ShopService;
import com.dj.shop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/shop/")
public class ShopPageController {

    @Autowired
    private ShopService shopService;

    /**
     * 去展示页面
     */
    @RequestMapping("toList")
    private String toList() {
        return "shop/shop_list";
    }

    /**
     * 去修改页面
     */
    @RequestMapping("toUpdate/{id}")
    public String toUpdate(@PathVariable Integer id, Model model) {
        Shop shop = shopService.getById(id);
        model.addAttribute("shop", shop);
        return "shop/shop_update";
    }

    /**
     * 去修改库存页面
     */
    @RequestMapping("toUpdateNumber/{id}")
    public String toUpdateNumber(@PathVariable Integer id, Model model) {
        Shop shop = shopService.getById(id);
        model.addAttribute("shop", shop);
        return "shop/shop_update_number";
    }

    /**
     * 去新增页面
     */
    @RequestMapping("toAdd")
    private String toAdd() {
        return "shop/shop_add";
    }

    /**
     * 去展示页面
     */
    @RequestMapping("toShow")
    private String toShow() {
        return "shop/shop_show";
    }

    /**
     * 去回收站
     */
    @RequestMapping("toDelRenew")
    private String toDelRenew() {
        return "del/del_renew";
    }

    /**
     * 去充值页面
     */
    @RequestMapping("toUpdateMoney/{id}")
    public String toUpdateMoney(@PathVariable Integer id, Model model) {
        model.addAttribute("id", id);
        return "shop_update_money";
    }

    /**
     * 去用户恢复页面
     */
    @RequestMapping("toUserUpdate")
    private String toUserUpdate() {
        return "del/del_user_update";
    }

    /**
     * 去商品恢复页面
     */
    @RequestMapping("toShopUpdate")
    private String toShopUpdate() {
        return "del/del_shop_update";
    }
}
