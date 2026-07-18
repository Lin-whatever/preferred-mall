<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商品管理</title>
    <link href="EasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css"/>
    <link href="EasyUI/themes/icon.css" rel="stylesheet" type="text/css"/>
    <script src="EasyUI/jquery.min.js" type="text/javascript"></script>
    <script src="EasyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="EasyUI/easyui-lang-zh_CN.js" type="text/javascript"></script>
</head>
<body style="padding: 10px;">
<!-- 导航栏 -->
<div class="easyui-panel" style="margin-bottom: 10px; padding: 5px;">
    <a href="admin.jsp" class="easyui-linkbutton" iconCls="icon-home">首页</a>
    <a href="typelist.jsp" class="easyui-linkbutton" iconCls="icon-tip">商品类型列表</a>
    <a href="userlist.jsp" class="easyui-linkbutton" iconCls="icon-man">客户列表</a>
    <a href="searchorder.jsp" class="easyui-linkbutton" iconCls="icon-search">查询订单</a>
    <a href="createorder.jsp" class="easyui-linkbutton" iconCls="icon-add">创建订单</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload" onclick="location.reload()">刷新</a>
</div>

<!-- 搜索工具栏 -->
<div class="easyui-panel" style="margin-bottom: 10px; padding: 10px;">
    <form id="searchForm">
        商品名称：<input class="easyui-textbox" name="name" style="width: 150px;">
        商品类型：<select class="easyui-combobox" name="typeId" style="width: 150px;"
                         data-options="url:'type/listAll',valueField:'id',textField:'name',panelHeight:'auto'">
    </select>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="searchProduct()">查询</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增商品</a>
    </form>
</div>

<!-- 商品列表表格 -->
<table id="productGrid" class="easyui-datagrid"
       data-options="fit:true,border:false,rownumbers:true,pagination:true,
           url:'product/list',method:'get',pageSize:10,toolbar:'#productToolbar'">
    <thead>
    <tr>
        <th data-options="field:'id',width:60,align:'center'">ID</th>
        <th data-options="field:'name',width:180,align:'center'">商品名称</th>
        <th data-options="field:'price',width:80,align:'center',formatter:formatPrice">单价(¥)</th>
        <th data-options="field:'stock',width:80,align:'center'">库存</th>
        <th data-options="field:'typeName',width:120,align:'center'">商品类型</th>
        <th data-options="field:'description',width:200,align:'center'">描述</th>
        <th data-options="field:'operate',width:150,align:'center',formatter:operateFormatter">操作</th>
    </tr>
    </thead>
</table>

<!-- 表格工具栏 -->
<div id="productToolbar" style="display: none;">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">编辑</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteProduct()">删除</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload" onclick="$('#productGrid').datagrid('reload')">刷新</a>
</div>

<!-- 商品编辑对话框 -->
<div id="productDialog" class="easyui-dialog"
     style="width: 500px; height: 450px;"
     closed="true" modal="true" buttons="#productDialogBtns">
    <form id="productForm" method="post">
        <input type="hidden" name="id">
        <table style="margin: 20px auto;" cellpadding="5">
            <tr>
                <td align="right" width="80">商品名称：</td>
                <td><input class="easyui-textbox" name="name" required style="width: 300px;"></td>
            </tr>
            <tr>
                <td align="right">商品类型：</td>
                <td>
                    <select class="easyui-combobox" name="typeId" required style="width: 300px;"
                            data-options="url:'type/listAll',valueField:'id',textField:'name',panelHeight:'auto'">
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right">单价：</td>
                <td><input class="easyui-numberbox" name="price" required precision="2" style="width: 300px;"></td>
            </tr>
            <tr>
                <td align="right">库存：</td>
                <td><input class="easyui-numberbox" name="stock" required min="0" style="width: 300px;"></td>
            </tr>
            <tr>
                <td align="right" valign="top">描述：</td>
                <td><textarea class="easyui-textbox" name="description" multiline="true" style="width: 300px; height: 100px;"></textarea></td>
            </tr>
        </table>
    </form>
</div>

<!-- 对话框按钮 -->
<div id="productDialogBtns">
    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveProduct()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#productDialog').dialog('close')">取消</a>
</div>

<script type="text/javascript">
    var dialogType = "add";

    // 格式化价格显示
    function formatPrice(value) {
        return value.toFixed(2);
    }

    // 格式化操作列
    function operateFormatter(value, row, index) {
        return '<a href="javascript:void(0)" class="easyui-linkbutton l-btn l-btn-small" onclick="openEditDialog('+row.id+')">' +
            '<span class="l-btn-left"><span class="l-btn-text icon-edit">编辑</span></span></a> ' +
            '<a href="javascript:void(0)" class="easyui-linkbutton l-btn l-btn-small" onclick="deleteProduct('+row.id+')">' +
            '<span class="l-btn-left"><span class="l-btn-text icon-remove">删除</span></span></a>';
    }

    // 搜索商品
    function searchProduct() {
        var params = $('#searchForm').serializeObject();
        $('#productGrid').datagrid('load', params);
    }

    // 打开新增对话框
    function openAddDialog() {
        dialogType = "add";
        $('#productForm').form('clear');
        $('#productDialog').dialog('setTitle', '新增商品').dialog('open');
    }

    // 打开编辑对话框
    function openEditDialog(id) {
        dialogType = "edit";
        var row = id ? null : $('#productGrid').datagrid('getSelected');
        if (!id && (!row || row.id == undefined)) {
            $.messager.alert('提示', '请选择要编辑的商品！', 'info');
            return;
        }
        var productId = id || row.id;

        $.get('product/findById?id='+productId, function(data) {
            $('#productForm').form('load', data);
            $('#productDialog').dialog('setTitle', '编辑商品').dialog('open');
        });
    }

    // 保存商品
    function saveProduct() {
        var url = dialogType == "add" ? "product/add" : "product/update";
        $('#productForm').form('submit', {
            url: url,
            onSubmit: function() {
                return $(this).form('validate');
            },
            success: function(result) {
                var res = JSON.parse(result);
                if (res.success) {
                    $.messager.show({title: '提示', msg: res.message});
                    $('#productDialog').dialog('close');
                    $('#productGrid').datagrid('reload');
                } else {
                    $.messager.alert('错误', res.message, 'error');
                }
            }
        });
    }

    // 删除商品
    function deleteProduct(id) {
        var row = id ? null : $('#productGrid').datagrid('getSelected');
        if (!id && (!row || row.id == undefined)) {
            $.messager.alert('提示', '请选择要删除的商品！', 'info');
            return;
        }
        var productId = id || row.id;

        $.messager.confirm('确认', '确定要删除ID为 '+productId+' 的商品吗？', function(r) {
            if (r) {
                $.get('product/delete?id='+productId, function(result) {
                    var res = JSON.parse(result);
                    $.messager.show({title: '提示', msg: res.message});
                    $('#productGrid').datagrid('reload');
                });
            }
        });
    }
</script>
</body>
</html>