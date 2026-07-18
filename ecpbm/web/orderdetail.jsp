<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div style="padding:15px;">
	<!-- 订单主信息 -->
	<table style="width:100%; border-collapse:collapse; margin-bottom:20px;">
		<tr>
			<td width="100" align="right" style="padding:8px;">客户名称：</td>
			<td style="padding:8px; font-weight:bold;">${oi.ui.userName}</td>
			<td width="100" align="right" style="padding:8px;">订单金额：</td>
			<td style="padding:8px; font-weight:bold; color:red;">¥${oi.orderprice}</td>
		</tr>
		<tr>
			<td align="right" style="padding:8px;">订单日期：</td>
			<td style="padding:8px;">${oi.ordertime}</td>
			<td align="right" style="padding:8px;">订单状态：</td>
			<td style="padding:8px;">
				<c:if test="${oi.status == '已付款'}">
					<span style="color:green; font-weight:bold;">已付款</span>
				</c:if>
				<c:if test="${oi.status == '未付款'}">
					<span style="color:red; font-weight:bold;">未付款</span>
				</c:if>
			</td>
		</tr>
	</table>

	<!-- 订单明细表格 -->
	<table id="detailDg" class="easyui-datagrid" style="width:100%;"
		   data-options="fit:true, pagination:false, rownumbers:true, singleSelect:true">
		<thead>
		<tr>
			<th data-options="field:'pi', title:'商品名称', width:200, align:'center',
                formatter: function(value) {
                    return value ? value.name : '';
                }">商品名称</th>
			<th data-options="field:'price', title:'单价', width:100, align:'center', formatter:formatPrice">单价</th>
			<th data-options="field:'num', title:'数量', width:80, align:'center'">数量</th>
			<th data-options="field:'totalprice', title:'小计', width:100, align:'center', formatter:formatPrice">小计</th>
		</tr>
		</thead>
	</table>
</div>

<script type="text/javascript">
	var basePath = '${pageContext.request.contextPath}/';

	// 格式化金额为人民币格式
	function formatPrice(value) {
		if (value == null) return '¥0.00';
		return '¥' + parseFloat(value).toFixed(2);
	}

	$(function() {
		// 加载订单明细数据
		$('#detailDg').datagrid({
			url: basePath + 'orderinfo/getOrderDetails?oid=${oi.id}',
			method: 'get',
			onLoadSuccess: function(data) {
				if (data.length === 0) {
					$(this).datagrid('appendRow', {pi:{productName:'<span style="color:#999">暂无明细数据</span>'}})
							.datagrid('mergeCells', {index:0, field:'pi.productName', colspan:4, align:'center'});
				}
			}
		});
	});
</script>