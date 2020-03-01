<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/jquery.validate.js"></script>
    <script src="https://static.runoob.com/assets/jquery-validation-1.14.0/dist/localization/messages_zh.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/md5/md5-min.js"></script>
    <script type="text/javascript">

        function update (){
            var index = layer.load(1,{shade:0.5});
            $.post(
                "<%=request.getContextPath()%>/user/update",
                $("#fm").serialize(),
                function(data){
                    if (data.code != -1) {
                        layer.msg(data.msg, {icon: 6}, function(){
                            parent.window.location.href = "<%=request.getContextPath()%>/user/toList";
                        });
                        return;
                    }
                    layer.msg(data.msg, {icon: 5})
                    layer.close(index);

                }
            )
        }

        $(function(){
            $("#fm").validate({
                //效验规则
                rules: {
                    password:{
                        required:true,
                        minlength:1,
                        digits:true
                    },
                    password2:{
                        required:true,
                        minlength:1,
                        digits:true,
                        equalTo:"#pwd"
                    },
                },
                messages:{
                    password:{
                        required:"请填写密码",
                        minlength:"最少5个字儿",
                        digits:"只能是数字"
                    },
                    password2:{
                        required:"请确认密码",
                        minlength:"最少5个字儿",
                        digits:"只能是数字",
                        equalTo:"两次输入密码不同"
                    },
                },
            })
        })

        $.validator.setDefaults({
            submitHandler: function() {
                var index = layer.load(1,{shade:0.5});
                var pwd = md5($("#pwd").val());
                var salt = $("#salt").val();
                var md5pwd = md5(pwd + salt);
                $("#pwd").val(md5pwd);
                $("#pwd2").val(md5pwd);
                /* layer.confirm('确定添加吗?', {icon: 3, title:'提示'}, function(index){ */
                $.post("<%=request.getContextPath()%>/user/updatePwdByEmail",
                    $("#fm").serialize(),
                    function(data){
                        if(data.code == -1){
                            layer.msg(data.msg, {icon: 5});
                            layer.close(index);
                            return
                        }
                        layer.msg(data.msg, {
                            icon: 6,
                            time: 2000
                        }, function(){
                            layer.close(index);
                            window.location.href = "<%=request.getContextPath()%>/user/toLogin";
                        });
                    }
                )
                /*  });
                 layer.close(index); */
            }
        });

    </script>
    <!-- 错误时提示颜色 -->
    <style>
        .error{
            color:red;
        }
    </style>
</head>
<body>

<form id = "fm">
    <input type="hidden" name="email" value="${email}"><br />
    <input type="hidden" name="salt" value="${salt}" id="salt"><br />
    请输入密码:<input type="password" name="password" id="pwd"><br />
    请确认密码:<input type="password" name="password2" id="pwd2"><br />
    <input type="submit" value="提交" ><br />
</form>
</body>
</html>