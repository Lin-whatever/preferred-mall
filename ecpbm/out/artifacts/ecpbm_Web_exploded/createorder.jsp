<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>创建订单</title>
    <link href="EasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css"/>
    <link href="EasyUI/themes/icon.css" rel="stylesheet" type="text/css"/>
    <script src="EasyUI/jquery.min.js" type="text/javascript"></script>
    <script src="EasyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="EasyUI/easyui-lang-zh_CN.js" type="text/javascript"></script>
</head>
<body style="padding: 10px;">
<!-- 订单信息表单 -->
<form id="orderForm" method="post">
    <div class="easyui-panel" style="margin-bottom: 10px; padding: 10px;">
        <table style="width: 100%; border-collapse: separate; border-spacing: 10px;">
            <tr>
                <td width="100" align="right">客户选择：</td>
                <td>
                    <select class="easyui-combobox" name="userId" id="userId" required
                            data-options="url:'userinfo/listAll',valueField:'id',textField:'userName',panelHeight:'auto'"
                            style="width: 200px;">
                    </select>
                </td>
                <td width="100" align="right">订单编号：</td>
                <td>
                    <input class="easyui-textbox" name="orderNo" id="orderNo" readonly style="width: 200px;">
                </td>
                <td width="100" align="right">下单日期：</td>
                <td>
                    <input class="easyui-datebox" name="orderDate" required style="width: 200px;">
                </td>
            </tr>
            <tr>
                <td align="right">客户姓名：</td>
                <td>
                    <input class="easyui-textbox" id="realName" readonly style="width: 200px;">
                </td>
                <td align="right">联系地址：</td>
                <td colspan="3">
                    <input class="easyui-textbox" id="address" readonly style="width: 500px;">
                </td>
            </tr>
        </table>
    </div>

    <!-- 商品选择区域 -->
    <div class="easyui-panel" style="margin-bottom: 10px; padding: 10px;">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="openProductDialog()">选择商品</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="removeSelectedProduct()">删除选中商品</a>
    </div>

    <!-- 已选商品列表 -->
    <table id="orderItemGrid" class="easyui-datagrid"
           data-options="fit:true,border:false,rownumbers:true,singleSelect:false">
        <thead>
        <tr>
            <th data-options="field:'productId',width:80,align:'center'">商品ID</th>
            <th data-options="field:'productName',width:150,align:'center'">商品名称</th>
            <th data-options="field:'unitPrice',width:80,align:'center',formatter:formatPrice">单价(¥)</th>
            <th data-options="field:'quantity',width:80,align:'center',editor:{type:'numberbox',options:{min:1}}">数量</th>
            <th data-options="field:'subtotal',width:100,align:'center',formatter:formatPrice">小计(¥)</th>
            <th data-options="field:'stock',width:80,align:'center',hidden:true">库存</th>
        </tr>
        </thead>
    </table>

    <!-- 订单总价区域 -->
    <div style="text-align: right; margin-top: 10px; font-size: 16px; font-weight: bold;">
        订单总价：<span id="totalAmount" style="color: #f00;">¥0.00</span>
    </div>

    <!-- 备注区域 -->
    <div style="margin-top: 10px;">
        <textarea class="easyui-textbox" name="remark" multiline="true" style="width: 100%; height: 80px;" placeholder="请输入订单备注（可选）"></textarea>
    </div>

    <!-- 提交按钮 -->
    <div style="text-align: center; margin-top: 20px;">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" onclick="submitOrder()" style="width: 120px;">提交订单</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="resetOrder()" style="width: 120px;">重置</a>
    </div>
</form>

