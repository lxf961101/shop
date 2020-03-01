<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
</head>
<frameset rows="20%,80%">
	<frame src="<%=request.getContextPath()%>/index/toTop" name="top">
	<frameset cols="20%,80%">
		<frame src="<%=request.getContextPath()%>/index/toLeft" name="left">
		<frame src="<%=request.getContextPath()%>/index/toRight" name="right">
	</frameset>
</frameset>
</html>