<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>客户管理</title>
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
        用户名：<input class="easyui-textbox" name="userName" placeholder="请输入用户名" style="width: 150px;">
        真实姓名：<input class="easyui-textbox" name="realName" placeholder="请输入真实姓名" style="width: 150px;">
        性别：<select class="easyui-combobox" name="sex" style="width: 100px;" panelHeight="auto">
        <option value="">全部</option>
        <option value="男">男</option>
        <option value="女">女</option>
    </select>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="searchUser()">查询</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增客户</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload" onclick="resetSearch()">重置</a>
    </form>
</div>

<!-- 客户列表表格 -->
<table id="userGrid" class="easyui-datagrid"
       data-options="fit:true,border:false,rownumbers:true,pagination:true,
           url:'userinfo/list',method:'get',pageSize:10,toolbar:'#userToolbar'">
    <thead>
    <tr>
        <th data-options="field:'id',width:60,align:'center'">ID</th>
        <th data-options="field:'userName',width:120,align:'center'">用户名</th>
        <th data-options="field:'password',width:120,align:'center'">密码</th>
        <th data-options="field:'realName',width:100,align:'center'">真实姓名</th>
        <th data-options="field:'sex',width:60,align:'center'">性别</th>
        <th data-options="field:'address',width:200,align:'center'">地址</th>
        <th data-options="field:'email',width:150,align:'center'">邮箱</th>
        <th data-options="field:'regDate',width:130,align:'center',formatter:formatDate">注册日期</th>
        <th data-options="field:'operate',width:150,align:'center',formatter:operateFormatter">操作</th>
    </tr>
    </thead>
</table>

<!-- 表格工具栏 -->
<div id="userToolbar" style="display: none;">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">编辑</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteUser()">删除</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-refresh" onclick="$('#userGrid').datagrid('reload')">刷新</a>
</div>

<!-- 新增/编辑客户对话框 -->
<div id="userDialog" class="easyui-dialog"
     style="width: 500px; height: 400px;"
     closed="true" modal="true" buttons="#userDialogBtns">
    <form id="userForm" method="post">
        <input type="hidden" name="id">
        <table style="margin: 20px auto;" cellpadding="5">
            <tr>
                <td align="right" width="80">用户名：</td>
                <td><input class="easyui-textbox" name="userName" required style="width: 300px;"></td>
            </tr>
            <tr>
                <td align="right">密码：</td>
                <td><input class="easyui-textbox" name="password" required style="width: 300px;"></td>
            </tr>
            <tr>
                <td align="right">真实姓名：</td>
                <td><input class="easyui-textbox" name="realName" style="width: 300px;"></td>
            </tr>
            <tr>
                <td align="right">性别：</td>
                <td>
                    <select class="easyui-combobox" name="sex" style="width: 300px;" panelHeight="auto">
                        <option value="">请选择</option>
                        <option value="男">男</option>
                        <option value="女">女</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right">地址：</td>
                <td><input class="easyui-textbox" name="address" style="width: 300px;"></td>
            </tr>
            <tr>
                <td align="right">邮箱：</td>
                <td><input class="easyui-textbox" name="email" style="width: 300px;"></td>
            </tr>
            <tr id="regDateTr">
                <td align="right">注册日期：</td>
                <td><input class="easyui-datebox" name="regDate" style="width: 300px;"></td>
            </tr>
        </table>
    </form>
</div>

<!-- 对话框按钮 -->
<div id="userDialogBtns">
    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveUser()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#userDialog').dialog('close')">取消</a>
</div>

<script type="text/javascript">
    var dialogType = "add"; // 标记对话框类型：add/edit

    // 格式化日期显示
    function formatDate(value) {
        if (!value) return '';
        var date = new Date(value);
        return date.getFullYear() + '-' +
            (date.getMonth() + 1).toString().padStart(2, '0') + '-' +
            date.getDate().toString().padStart(2, '0');
    }

    // 格式化操作列
    function operateFormatter(value, row, index) {
        return '<a href="javascript:void(0)" onclick="openEditDialog('+row.id+')">编辑</a> ' +
            '<a href="javascript:void(0)" onclick="deleteUser('+row.id+')">删除</a>';
    }

    // 搜索客户
    function searchUser() {
        var params = $('#searchForm').serializeObject();
        $('#userGrid').datagrid('load', params);
    }

    // 重置搜索条件
    function resetSearch() {
        $('#searchForm').form('clear');
        $('#userGrid').datagrid('load', {});
    }

    // 打开新增对话框
    function openAddDialog() {
        dialogType = "add";
        $('#userForm').form('clear');
        $('#regDateTr').show(); // 新增时显示注册日期
        $('#userDialog').dialog('setTitle', '新增客户').dialog('open');
    }

    // 打开编辑对话框
    function openEditDialog(id) {
        dialogType = "edit";
        var row = id ? null : $('#userGrid').datagrid('getSelected');
        if (!id && (!row || !row.id)) {
            $.messager.alert('提示', '请选择要编辑的客户！', 'info');
            return;
        }
        var userId = id || row.id;

        // 加载客户信息回显
        $.get('userinfo/findById?id='+userId, function(data) {
            $('#userForm').form('load', data);
            $('#regDateTr').hide(); // 编辑时隐藏注册日期（不允许修改）
            $('#userDialog').dialog('setTitle', '编辑客户').dialog('open');
        });
    }

    // 保存客户（新增/编辑）
    function saveUser() {
        var url = dialogType == "add" ? "userinfo/add" : "userinfo/update";
        $('#userForm').form('submit', {
            url: url,
            onSubmit: function() {
                return $(this).form('validate'); // 表单验证
            },
            success: function(result) {
                var res = JSON.parse(result);
                if (res.success) {
                    $.messager.show({title: '提示', msg: res.message});
                    $('#userDialog').dialog('close');
                    $('#userGrid').datagrid('reload'); // 刷新列表
                } else {
                    $.messager.alert('错误', res.message, 'error');
                }
            }
        });
    }

    // 删除客户
    function deleteUser(id) {
        var row = id ? null : $('#userGrid').datagrid('getSelected');
        if (!id && (!row || !row.id)) {
            $.messager.alert('提示', '请选择要删除的客户！', 'info');
            return;
        }
        var userId = id || row.id;

        $.messager.confirm('确认删除', '确定要删除ID为 '+userId+' 的客户吗？', function(r) {
            if (r) {
                $.get('userinfo/delete?id='+userId, function(result) {
                    var res = JSON.parse(result);
                    $.messager.show({title: '提示', msg: res.message});
                    $('#userGrid').datagrid('reload'); // 刷新列表
                });
            }
        });
    }
</script>
</body>
</html>