package com.dj.shop.pojo;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("role_resource")
public class RoleResource {

    /**
     * 角色id
     */
    private Integer roleId;

    /**
     * 资源路径
     */
    private String url;

    /**
     * 展示:1展示 2伪删除
     */
    private Integer isDel;
}