<!-- 商品选择对话框 -->
<div id="productDialog" class="easyui-dialog"
     style="width: 600px; height: 400px;"
     closed="true" modal="true" title="选择商品">
    <div class="easyui-panel" style="padding: 10px; margin-bottom: 10px;">
        商品名称：<input class="easyui-textbox" id="productName" placeholder="请输入商品名称" style="width: 200px;">
        商品类型：<select class="easyui-combobox" id="typeId" style="width: 150px;"
                         data-options="url:'type/listAll',valueField:'id',textField:'name',panelHeight:'auto'">
        <option value="">全部类型</option>
    </select>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="searchProduct()">查询</a>
    </div>
    <table id="productGrid" class="easyui-datagrid"
           data-options="fit:true,border:false,rownumbers:true,singleSelect:false,
               url:'product/listAll',method:'get',checkbox:true">
        <thead>
        <tr>
            <th data-options="field:'id',width:80,align:'center'">商品ID</th>
            <th data-options="field:'name',width:150,align:'center'">商品名称</th>
            <th data-options="field:'price',width:80,align:'center',formatter:formatPrice">单价(¥)</th>
            <th data-options="field:'stock',width:80,align:'center'">库存</th>
            <th data-options="field:'typeName',width:120,align:'center'">商品类型</th>
        </tr>
        </thead>
    </table>
    <div style="text-align: center; margin-top: 10px;">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="addSelectedProduct()" style="width: 100px;">添加选中</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="$('#productDialog').dialog('close')" style="width: 100px;">取消</a>
    </div>
</div>

