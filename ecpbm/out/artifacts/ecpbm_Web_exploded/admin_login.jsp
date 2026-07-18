<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>电商平台后台登录</title>
    <!-- 引入EasyUI资源 -->
    <link href="EasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css"/>
    <link href="EasyUI/themes/icon.css" rel="stylesheet" type="text/css"/>
    <script src="EasyUI/jquery.min.js" type="text/javascript"></script>
    <script src="EasyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="EasyUI/easyui-lang-zh_CN.js" type="text/javascript"></script>
</head>
<body style="background-color: #f0f0f0;">
<!-- 登录对话框 -->
<div id="loginDlg" class="easyui-dialog"
     style="width: 350px; height: 250px; left: 50%; top: 50%; margin-left: -175px; margin-top: -125px;"
     title="管理员登录" modal="true" closable="false" buttons="#loginBtns">

    <form id="loginForm" method="post">
        <table style="margin: 30px auto;">
            <tr style="height: 40px;">
                <td style="text-align: right; padding-right: 10px;">用户名：</td>
                <td>
                    <input class="easyui-textbox" name="name" required
                           data-options="iconCls:'icon-man'" style="width: 200px;">
                </td>
            </tr>
            <tr style="height: 40px;">
                <td style="text-align: right; padding-right: 10px;">密码：</td>
                <td>
                    <input class="easyui-passwordbox" name="pwd" required
                           data-options="iconCls:'icon-lock'" style="width: 200px;">
                </td>
            </tr>
            <tr style="height: 30px;">
                <td colspan="2" style="text-align: center; color: red;" id="errorMsg"></td>
            </tr>
        </table>
    </form>
</div>

<!-- 登录按钮组 -->
<div id="loginBtns">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="login()">登录</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-clear" onclick="resetForm()">重置</a>
</div>

<script type="text/javascript">
    // 登录验证
    function login() {
        $('#loginForm').form('submit', {
            url: 'admininfo/login',
            onSubmit: function() {
                return $(this).form('validate');
            },
            success: function(result) {
                var res = JSON.parse(result);
                if (res.success === 'true') {
                    window.location.href = 'admin.jsp';
                } else {
                    $('#errorMsg').text(res.message);
                }
            }
        });
    }

    // 重置表单
    function resetForm() {
        $('#loginForm').form('clear');
        $('#errorMsg').text('');
    }

    // 支持回车键登录
    $(document).keydown(function(e) {
        if (e.keyCode === 13) {
            login();
        }
    });
</script>
</body>
</html>