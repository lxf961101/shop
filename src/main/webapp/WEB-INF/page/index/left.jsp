<%@ page language="java" contentType="text/html; charset=utf-8"
		 pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Insert title here</title>
</head>
<body>
	<shiro:hasPermission name="shop:list">
		<a href="<%=request.getContextPath()%>/shop/toList" target="right">超市管理</a><br />
	</shiro:hasPermission>
	<shiro:hasPermission name="user:list">
		<a href="<%=request.getContextPath()%>/user/toList" target="right">用户展示</a><br />
	</shiro:hasPermission>
	<shiro:hasPermission name="shop:show">
	<a href="<%=request.getContextPath()%>/shop/toShow" target="right">超市展示</a><br />
	</shiro:hasPermission>
	<shiro:hasPermission name="del:renew">
		<a href="<%=request.getContextPath()%>/shop/toDelRenew" target="right">回收站展示</a><br />
	</shiro:hasPermission>

</body>
</html>