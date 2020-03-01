package com.dj.shop.pojo;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

@Data
@TableName("user_shop")
public class UserShop {

    /**
     * 用户id
     */
    private String userId;

    /**
     * 商品名
     */
    private String productName;


    /**
     * 价格
     */
    private Double price;

    /**
     * 数量
     */
    private Integer number;

    /**
     * 购买时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date buyTime;

    /**
     * 显示状态 -1已删除, 1正常
     */
    private Integer isDel;






}
