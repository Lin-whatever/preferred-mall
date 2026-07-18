<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>电商平台后台管理系统</title>
    <link href="EasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css"/>
    <link href="EasyUI/themes/icon.css" rel="stylesheet" type="text/css"/>
    <script src="EasyUI/jquery.min.js" type="text/javascript"></script>
    <script src="EasyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="EasyUI/easyui-lang-zh_CN.js" type="text/javascript"></script>
</head>
<body class="easyui-layout">
<!-- 顶部区域 -->
<div data-options="region:'north',border:false" style="height: 60px; background: #2aabd2; padding: 0 10px;">
    <div style="float: left; color: white; font-size: 20px; line-height: 60px; font-weight: bold;">
        电商平台后台管理系统
    </div>
    <div style="float: right; color: white; line-height: 60px; margin-right: 20px;">
        登录用户：<span style="font-weight: bold;">${sessionScope.admin.name}</span>
        <a href="javascript:void(0)" onclick="logout()" style="color: white; margin-left: 20px;">退出系统</a>
    </div>
</div>

<!-- 左侧菜单区域 -->
<div data-options="region:'west',title:'功能菜单',split:true" style="width: 200px;">
    <ul id="funcTree" class="easyui-tree" data-options="animate:true"></ul>
</div>

<!-- 主内容区域 -->
<div data-options="region:'center'">
    <div id="mainTabs" class="easyui-tabs" data-options="fit:true,border:false,plain:true"></div>
</div>

<!-- 底部区域 -->
<div data-options="region:'south',border:false" style="height: 30px; background: #f5f5f5; text-align: center; line-height: 30px;">
    © 2024 电商平台管理系统 | 技术支持：admin@example.com
</div>

<script type="text/javascript">
    // 页面加载完成后初始化
    $(function() {
        // 加载功能菜单树
        $('#funcTree').tree({
            url: 'admininfo/getTree?adminid=${sessionScope.admin.id}',
            method: 'get',
            onLoadSuccess: function(node, data) {
                // 默认展开第一级节点
                if (data.length > 0) {
                    $('#funcTree').tree('expand', data[0].target);
                }
            },
            onClick: function(node) {
                openTab(node.text, node.id);
            }
        });
    });

    // 打开选项卡
    function openTab(title, funcId) {
        if (title === '退出系统') {
            logout();
            return;
        }

        if ($('#mainTabs').tabs('exists', title)) {
            $('#mainTabs').tabs('select', title);
        } else {
            var url = getPageUrl(title);
            if (url) {
                $('#mainTabs').tabs('add', {
                    title: title,
                    href: url,
                    closable: true,
                    tools: [{
                        iconCls:'icon-refresh',
                        handler:function(){
                            var tab = $('#mainTabs').tabs('getSelected');
                            $('#mainTabs').tabs('update', {
                                tab: tab,
                                options: {
                                    href: url
                                }
                            });
                        }
                    }]
                });
            }
        }
    }

    // 根据菜单标题获取对应页面URL
    function getPageUrl(title) {
        var urlMap = {
            '商品列表': 'productlist.jsp',
            '商品类型列表': 'typelist.jsp',
            '查询订单': 'searchorder.jsp',
            '创建订单': 'createorder.jsp',
            '客户列表': 'userlist.jsp'
        };
        return urlMap[title] || '';
    }

    // 退出登录
    function logout() {
        $.messager.confirm('确认退出', '确定要退出系统吗？', function(r) {
            if (r) {
                $.get('admininfo/logout', function() {
                    window.location.href = 'admin_login.jsp';
                });
            }
        });
    }
</script>
</body>
</html>