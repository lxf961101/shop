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
	function get(){
		var index = layer.load(1,{shade:0.5});
	    $.post(
				"<%=request.getContextPath()%>/user/getEmailCode",
				{"email":$("#email").val()},
				function (data) {
					layer.close(index);
					if (data.code==200){
						layer.alert("你的验证码为已发送邮箱,请前往获取");
						  var send = document.getElementById('btnSendCode'), //按钮ID
					        times = 60, 
					        timer = null;
					        // 计时开始
					        send.disabled = true;
					        timer = setInterval(function () {
					            times--;
					            if (times <= 0) {
					                send.value = '获取验证码';
					                clearInterval(timer);
					                times = 1;  // 别忘了改这里
					                send.disabled = false;
					            } else {
					                send.value = times + '秒后重试'
					                send.disabled = true;
					            } console.log(times)
					        }, 1000);
					} else {
						layer.msg(data.msg, {icon: 5});
					}
				})
	}

	$(function(){
		$("#fm").validate({
			//效验规则
			rules: {
				email:{
					required:true,
				},
				code:{
					required:true,
				}
			},
			messages:{
				email:{
					required:"邮箱必填",
				},
				code:{
					required:"验证码必填",
				}
			},
		})
	})

	$.validator.setDefaults({
		submitHandler: function() {
			var index = layer.load(1,{shade:0.5});
			$.post("<%=request.getContextPath()%>/user/EmailCode",
					{"email":$("#email").val(),"code":$("#code").val()},
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
							window.location.href = "<%=request.getContextPath()%>/user/toUserUpdatePwd/"+$("#email").val();
						});
					}
			)
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
	收件人邮箱<input type="text" name="email" id="email" /><br />
	<input type = "text" name = "code" id="code" placeholder="请输入验证码">
	<input id="btnSendCode" type="button" value="获取验证码"  onclick="get()" />
	<input type="submit" value="验证">
</form>
</body>
</html>