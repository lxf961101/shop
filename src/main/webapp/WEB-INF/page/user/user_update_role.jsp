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

    </script>
</head>
<body>

<form id = "fm">
    <input type="hidden" name="id" value="${user1.id}"><br />
    角色:
    普通用户<input type="radio" name="role" value="1" <c:if test="${user1.role == 1}">checked</c:if>>
    商家<input type="radio" name="role" value="2" <c:if test="${user1.role == 2}">checked</c:if>>
    管理员<input type="radio" name="role" value="3" <c:if test="${user1.role == 3}">checked</c:if>><br />
    <input type="button" value="修改提交" onclick="update()" ><br />
</form>
</body>
</html>