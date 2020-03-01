package com.dj.shop.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("user")
public class User {

    /**
     * 主键id
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 用户名
     */
    private String username;

    /**
     * 密码
     */
    private String password;


    /**
     * 性别
     */
    private Integer sex;

    /**
     * 手机号
     */
    private String phone;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 验证码
     */
    private String code;

    /**
     * 盐
     */
    private String salt;

    /**
     * 余额
     */
    private Double money;

    /**
     * 角色: 1普通用户 2上架 3管理员
     */
    private Integer role;

    /**
     * 显示状态 -1已删除, 1正常
     */
    private Integer isDel;


    /**
     * 存入验证码时间
     */
    private Date codeTime;




}
