package com.dj.shop.common;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.dj.shop.pojo.RoleResource;
import com.dj.shop.pojo.User;
import com.dj.shop.service.RoleResourceService;
import com.dj.shop.service.UserService;
import lombok.SneakyThrows;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class ShiroRealm extends AuthorizingRealm {

    @Autowired
    private UserService userService;

    @Autowired
    private RoleResourceService roleResourceService;

    /**
     * 授权
     * @param principalCollection
     * @return
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        SimpleAuthorizationInfo simpleAuthorizationInfo = new SimpleAuthorizationInfo();
        //获取当前登录用户权限信息
        Session session = SecurityUtils.getSubject().getSession();
        List<RoleResource> roleResourceList = (List<RoleResource>) session.getAttribute("roleResourceList");
        for (RoleResource resource : roleResourceList) {
            simpleAuthorizationInfo.addStringPermission(resource.getUrl());
        }
        return simpleAuthorizationInfo;
    }

    /**
     * 认证-登录
     * @param authenticationToken
     * @return
     * @throws AuthenticationException
     */
    @SneakyThrows
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        // 得到用户名
        String username = (String) authenticationToken.getPrincipal();
        // 得到密码
        String password = new String((char[]) authenticationToken.getCredentials());
        try {
            QueryWrapper<User> queryWrapper1 = new QueryWrapper();
            queryWrapper1.eq("username", username);
            QueryWrapper<User> queryWrapper = new QueryWrapper<>();
            queryWrapper.or(i -> i.eq("username", username)
                    .or().eq("email", username)
                    .or().eq("phone", username));
            queryWrapper.eq("password", password);
            User user = userService.getOne(queryWrapper);
            QueryWrapper<RoleResource> queryWrapper2 = new QueryWrapper();
            queryWrapper2.eq("role_id", user.getRole());
            List<RoleResource> roleResourceList = roleResourceService.list(queryWrapper2);
            if (null == user) {
                throw new AccountException(SystemConstant.NAME_PWD_ERROR);
            }
            if (user.getIsDel() != 1) {
                throw  new UnknownAccountException(SystemConstant.DEL);
            }
            Session session = SecurityUtils.getSubject().getSession();
            session.setAttribute("user", user);
            session.setAttribute("roleResourceList", roleResourceList);
        } catch (Exception e){
            throw new AccountException(e.getMessage());
        }
        return new SimpleAuthenticationInfo(username, password, getName());
    }
}
