<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商品类型管理</title>
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
    <a href="productlist.jsp" class="easyui-linkbutton" iconCls="icon-tip">商品列表</a>
    <a href="userlist.jsp" class="easyui-linkbutton" iconCls="icon-man">客户列表</a>
    <a href="searchorder.jsp" class="easyui-linkbutton" iconCls="icon-search">查询订单</a>
    <a href="createorder.jsp" class="easyui-linkbutton" iconCls="icon-add">创建订单</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload" onclick="location.reload()">刷新</a>
</div>

<!-- 操作栏 -->
<div style="margin-bottom: 10px;">
    <input class="easyui-textbox" id="typeName" placeholder="请输入类型名称" style="width: 200px;">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="searchType()">查询</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增类型</a>
</div>

<!-- 类型列表表格 -->
<table id="typeGrid" class="easyui-datagrid"
       data-options="fit:true,border:false,rownumbers:true,pagination:true,
           url:'type/list',method:'get',pageSize:10,toolbar:'#typeToolbar'">
    <thead>
    <tr>
        <th data-options="field:'id',width:80,align:'center'">ID</th>
        <th data-options="field:'name',width:150,align:'center'">类型名称</th>
        <th data-options="field:'description',width:300,align:'center'">类型描述</th>
        <th data-options="field:'productCount',width:100,align:'center'">商品数量</th>
        <th data-options="field:'operate',width:150,align:'center',formatter:operateFormatter">操作</th>
    </tr>
    </thead>
</table>

<!-- 表格工具栏 -->
<div id="typeToolbar" style="display: none;">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">编辑</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteType()">删除</a>
</div>

<!-- 类型编辑对话框 -->
<div id="typeDialog" class="easyui-dialog"
     style="width: 400px; height: 300px;"
     closed="true" modal="true" buttons="#typeDialogBtns">
    <form id="typeForm" method="post">
        <input type="hidden" name="id">
        <table style="margin: 30px auto;" cellpadding="5">
            <tr>
                <td align="right" width="80">类型名称：</td>
                <td><input class="easyui-textbox" name="name" required style="width: 220px;"></td>
            </tr>
            <tr>
                <td align="right" valign="top">类型描述：</td>
                <td><textarea class="easyui-textbox" name="description" multiline="true" style="width: 220px; height: 100px;"></textarea></td>
            </tr>
        </table>
    </form>
</div>

<!-- 对话框按钮 -->
<div id="typeDialogBtns">
    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveType()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#typeDialog').dialog('close')">取消</a>
</div>

<script type="text/javascript">
    var dialogType = "add";

    // 格式化操作列
    function operateFormatter(value, row, index) {
        return '<a href="javascript:void(0)" onclick="openEditDialog('+row.id+')">编辑</a> ' +
            '<a href="javascript:void(0)" onclick="deleteType('+row.id+')">删除</a>';
    }

    // 搜索类型
    function searchType() {
        var typeName = $('#typeName').textbox('getValue');
        $('#typeGrid').datagrid('load', {name: typeName});
    }

    // 打开新增对话框
    function openAddDialog() {
        dialogType = "add";
        $('#typeForm').form('clear');
        $('#typeDialog').dialog('setTitle', '新增商品类型').dialog('open');
    }

    // 打开编辑对话框
    function openEditDialog(id) {
        dialogType = "edit";
        var row = id ? null : $('#typeGrid').datagrid('getSelected');
        if (!id && (!row || !row.id)) {
            $.messager.alert('提示', '请选择要编辑的类型！', 'info');
            return;
        }
        var typeId = id || row.id;

        $.get('type/findById?id='+typeId, function(data) {
            $('#typeForm').form('load', data);
            $('#typeDialog').dialog('setTitle', '编辑商品类型').dialog('open');
        });
    }

    // 保存类型
    function saveType() {
        var url = dialogType == "add" ? "type/add" : "type/update";
        $('#typeForm').form('submit', {
            url: url,
            onSubmit: function() {
                return $(this).form('validate');
            },
            success: function(result) {
                var res = JSON.parse(result);
                if (res.success) {
                    $.messager.show({title: '提示', msg: res.message});
                    $('#typeDialog').dialog('close');
                    $('#typeGrid').datagrid('reload');
                } else {
                    $.messager.alert('错误', res.message, 'error');
                }
            }
        });
    }

    // 删除类型
    function deleteType(id) {
        var row = id ? null : $('#typeGrid').datagrid('getSelected');
        if (!id && (!row || !row.id)) {
            $.messager.alert('提示', '请选择要删除的类型！', 'info');
            return;
        }
        var typeId = id || row.id;

        // 检查是否有关联商品
        if (row && row.productCount > 0) {
            $.messager.alert('提示', '该类型下有'+row.productCount+'个商品，不能删除！', 'warning');
            return;
        }

        $.messager.confirm('确认', '确定要删除该类型吗？', function(r) {
            if (r) {
                $.get('type/delete?id='+typeId, function(result) {
                    var res = JSON.parse(result);
                    $.messager.show({title: '提示', msg: res.message});
                    $('#typeGrid').datagrid('reload');
                });
            }
        });
    }
</script>
</body>
</html>