<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>订单查询</title>
    <link href="EasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css"/>
    <link href="EasyUI/themes/icon.css" rel="stylesheet" type="text/css"/>
    <script src="EasyUI/jquery.min.js" type="text/javascript"></script>
    <script src="EasyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="EasyUI/easyui-lang-zh_CN.js" type="text/javascript"></script>
</head>
<body style="padding: 10px;">
<!-- 搜索区域 -->
<div class="easyui-panel" style="padding: 10px; margin-bottom: 10px;">
    <form id="searchForm">
        订单编号：<input class="easyui-textbox" name="orderNo" style="width: 150px;">
        客户名称：<input class="easyui-textbox" name="userName" style="width: 150px;">
        订单状态：<select class="easyui-combobox" name="status" style="width: 120px;" panelHeight="auto">
        <option value="">全部</option>
        <option value="0">未付款</option>
        <option value="1">已付款</option>
        <option value="2">已发货</option>
        <option value="3">已完成</option>
        <option value="4">已取消</option>
    </select>
        日期范围：<input class="easyui-datebox" name="startDate" style="width: 120px;">
        至 <input class="easyui-datebox" name="endDate" style="width: 120px;">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="searchOrder()">查询</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload" onclick="resetSearch()">重置</a>
    </form>
</div>

<!-- 订单列表表格 -->
<table id="orderGrid" class="easyui-datagrid"
       data-options="fit:true,border:false,rownumbers:true,pagination:true,
           url:'order/list',method:'get',pageSize:10,toolbar:'#orderToolbar'">
    <thead>
    <tr>
        <th data-options="field:'id',width:60,align:'center'">ID</th>
        <th data-options="field:'orderNo',width:150,align:'center'">订单编号</th>
        <th data-options="field:'userName',width:100,align:'center'">客户名称</th>
        <th data-options="field:'totalAmount',width:100,align:'center',formatter:formatPrice">总金额(¥)</th>
        <th data-options="field:'status',width:80,align:'center',formatter:formatStatus">状态</th>
        <th data-options="field:'orderDate',width:130,align:'center',formatter:formatDate">下单时间</th>
        <th data-options="field:'operate',width:180,align:'center',formatter:operateFormatter">操作</th>
    </tr>
    </thead>
</table>

<!-- 表格工具栏 -->
<div id="orderToolbar" style="display: none;">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-view" onclick="viewOrderDetail()">查看详情</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="updateOrderStatus()">更新状态</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-print" onclick="printOrder()">打印订单</a>
</div>

<!-- 订单详情对话框 -->
<div id="detailDialog" class="easyui-dialog"
     style="width: 700px; height: 500px;"
     closed="true" modal="true" title="订单详情">
    <div id="orderDetail" style="padding: 10px; overflow: auto; height: 460px;"></div>
</div>

<!-- 状态更新对话框 -->
<div id="statusDialog" class="easyui-dialog"
     style="width: 300px; height: 200px;"
     closed="true" modal="true" title="更新订单状态">
    <form id="statusForm">
        <input type="hidden" name="id">
        <table style="margin: 30px auto;" cellpadding="5">
            <tr>
                <td align="right">订单状态：</td>
                <td>
                    <select class="easyui-combobox" name="status" required style="width: 180px;" panelHeight="auto">
                        <option value="0">未付款</option>
                        <option value="1">已付款</option>
                        <option value="2">已发货</option>
                        <option value="3">已完成</option>
                        <option value="4">已取消</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right" valign="top">备注：</td>
                <td><textarea class="easyui-textbox" name="remark" multiline="true" style="width: 180px; height: 60px;"></textarea></td>
            </tr>
        </table>
    </form>
    <div style="text-align: center; padding: 10px;">
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveStatus()">确认更新</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#statusDialog').dialog('close')">取消</a>
    </div>
</div>

