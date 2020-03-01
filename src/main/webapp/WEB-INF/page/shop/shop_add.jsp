<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/jquery.validate.js"></script>
    <script src="https://static.runoob.com/assets/jquery-validation-1.14.0/dist/localization/messages_zh.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
    <script type="text/javascript">

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
                    },
                    price:{
                        required:true,
                    }
                },
                messages:{
                    productName:{
                        required:"名字必填",
                        minlength:"最少两个字儿"
                    },
                    price:{
                        required:"价格必填",
                    }
                },
            })
        })

        $.validator.setDefaults({
            submitHandler: function() {
                var index = layer.load(1,{shade:0.5});
                /* layer.confirm('确定添加吗?', {icon: 3, title:'提示'}, function(index){ */
                $.post("<%=request.getContextPath()%>/shop/add",
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
                            parent.window.location.href = "<%=request.getContextPath()%>/shop/toList";
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
<form id="fm">
    商品名:<input type="text" name="productName" id="productName"><br />
    价格:<input type="text" name="price" id="price" oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1').replace(/^0{1,}/g,'')" placeholder="请输入单价" ><br />
    <input type="hidden" name="isDel" value="1">
    <input type="hidden" name="userId" value="${user.id}">
    <input type="hidden" name="status" value="1">
    <input type="submit" value="添加">
</form>
</body>
</html>