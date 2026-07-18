<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>电商平台后台管理系统</title>
    <!-- 路径适配：动态获取根路径 -->
    <link href="${pageContext.request.contextPath}/EasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/EasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="${pageContext.request.contextPath}/EasyUI/jquery.min.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/EasyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/EasyUI/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <style type="text/css">
        .north-header {
            font-family: "微软雅黑";
            font-size: 18px;
            line-height: 40px;
        }
        .user-info {
            text-align: right;
            font-size: 14px;
            margin-top: -20px;
        }
        .south-footer {
            text-align: center;
            font-size: 12px;
            line-height: 30px;
        }
    </style>
</head>
<!-- 布局适配：EasyUI原生layout，fit:true占满屏幕 -->
<body class="easyui-layout" style="width:100vw; height:100vh; margin:0; padding:0;">
<!-- 顶部区域：自适应宽度，固定高度 -->
<div data-options="region:'north', border:false" style="height:60px; background:#b3d9da; padding:10px;">
    <div class="north-header">电商平台后台管理系统</div>
    <div class="user-info">欢迎您，<font color="#e74c3c">${sessionScope.admin.name}</font></div>
</div>

<!-- 左侧菜单：自适应高度，固定宽度，支持滚动 -->
<div data-options="region:'west', split:true, title:'功能菜单'"
     style="width:180px; background:#fafafa; overflow:auto;">
    <ul id="funcTree" style="width:100%; padding:5px 0;"></ul>
</div>

<!-- 底部区域：自适应宽度，固定高度 -->
<div data-options="region:'south', border:false" style="height:30px; background:#a9facd; padding:5px;">
    <div class="south-footer">版权所有 © 2025 电商平台 技术支持：JavaWeb开发团队</div>
</div>

<!-- 中间内容：自适应剩余空间，fit:true -->
<div data-options="region:'center', border:false">
    <div id="mainTabs" class="easyui-tabs" data-options="fit:true, border:false, tabPosition:'top'"></div>
</div>

<script type="text/javascript">
    $(function() {
        // 菜单树适配：动态加载+自适应高度
        $('#funcTree').tree({
            url: '${pageContext.request.contextPath}/admininfo/getTree?adminid=${sessionScope.admin.id}', // 路径适配
            method: 'get',
            animate: true,
            lines: true,
            onLoadSuccess: function() {
                // 加载成功后自动展开，适配菜单层级
                $(this).tree('expandAll');
            },
            onClick: function(node) {
                var tabs = $('#mainTabs');
                var tabTitle = node.text;
                var tabHref = '';

                // 页面路径适配，兼容任何部署目录
                var basePath = '${pageContext.request.contextPath}/';
                switch (tabTitle) {
                    case '商品列表': tabHref = basePath + 'productlist.jsp'; break;
                    case '商品类型列表': tabHref = basePath + 'typelist.jsp'; break;
                    case '查询订单': tabHref = basePath + 'searchorder.jsp'; break;
                    case '创建订单': tabHref = basePath + 'createorder.jsp'; break;
                    case '用户列表': tabHref = basePath + 'userlist.jsp'; break;
                    case '退出系统': logout(); return;
                    default: return;
                }

                // 标签页适配：避免重复添加
                if (tabs.tabs('exists', tabTitle)) {
                    tabs.tabs('select', tabTitle);
                } else {
                    tabs.tabs('add', {
                        title: tabTitle,
                        href: tabHref,
                        closable: true,
                        cache: false
                    });
                }
            }
        });

        // 初始化默认首页标签，适配首次加载
        $('#mainTabs').tabs('add', {
            title: '系统首页',
            content: '<div style="padding:20px;"><h2 style="color:#3498db;">欢迎使用电商平台后台管理系统</h2><p style="margin-top:20px; color:#666; font-size:14px;">本系统基于SSM框架+EasyUI开发，支持商品管理、订单管理、用户管理等核心功能。<br>请通过左侧菜单选择需要操作的功能模块，祝您使用愉快！</p></div>',
            closable: false
        });
    });

    // 退出功能适配：路径兼容
    function logout() {
        $.messager.confirm('确认退出', '您确定要退出系统吗？', function(r) {
            if (r) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admininfo/logout',
                    type: 'post',
                    dataType: 'json',
                    success: function(res) {
                        if (res.success) {
                            window.location.href = '${pageContext.request.contextPath}/admin_login.jsp';
                        }
                    }
                });
            }
        });
    }
</script>
</body>
</html>