<script type="text/javascript">
    // 格式化价格显示
    function formatPrice(value) {
        return value ? value.toFixed(2) : '0.00';
    }

    // 格式化日期显示
    function formatDate(value) {
        if (!value) return '';
        var date = new Date(value);
        return date.getFullYear() + '-' +
            (date.getMonth() + 1).toString().padStart(2, '0') + '-' +
            date.getDate().toString().padStart(2, '0') + ' ' +
            date.getHours().toString().padStart(2, '0') + ':' +
            date.getMinutes().toString().padStart(2, '0');
    }

    // 格式化订单状态
    function formatStatus(value) {
        var statusMap = {
            '0': '<span style="color: #f00;">未付款</span>',
            '1': '<span style="color: #00f;">已付款</span>',
            '2': '<span style="color: #0f0;">已发货</span>',
            '3': '<span style="color: #888;">已完成</span>',
            '4': '<span style="color: #f90;">已取消</span>'
        };
        return statusMap[value] || value;
    }

    // 格式化操作列
    function operateFormatter(value, row, index) {
        return '<a href="javascript:void(0)" onclick="viewOrderDetail('+row.id+')">详情</a> ' +
            '<a href="javascript:void(0)" onclick="updateOrderStatus('+row.id+')">更新状态</a> ' +
            '<a href="javascript:void(0)" onclick="printOrder('+row.id+')">打印</a>';
    }

    // 搜索订单
    function searchOrder() {
        var params = {};
        // 序列化表单数据
        $.each($('#searchForm').serializeArray(), function() {
            params[this.name] = this.value;
        });
        // 加载数据
        $('#orderGrid').datagrid('load', params);
    }

    // 重置搜索条件
    function resetSearch() {
        $('#searchForm').form('clear');
        $('#orderGrid').datagrid('load', {});
    }

    // 查看订单详情
    function viewOrderDetail(orderId) {
        var row = orderId ? null : $('#orderGrid').datagrid('getSelected');
        if (!orderId && (!row || !row.id)) {
            $.messager.alert('提示', '请选择要查看的订单！', 'info');
            return;
        }
        var id = orderId || row.id;

        // 加载订单详情
        $.get('order/detail?id=' + id, function(data) {
            if (data.success) {
                var html = '<table border="0" width="100%" cellpadding="5">';
                // 订单基本信息
                html += '<tr><td colspan="4" style="font-size: 16px; font-weight: bold; border-bottom: 1px solid #ccc;">订单信息</td></tr>';
                html += '<tr><td width="20%">订单编号：</td><td>' + data.order.orderNo + '</td>';
                html += '<td width="20%">下单时间：</td><td>' + formatDate(data.order.orderDate) + '</td></tr>';
                html += '<tr><td>客户名称：</td><td>' + data.order.userName + '</td>';
                html += '<td>订单状态：</td><td>' + formatStatus(data.order.status) + '</td></tr>';
                html += '<tr><td>联系地址：</td><td colspan="3">' + (data.order.address || '无') + '</td></tr>';
                html += '<tr><td>备注信息：</td><td colspan="3">' + (data.order.remark || '无') + '</td></tr>';

                // 订单商品列表
                html += '<tr><td colspan="4" style="font-size: 16px; font-weight: bold; border-bottom: 1px solid #ccc; margin-top: 10px;">商品清单</td></tr>';
                html += '<tr style="background-color: #f5f5f5; font-weight: bold;">';
                html += '<td>商品名称</td><td>单价</td><td>数量</td><td>小计</td></tr>';

                $.each(data.orderItems, function(i, item) {
                    html += '<tr>';
                    html += '<td>' + item.productName + '</td>';
                    html += '<td>¥' + item.unitPrice.toFixed(2) + '</td>';
                    html += '<td>' + item.quantity + '</td>';
                    html += '<td>¥' + item.subtotal.toFixed(2) + '</td>';
                    html += '</tr>';
                });

                // 订单总额
                html += '<tr><td colspan="3" align="right" style="font-weight: bold; border-top: 1px solid #ccc;">订单总额：</td>';
                html += '<td style="font-weight: bold; color: #f00; border-top: 1px solid #ccc;">¥' + data.order.totalAmount.toFixed(2) + '</td></tr>';
                html += '</table>';

                $('#orderDetail').html(html);
                $('#detailDialog').dialog('open');
            } else {
                $.messager.alert('错误', data.message, 'error');
            }
        }, 'json');
    }

    // 打开状态更新对话框
    function updateOrderStatus(orderId) {
        var row = orderId ? null : $('#orderGrid').datagrid('getSelected');
        if (!orderId && (!row || !row.id)) {
            $.messager.alert('提示', '请选择要更新的订单！', 'info');
            return;
        }
        var id = orderId || row.id;

        $('#statusForm').form('clear');
        $('input[name="id"]').val(id);
        // 回显当前状态
        if (row) {
            $('select[name="status"]').combobox('setValue', row.status);
        }
        $('#statusDialog').dialog('open');
    }

    // 保存订单状态更新
    function saveStatus() {
        $('#statusForm').form('submit', {
            url: 'order/updateStatus',
            onSubmit: function() {
                return $(this).form('validate');
            },
            success: function(result) {
                var res = JSON.parse(result);
                if (res.success) {
                    $.messager.show({title: '提示', msg: '状态更新成功'});
                    $('#statusDialog').dialog('close');
                    $('#orderGrid').datagrid('reload');
                } else {
                    $.messager.alert('错误', res.message, 'error');
                }
            }
        });
    }

    // 打印订单
    function printOrder(orderId) {
        var row = orderId ? null : $('#orderGrid').datagrid('getSelected');
        if (!orderId && (!row || !row.id)) {
            $.messager.alert('提示', '请选择要打印的订单！', 'info');
            return;
        }
        var id = orderId || row.id;

        // 打开打印窗口
        window.open('order/print?id=' + id, '_blank', 'width=800,height=600');
    }
</script>
</body>
</html>