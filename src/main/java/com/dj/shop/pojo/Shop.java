package com.dj.shop.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("shop")
public class Shop {

    /**
     * 主键id
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 用户id
     */
    private String userId;

    /**
     * 商品名
     */
    private String productName;

    /**
     * 状态 1为上架 2为下架
     */
    private Integer status;

    /**
     * 显示状态 -1已删除, 1正常
     */
    private Integer isDel;

    /**
     * 数量
     */
    private Integer number;

    /**
     * 价格
     */
    private Double price;

}