<script type="text/javascript">
    // 页面加载初始化
    $(function() {
        // 生成订单编号（年月日时分秒+随机数）
        var date = new Date();
        var orderNo = date.getFullYear() +
            (date.getMonth() + 1).toString().padStart(2, '0') +
            date.getDate().toString().padStart(2, '0') +
            date.getHours().toString().padStart(2, '0') +
            date.getMinutes().toString().padStart(2, '0') +
            date.getSeconds().toString().padStart(2, '0') +
            Math.floor(Math.random() * 1000).toString().padStart(3, '0');
        $('#orderNo').textbox('setValue', orderNo);

        // 默认选中当前日期
        $('#orderForm input[name="orderDate"]').datebox('setValue', formatDate(new Date()));

        // 客户选择变化时，加载客户信息
        $('#userId').combobox({
            onChange: function(value) {
                if (value) {
                    $.get('userinfo/findById?id='+value, function(data) {
                        $('#realName').textbox('setValue', data.realName || '');
                        $('#address').textbox('setValue', data.address || '');
                    });
                } else {
                    $('#realName').textbox('setValue', '');
                    $('#address').textbox('setValue', '');
                }
            }
        });

        // 初始化已选商品列表
        $('#orderItemGrid').datagrid({
            data: [],
            onAfterEdit: function(rowIndex, rowData, changes) {
                // 编辑数量后重新计算小计和总价
                rowData.subtotal = (rowData.unitPrice * rowData.quantity).toFixed(2);
                $('#orderItemGrid').datagrid('refreshRow', rowIndex);
                calculateTotalAmount();
            }
        });
    });

    // 格式化价格
    function formatPrice(value) {
        return value ? parseFloat(value).toFixed(2) : '0.00';
    }

    // 格式化日期
    function formatDate(value) {
        if (!value) return '';
        var date = new Date(value);
        return date.getFullYear() + '-' +
            (date.getMonth() + 1).toString().padStart(2, '0') + '-' +
            date.getDate().toString().padStart(2, '0');
    }

    // 搜索商品
    function searchProduct() {
        var params = {
            name: $('#productName').textbox('getValue'),
            typeId: $('#typeId').combobox('getValue')
        };
        $('#productGrid').datagrid('load', params);
    }

    // 添加选中商品到订单
    function addSelectedProduct() {
        var selectedProducts = $('#productGrid').datagrid('getSelections');
        if (selectedProducts.length === 0) {
            $.messager.alert('提示', '请选择要添加的商品！', 'info');
            return;
        }

        var orderItems = $('#orderItemGrid').datagrid('getData').rows;
        var newItems = [];

        $.each(selectedProducts, function(i, product) {
            // 检查商品是否已添加
            var exists = false;
            $.each(orderItems, function(j, item) {
                if (item.productId == product.id) {
                    exists = true;
                    // 已添加则提示，不重复添加
                    $.messager.alert('提示', '商品【' + product.name + '】已在订单中，请勿重复添加！', 'warning');
                    return false;
                }
            });
            if (exists) return true;

            // 构建订单商品项
            var newItem = {
                productId: product.id,
                productName: product.name,
                unitPrice: product.price,
                quantity: 1,
                subtotal: product.price.toFixed(2),
                stock: product.stock
            };
            newItems.push(newItem);
        });

        // 添加新商品并刷新列表
        if (newItems.length > 0) {
            orderItems = orderItems.concat(newItems);
            $('#orderItemGrid').datagrid('loadData', orderItems);
            calculateTotalAmount(); // 重新计算总价
        }

        $('#productDialog').dialog('close');
    }

    // 删除选中商品
    function removeSelectedProduct() {
        var selectedItems = $('#orderItemGrid').datagrid('getSelections');
        if (selectedItems.length === 0) {
            $.messager.alert('提示', '请选择要删除的商品！', 'info');
            return;
        }

        var orderItems = $('#orderItemGrid').datagrid('getData').rows;
        // 过滤掉选中的商品
        var newItems = $.grep(orderItems, function(item) {
            var isSelected = false;
            $.each(selectedItems, function(i, selected) {
                if (item.productId == selected.productId) {
                    isSelected = true;
                    return false;
                }
            });
            return !isSelected;
        });

        // 刷新列表并重新计算总价
        $('#orderItemGrid').datagrid('loadData', newItems);
        calculateTotalAmount();
    }

    // 计算订单总价
    function calculateTotalAmount() {
        var orderItems = $('#orderItemGrid').datagrid('getData').rows;
        var total = 0;
        $.each(orderItems, function(i, item) {
            total += parseFloat(item.subtotal);
        });
        $('#totalAmount').text('¥' + total.toFixed(2));
    }

    // 开始编辑数量
    function editQuantity(rowIndex) {
        $('#orderItemGrid').datagrid('beginEdit', rowIndex);
    }

    // 提交订单
    function submitOrder() {
        // 验证表单必填项
        if (!$('#orderForm').form('validate')) {
            $.messager.alert('提示', '请完善订单必填信息！', 'warning');
            return;
        }

        // 验证是否选择商品
        var orderItems = $('#orderItemGrid').datagrid('getData').rows;
        if (orderItems.length === 0) {
            $.messager.alert('提示', '请至少选择一个商品！', 'warning');
            return;
        }

        // 验证商品数量是否超过库存
        var hasStockError = false;
        $.each(orderItems, function(i, item) {
            if (item.quantity > item.stock) {
                hasStockError = true;
                $.messager.alert('库存不足', '商品【' + item.productName + '】库存仅' + item.stock + '，请减少数量！', 'error');
                return false;
            }
        });
        if (hasStockError) return;

        // 构建订单数据
        var orderData = {
            orderNo: $('#orderNo').textbox('getValue'),
            userId: $('#userId').combobox('getValue'),
            orderDate: $('#orderForm input[name="orderDate"]').datebox('getValue'),
            totalAmount: $('#totalAmount').text().replace('¥', ''),
            remark: $('#orderForm textarea[name="remark"]').val(),
            orderItems: orderItems
        };

        // 提交订单到后端
        $.ajax({
            url: 'order/create',
            type: 'post',
            data: JSON.stringify(orderData),
            contentType: 'application/json;charset=UTF-8',
            success: function(result) {
                var res = JSON.parse(result);
                if (res.success) {
                    $.messager.show({title: '成功', msg: '订单创建成功！订单编号：' + orderData.orderNo});
                    resetOrder(); // 重置订单表单
                } else {
                    $.messager.alert('失败', res.message, 'error');
                }
            },
            error: function() {
                $.messager.alert('错误', '订单提交失败，请联系管理员！', 'error');
            }
        });
    }

    // 重置订单表单
    function resetOrder() {
        $('#orderForm').form('clear');
        // 重新生成订单编号
        var date = new Date();
        var orderNo = date.getFullYear() +
            (date.getMonth() + 1).toString().padStart(2, '0') +
            date.getDate().toString().padStart(2, '0') +
            date.getHours().toString().padStart(2, '0') +
            date.getMinutes().toString().padStart(2, '0') +
            date.getSeconds().toString().padStart(2, '0') +
            Math.floor(Math.random() * 1000).toString().padStart(3, '0');
        $('#orderNo').textbox('setValue', orderNo);
        // 重置下单日期
        $('#orderForm input[name="orderDate"]').datebox('setValue', formatDate(new Date()));
        // 清空已选商品列表和总价
        $('#orderItemGrid').datagrid('loadData', []);
        $('#totalAmount').text('¥0.00');
    }
</script>
</body>
</html>