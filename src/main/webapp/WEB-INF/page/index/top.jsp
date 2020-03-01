<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/My97DatePicker/WdatePicker.js"></script>
</head>
<body align="center">
	<h1>欢迎${user.username}来到点金图书馆</h1>
	<a href="<%=request.getContextPath()%>/user/toLogin">退出</a>
	
	<div id="datetime" align="right" style="color:black">
		 <script>
	 			setInterval("document.getElementById('datetime').innerHTML=new Date().toLocaleString();", 1000);
	 	  </script>
	</div>
</body>
</html>