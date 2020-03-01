package com.dj.shop.web.page;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.dj.shop.common.PasswordSecurityUtil;
import com.dj.shop.common.SystemConstant;
import com.dj.shop.pojo.Shop;
import com.dj.shop.pojo.User;
import com.dj.shop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user/")
public class UserPageController {

    @Autowired
    private UserService userService;

    /**
     * 去登录页面
     */
    @RequestMapping("toLogin")
    private String toLogin() {
        return "user/user_login";
    }

    /**
     * 去注册页面
     */
    @RequestMapping("toAdd")
    private String toAdd(Model model) throws Exception {
        String salt = PasswordSecurityUtil.generateSalt();
        model.addAttribute("salt", salt);
        return "user/user_add";
    }

    /**
     * 去展示页面
     */
    @RequestMapping("toList")
    private String toList() {
        return "user/user_list";
    }

    /**
     * 去邮箱验证页面
     */
    @RequestMapping("toResetPwd")
    private String toResetPwd() {
        return "user/user_email";
    }

    /**
     * 去重置密码页面
     */
    @RequestMapping("toUserUpdatePwd/{email}")
    private String toResetPwd(@PathVariable String email, Model model) throws Exception {
        String salt = PasswordSecurityUtil.generateSalt();
        model.addAttribute("salt", salt);
        model.addAttribute("email", email);
        return "user/user_update_pwd";
    }

    /**
     * 去修改页面
     */
    @RequestMapping("toUpdate/{id}")
    public String toUpdate(@PathVariable Integer id, Model model) {
        User user = userService.getById(id);
        model.addAttribute("user", user);
        return "user/user_update";
    }

    /**
     * 去授权页面
     */
    @RequestMapping("toUpdateRoleById/{id}")
    public String toUpdateRoleById(@PathVariable Integer id, Model model) throws Exception {
        User user = userService.getById(id);
        model.addAttribute("user1", user);
        return "user/user_update_pwd";
    }

}
