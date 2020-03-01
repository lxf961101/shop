package com.dj.shop.web;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.dj.shop.common.JavaEmailUtils;
import com.dj.shop.common.ResultModel;
import com.dj.shop.common.SystemConstant;
import com.dj.shop.pojo.RoleResource;
import com.dj.shop.pojo.Shop;
import com.dj.shop.pojo.User;
import com.dj.shop.service.RoleResourceService;
import com.dj.shop.service.UserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/user/")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private RoleResourceService roleResourceService;

    /**
     * 用户登录
     * @param username
     * @param password
     * @param session
     * @return
     */
    @RequestMapping("login")
    public ResultModel<Object> login (String username, String password, HttpSession session) {
        try {
            if (StringUtils.isEmpty(username) || StringUtils.isEmpty(password)) {
                return new ResultModel<Object>().error(SystemConstant.NAME_PWD_EMPTY);
            }
            //shiro 登录方式
            Subject subject = SecurityUtils.getSubject();
            UsernamePasswordToken token = new UsernamePasswordToken(username, password);
            subject.login(token);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 用户注册
     * @param user
     * @return
     */
    @RequestMapping("add")
    public ResultModel<Object> add (User user){
        try {
            userService.save(user);
            return new ResultModel<Object>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.FALSE + e.getMessage());
        }

    }

    /**
     * 用户名去重
     */
    @RequestMapping("findByUsername")
    public Boolean findByUsername (String username) {
        try {
            QueryWrapper queryWrapper = new QueryWrapper();
            queryWrapper.eq("username", username);
            queryWrapper.eq("is_del", SystemConstant.NUMBER_ONE);
            User user = userService.getOne(queryWrapper);
            if (user == null) {
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 手机号去重
     */
    @RequestMapping("findByPhone")
    public Boolean findByPhone (String phone) {
        try {
            QueryWrapper queryWrapper = new QueryWrapper();
            queryWrapper.eq("phone", phone);
            queryWrapper.eq("is_del", SystemConstant.NUMBER_ONE);
            User user = userService.getOne(queryWrapper);
            if (user == null) {
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 邮箱去重
     */
    @RequestMapping("findByEmail")
    public Boolean findByEmail (String email) {
        try {
            QueryWrapper queryWrapper = new QueryWrapper();
            queryWrapper.eq("email", email);
            queryWrapper.eq("is_del", SystemConstant.NUMBER_ONE);
            User user = userService.getOne(queryWrapper);
            if (user == null) {
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取盐
     * @param username
     * @return
     */
    @RequestMapping("getSalt")
    public ResultModel<Object> getSalt(String username){
        try {
            QueryWrapper<User> queryWrapper = new QueryWrapper();
            if (username != null) {
                queryWrapper.or(i -> i.eq("username", username)
                        .or().eq("email", username)
                        .or().eq("phone", username));
                User user = userService.getOne(queryWrapper);
                ResultModel resultModel = new ResultModel();
                resultModel.setData(user.getSalt());
                return resultModel;
            }
            return new ResultModel<>().error(SystemConstant.NOT_USER);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }

    }

    /**
     * 用户展示
     * @param user
     * @param pageNo
     * @param session
     * @return
     */
    @RequestMapping("list")
    public ResultModel<Object> show(User user, Integer pageNo, HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        User user1 = (User) session.getAttribute("user");
        try {
            PageHelper.startPage(pageNo, SystemConstant.NUMBER_TWO);
            QueryWrapper<User> queryWrapper = new QueryWrapper<>();
            if (!StringUtils.isEmpty(user.getUsername())) {
                queryWrapper.or(i -> i.like("username", user.getUsername())
                        .or().like("email", user.getUsername())
                        .or().like("phone", user.getUsername()));
            }
            if (!user1.getRole().equals(SystemConstant.NUMBER_THREE)) {
                queryWrapper.eq("id", user1.getId());
            }
            if (user.getSex() != null) {
                queryWrapper.eq("sex", user.getSex());
            }
            if (user.getRole() != null) {
                queryWrapper.eq("role", user.getRole());
            }
            queryWrapper.eq("is_del", user.getIsDel());
            List<User> userList = userService.list(queryWrapper);
            PageInfo<User> pageInfo = new PageInfo<User>(userList);
            map.put("totalNum", pageInfo.getPages());
            map.put("userList", userList);
            return new ResultModel<>().success(map);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 修改
     * @param user
     * @return
     */
    @RequestMapping("update")
    public ResultModel<Object> update(User user) {
        try {
            userService.updateById(user);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 伪删除
     * @param id
     * @return
     */
    @RequestMapping("delById")
    public ResultModel<Object> delByIds(Integer id, Integer isDel) {
        try {
            UpdateWrapper<User> updateWrapper = new UpdateWrapper();
            updateWrapper.set("is_del", isDel);
            updateWrapper.eq("id", id);
            userService.update(updateWrapper);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 获取邮箱验证码
     * @param user
     * @return
     */
    @RequestMapping("getEmailCode")
    public ResultModel<Object> getEmailCode(User user) {
        try {
            if (StringUtils.isEmpty(user.getEmail())) {
                return new ResultModel<Object>().error(SystemConstant.NOT_EMAIL_EMPTY);
            }
            QueryWrapper<User> queryWrapper = new QueryWrapper();
            queryWrapper.eq("email", user.getEmail());
            User user2 = userService.getOne(queryWrapper);
            if (user2 == null) {
                return new ResultModel<Object>().error(SystemConstant.NOT_EMAIL);
            }
            if (user2.getIsDel().equals(SystemConstant.NUMBER_MINUS_ONE)) {
                return new ResultModel<Object>().error(SystemConstant.DEL);
            }
            String random = String.valueOf((int)((Math.random()*9+1)*1000));
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MINUTE, 5);
            UpdateWrapper<User> updateWrapper = new UpdateWrapper();
            updateWrapper.set("code", random);
            updateWrapper.set("code_time", calendar.getTime());
            updateWrapper.eq("email", user.getEmail());
            userService.update(updateWrapper);
            JavaEmailUtils.sendEmail(user.getEmail(), SystemConstant.CODE, random);
            return new ResultModel<Object>().success();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 邮箱验证码验证
     * @param user
     * @return
     */
    @RequestMapping("EmailCode")
    public ResultModel<Object> EmailCodeLogin(User user) {
        try {
            QueryWrapper<User> queryWrapper = new QueryWrapper();
            queryWrapper.eq("email", user.getEmail());
            User user2 = userService.getOne(queryWrapper);
            if (user2 == null) {
                return new ResultModel<Object>().error(SystemConstant.ERROR_EMAIL_CODE);
            }
            if (user2.getIsDel().equals(SystemConstant.NUMBER_MINUS_ONE)) {
                return new ResultModel<Object>().error(SystemConstant.DEL);
            }
            if (System.currentTimeMillis() > user2.getCodeTime().getTime()) {
                return new ResultModel<Object>().error(SystemConstant.ERROR_CODE);
            }
            return new ResultModel<Object>().success();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

    /**
     * 修改密码
     * @param user
     * @return
     */
    @RequestMapping("updatePwdByEmail")
    public ResultModel<Object> updatePwdByEmail(User user) {
        try {
            UpdateWrapper<User> updateWrapper = new UpdateWrapper();
            updateWrapper.set("password", user.getPassword());
            updateWrapper.set("salt", user.getSalt());
            updateWrapper.eq("email", user.getEmail());
            userService.update(updateWrapper);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.FALSE + e.getMessage());
        }
    }

}


