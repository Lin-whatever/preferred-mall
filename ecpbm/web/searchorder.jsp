<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 子页面：无外层html/body，适配admin.jsp嵌入 -->
<%-- 搜索栏 --%>
<div style="padding:8px; background:#f5f5f5; border-bottom:1px solid #ddd;">
    <form id="searchOrderForm" method="post">
        <table style="width:100%; border-spacing:10px;">
            <tr>
                <td align="right" width="80">订单编号：</td>
                <td width="150">
                    <input class="easyui-textbox" name="id" id="searchOrderId" style="width:100%;">
                </td>
                <td align="right" width="80">客户名称：</td>
                <td width="150">
                    <input class="easyui-combobox" name="uid" id="searchUserId" style="width:100%;"
                           data-options="valueField:'id', textField:'userName', url:'${pageContext.request.contextPath}/userinfo/getValidUser', value:'0'">
                </td>
                <td align="right" width="80">订单状态：</td>
                <td width="150">
                    <input class="easyui-combobox" name="status" id="searchOrderStatus" style="width:100%;"
                           data-options="valueField:'value', textField:'text', data:[{'value':'请选择','text':'请选择'},{'value':'未付款','text':'未付款'},{'value':'已付款','text':'已付款'}], value:'请选择'">
                </td>
                <td align="right" width="80">订单时间：</td>
                <td colspan="2">
                    <input class="easyui-datebox" name="orderTimeFrom" id="searchTimeFrom" style="width:45%;" data-options="prompt:'开始日期'">
                    ~
                    <input class="easyui-datebox" name="orderTimeTo" id="searchTimeTo" style="width:45%;" data-options="prompt:'结束日期'">
                </td>
                <td>
                    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="searchOrder()">查询</a>
                    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-clear" onclick="clearOrderSearch()">重置</a>
                </td>
            </tr>
        </table>
    </form>
</div>

<%-- 工具栏 + 订单表格 --%>
<div style="width:100%; height:calc(100% - 50px); overflow:hidden;">
    <div id="orderToolbar" style="padding:5px; background:#fafafa; border-bottom:1px solid #ddd;">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="editOrder();">查看明细</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteOrder()">删除订单</a>
    </div>
    <table id="orderDg" class="easyui-datagrid"
           data-options="fit:true, toolbar:'#orderToolbar', pagination:true, rownumbers:true, singleSelect:false">
    </table>
</div>

<script type="text/javascript">
    var basePath = '${pageContext.request.contextPath}/';

    $(function() {
        // 初始化订单表格
        $('#orderDg').datagrid({
            url: basePath + 'orderinfo/list',
            method: 'get',
            pageSize: 10,
            pageList: [10, 15, 20],
            columns: [[
                {field:'id', title:'订单编号', width:80, align:'center', checkbox:true},
                // 修复：把value.getUserName() 改为 value.userName
                {field:'ui', title:'客户名称', width:100, align:'center', formatter: function(value) {
                        return value ? value.userName : ''; // 核心修复点
                    }},
                {field:'status', title:'订单状态', width:100, align:'center', formatter: function(value) {
                        return value === '已付款' ? '<span style="color:green">已付款</span>' : '<span style="color:red">未付款</span>';
                    }},
                {field:'ordertime', title:'下单时间', width:150, align:'center'},
                {field:'orderprice', title:'订单金额', width:100, align:'center', formatter: function(value) { return '¥' + value.toFixed(2); }}
            ]],
            onLoadSuccess: function(data) {
                if (data.total === 0) {
                    $(this).datagrid('appendRow', {id:'<span style="color:#999">暂无订单数据</span>'})
                        .datagrid('mergeCells', {index:0, field:'id', colspan:5, align:'center'});
                }
            }
        });
    });

    // 搜索订单
    function searchOrder() {
        var params = $('#searchOrderForm').serializeObject();
        // 处理默认值
        params.uid = params.uid || 0;
        params.status = params.status || '请选择';
        $('#orderDg').datagrid('load', params);
    }

    // 重置搜索
    function clearOrderSearch() {
        $('#searchOrderForm').form('clear');
        $('#searchUserId').combobox('setValue', 0);
        $('#searchOrderStatus').combobox('setValue', '请选择');
        $('#orderDg').datagrid('load', {});
    }

    // 查看明细 - 修复版
    function editOrder() {
        var rows = $("#orderDg").datagrid('getSelections');
        if (rows.length > 0) {
            var row = $("#orderDg").datagrid("getSelected");

            // 注意：这里使用的是父页面的 tabs，即 admin.jsp 中的 #mainTabs
            var mainTabs = $('#mainTabs', window.parent.document);

            // 先关闭已存在的'订单明细'标签页
            if (mainTabs.tabs('exists', '订单明细')) {
                mainTabs.tabs('close', '订单明细');
            }

            // 使用绝对路径
            var url = '${pageContext.request.contextPath}/orderinfo/getOrderInfo?oid=' + row.id;

            mainTabs.tabs('add', {
                title: "订单明细",
                href: url,
                closable: true,
                cache: false
            });
        } else {
            $.messager.alert('提示', '请选择要查看的订单', 'info');
        }
    }

    // 删除订单 - 修复版
    function deleteOrder() {
        var rows = $('#orderDg').datagrid('getSelections');
        if (rows.length === 0) {
            $.messager.alert('提示', '请选择要删除的订单！', 'info');
            return;
        }

        // 收集有效订单ID
        var oids = '';
        for (var i = 0; i < rows.length; i++) {
            var id = rows[i].id;
            // 跳过无效ID
            if (id && id !== '' && id !== 'undefined') {
                oids += id + ',';
            }
        }

        // 检查是否有有效订单
        if (oids === '') {
            $.messager.alert('提示', '没有有效的订单可删除！', 'info');
            return;
        }

        oids = oids.slice(0, -1); // 去除最后一个逗号

        $.messager.confirm('确认删除', '确定要删除选中的' + rows.length + '个订单吗？', function(r) {
            if (r) {
                $.ajax({
                    url: basePath + 'orderinfo/deleteOrder',
                    type: 'post',
                    data: {oids: oids},
                    dataType: 'json',
                    success: function(res) {
                        // 注意：这里改为解析JSON对象
                        var result = typeof res === 'string' ? JSON.parse(res) : res;
                        $.messager.show({title: result.success ? '成功' : '失败', msg: result.message, timeout: 3000});
                        if (result.success) {
                            $('#orderDg').datagrid('reload');
                        }
                    },
                    error: function(xhr, status, error) {
                        $.messager.alert('错误', '删除失败：' + error, 'error');
                    }
                });
            }
        });
    }

    // 补充serializeObject方法
    $.fn.serializeObject = function() {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function() {
            if (o[this.name]) {
                o[this.name] = o[this.name].push ? o[this.name].push(this.value) : [o[this.name], this.value];
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };
</script>