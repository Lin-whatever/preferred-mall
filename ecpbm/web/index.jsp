<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>电商平台后台管理系统 - 入口</title>
    <!-- 可选：添加简单加载提示，避免转发延迟时页面空白 -->
    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f5f5f5;
            font-family: "微软雅黑";
            color: #666;
        }
    </style>
</head>
<body>
<!-- 核心：直接转发到登录页，用户无感知跳转 -->
<jsp:forward page="admin_login.jsp" />

<!-- 转发延迟时的备用提示（正常情况看不到） -->
<div>正在跳转到登录页... 若未跳转，请点击 <a href="admin_login.jsp">这里</a></div>
</body>
</html>