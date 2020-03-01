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

        $(function(){
            $("#fm").validate({
                //效验规则
                rules: {
                    money:{
                        required:true,
                    }
                },
                messages:{
                    money:{
                        required:"请输入充值金额",
                    }
                },
            })
        })

        $.validator.setDefaults({
            submitHandler: function() {
                var index = layer.load(1,{shade:0.5});
                $.post(
                    "<%=request.getContextPath()%>/shop/updateMoneyById",
                    $("#fm").serialize(),
                    function(data){
                        if (data.code != -1) {
                            layer.msg(data.msg, {icon: 6}, function(){
                                parent.window.location.href = "<%=request.getContextPath()%>/shop/toShow";
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
    <input type="hidden" name="id" value="${id}">
    充值金额:
    <input type="text" name="money" oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1').replace(/^0{1,}/g,'')" placeholder="请输入充值金额"  maxlength="6"><br />
    <input type="submit" value="开始充值"><br />
</form>
</body>
</html>