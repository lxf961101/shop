<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/md5/md5-min.js"></script>
    <script type="text/javascript">

        //判断当前窗口路径与加载路径是否一致。
        if(window.top.document.URL != document.URL){
            //将窗口路径与加载路径同步
            window.top.location = document.URL;
        }

        //登录方法
        function login(){
            var index = layer.load(1,{shade:0.5});
            var pwd = md5($("#pwd").val());
            var salt = $("#salt").val();
            var md5pwd = md5(pwd + salt);
            $("#pwd").val(md5pwd);
            $.post(
                "<%=request.getContextPath()%>/user/login",
                $("#fm").serialize(),
                function(data){
                    if (data.code != -1) {
                        layer.msg(data.msg, {icon: 6}, function(){
                            window.location.href = "<%=request.getContextPath()%>/index/toIndex";
                        });
                        return;
                    }
                    layer.msg(data.msg, {icon: 5})
                    layer.close(index);
                }
            )
           // });
        }

        function getSalt(obj) {
            $.post(
                "<%=request.getContextPath()%>/user/getSalt",
                {"username": obj.value},
                function(data){
                    if (data.code == 200) {
                        $("#salt").val(data.data);
                    }
            }
            )
        }
    </script>
</head>
<body>
<form id="fm">
    <input type="hidden" name="salt" id="salt">
    <input type="text" name="username" placeholder="请输入用户名/手机号/邮箱" onblur="getSalt(this)" /><br />
    <input type="password" name="password" placeholder="请输入密码" id="pwd"/><br />
    <a href="<%=request.getContextPath()%>/user/toAdd">还没有账号?点我去注册!</a><br />
    <a href="<%=request.getContextPath()%>/user/toResetPwd">忘记密码?点我找回!</a><br />
    <input type="button" value="登录" onclick="login()" /><br />
</form>
</body>
</html>