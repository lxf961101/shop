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
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/jquery.validate.js"></script>
    <script src="https://static.runoob.com/assets/jquery-validation-1.14.0/dist/localization/messages_zh.js"></script>
    <script type="text/javascript">

        <%--function update (){--%>
        <%--    var index = layer.load(1,{shade:0.5});--%>
        <%--    $.post(--%>
        <%--        "<%=request.getContextPath()%>/shop/update",--%>
        <%--        $("#fm").serialize(),--%>
        <%--        function(data){--%>
        <%--            if (data.code != -1) {--%>
        <%--                layer.msg(data.msg, {icon: 6}, function(){--%>
        <%--                    parent.window.location.href = "<%=request.getContextPath()%>/shop/toList";--%>
        <%--                });--%>
        <%--                return;--%>
        <%--            }--%>
        <%--            layer.msg(data.msg, {icon: 5})--%>
        <%--            layer.close(index);--%>

        <%--        }--%>
        <%--    )--%>
        <%--}--%>


        $(function(){
            $("#fm").validate({
                //效验规则
                rules: {
                    productName:{
                        required:true,
                        minlength:2,
                        remote: {
                            type: 'POST',
                            url: "<%=request.getContextPath()%>/shop/findByProductName",
                            data:{
                                productName:function() {
                                    return $("#productName").val();
                                },
                                dataType:"json",
                                dataFilter:function(data,type){
                                    if (data == 'true'){
                                        return true;
                                    }else {
                                        return false	;
                                    }
                                }
                            }
                        }
                    }
                },
                messages:{
                    productName:{
                        required:"名字必填",
                        minlength:"最少两个字儿"
                    }
                },
            })
        })

        $.validator.setDefaults({
            submitHandler: function() {
                var index = layer.load(1,{shade:0.5});
                $.post(
                    "<%=request.getContextPath()%>/shop/update",
                    $("#fm").serialize(),
                    function(data){
                        if (data.code != -1) {
                            layer.msg(data.msg, {icon: 6}, function(){
                                parent.window.location.href = "<%=request.getContextPath()%>/shop/toList";
                            });
                            return;
                        }
                        layer.msg(data.msg, {icon: 5})
                        layer.close(index);

                    }
                )
            }
        });
    </script>
</head>
<body>

<form id = "fm">
    <input type="hidden" name="id" value="${shop.id}"><br />
    商品名称<input type="text" name="productName" id="productName" value="${shop.productName}"><br />
    价格:<input type="text" name="price" value="${shop.price}"><br />
    <input type="submit" value="修改提交"><br />
</form>
</body>
</html>