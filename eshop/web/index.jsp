<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>后台接口测试</title>
</head>
<body>
<a href="product/getProduct"> 查询所有商品</a><br>
<a href="product/getProductById/1"> 查询id=1的商品</a><br>
<form action="order/handlerOrder" method="get">
  <input type="submit" value="保存订单" />
</form>
</body>
</html>