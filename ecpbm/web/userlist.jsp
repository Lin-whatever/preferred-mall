<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    if(session.getAttribute("admin")==null){
        response.sendRedirect("/ecpbm/admin_login.jsp");
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <base href="<%=basePath%>">
    <title>用户管理</title>
    <link href="EasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="EasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="EasyUI/demo.css" rel="stylesheet" type="text/css" />
    <script src="EasyUI/jquery.min.js" type="text/javascript"></script>
    <script src="EasyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="EasyUI/easyui-lang-zh_CN.js" type="text/javascript"></script>
</head>
<body>
<!-- 用户列表DataGrid -->
<table id="userListDg" class="easyui-datagrid"></table>

<!-- 工具栏 -->
<div id="userListTb" style="padding:2px 5px;">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="SetIsEnableUser(1);">启用客户</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="SetIsEnableUser(0);">禁用客户</a>
</div>

<!-- 搜索栏 -->
<div id="searchUserListTb" style="padding:4px 3px;">
    <form id="searchUserListForm">
        <div style="padding:3px ">
            客户名称&nbsp;&nbsp;
            <input class="easyui-textbox" name="search_userName" id="search_userName" style="width:110px" />
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="searchUserInfo();">查找</a>
        </div>
    </form>
</div>

<script type="text/javascript">
    $(function() {
        $('#userListDg').datagrid({
            singleSelect: false,
            url: 'userinfo/list',
            pagination: true,
            pageSize: 5,
            pageList: [5, 10, 15],
            rownumbers: true,
            fit: true,
            toolbar: '#userListTb',
            header: '#searchUserListTb',
            columns: [[
                {title: '序号', field: 'id', align: 'center', checkbox: true},
                {field: 'userName', title: '登录名', width: 100},
                {field: 'realName', title: '真实姓名', width: 80},
                {field: 'sex', title: '性别', width: 100},
                {field: 'address', title: '住址', width: 200},
                {field: 'email', title: '邮箱', width: 150},
                {field: 'regDate', title: '注册日期', width: 100},
                {field: 'status', title: '客户状态', width: 100, formatter: function(value) {
                        return value == 1 ? "启用" : "禁用";
                    }}
            ]]
        });
    });

    // 搜索用户
    function searchUserInfo() {
        var userName = $('#search_userName').textbox('getValue');
        $('#userListDg').datagrid('load', {userName: userName});
    }

    // 启用/禁用用户
    function SetIsEnableUser(flag) {
        var rows = $('#userListDg').datagrid('getSelections');
        if (rows.length === 0) {
            $.messager.alert('提示', '请选择要操作的客户', 'info');
            return;
        }
        var uids = [];
        for (var i = 0; i < rows.length; i++) {
            uids.push(rows[i].id);
        }
        $.messager.confirm('确认', '确定要' + (flag == 1 ? '启用' : '禁用') + '选中客户吗？', function(r) {
            if (r) {
                $.post('userinfo/setIsEnableUser', {uids: uids.join(','), flag: flag}, function(res) {
                    $.messager.show({title: '提示', msg: res.message});
                    if (res.success === 'true') {
                        $('#userListDg').datagrid('reload');
                    }
                }, 'json');
            }
        });
    }
</script>
</body>
</html>