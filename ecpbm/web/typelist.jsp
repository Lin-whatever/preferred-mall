<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 商品类型DataGrid -->
<table id="typeDg" class="easyui-datagrid"></table>

<!-- 工具栏 -->
<div id="typeTb" style="padding:2px 5px;">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addType();">添加</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editType();">修改</a>
</div>

<!-- 类型添加/修改对话框 -->
<div id="typeDlg" class="easyui-dialog" title="商品类型管理" closed="true" style="width:500px;">
    <div style="padding:10px 60px 20px 60px">
        <form id="typeForm" method="POST">
            <table cellpadding="5">
                <tr>
                    <td>类型名称:</td>
                    <td>
                        <input class="easyui-textbox" type="text" id="name" name="name" data-options="required:true" style="width: 200px;">
                    </td>
                </tr>
            </table>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveType();">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm();">清空</a>
        </div>
    </div>
</div>

<script type="text/javascript">
    // 确保DOM加载完成后初始化（兼容主页面加载时机）
    $(function() {
        $('#typeDg').datagrid({
            singleSelect: true,
            url: 'type/getType/0',
            rownumbers: true,
            fit: true,
            toolbar: '#typeTb',
            columns: [[
                {title: '序号', field: 'id', align: 'center', checkbox: true},
                {field: 'name', title: '商品类型', width: 200}
            ]]
        });
    });

    var urls;

    // 添加类型
    function addType() {
        $('#typeDlg').dialog('open').dialog('setTitle', '新增商品类型');
        $('#typeForm').form('clear');
        urls = 'type/addType';
    }

    // 修改类型
    function editType() {
        var row = $('#typeDg').datagrid('getSelected');
        if (!row) {
            $.messager.alert('提示', '请选择一条记录修改', 'info');
            return;
        }
        $('#typeDlg').dialog('open').dialog('setTitle', '修改商品类型');
        $('#typeForm').form('load', {
            "id": row.id,
            "name": row.name
        });
        urls = 'type/updateType?id=' + row.id;
    }

    // 保存类型
    function saveType() {
        $('#typeForm').form('submit', {
            url: urls,
            success: function(result) {
                var res = eval('(' + result + ')');
                $.messager.show({title: '提示', msg: res.message});
                if (res.success === 'true') {
                    $('#typeDlg').dialog('close');
                    $('#typeDg').datagrid('reload');
                }
            }
        });
    }

    // 清空表单
    function clearForm() {
        $('#typeForm').form('clear');
    }
</script>