<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 子页面无需外层html/body/layout，直接保留内容（共享主页面资源） -->
<%-- 搜索栏：直接用div，无region布局 --%>
<div class="search-bar" style="padding:8px; background:#f5f5f5; border-bottom:1px solid #ddd;">
    <form id="searchForm" method="post">
        <table class="form-table" style="width:100%; border-spacing:10px;">
            <tr>
                <td align="right" width="80">商品编码：</td>
                <td width="150">
                    <input class="easyui-textbox" name="code" id="searchCode" style="width:100%;">
                </td>
                <td align="right" width="80">商品名称：</td>
                <td width="150">
                    <input class="easyui-textbox" name="name" id="searchName" style="width:100%;">
                </td>
                <td align="right" width="80">商品类型：</td>
                <td width="150">
                    <input class="easyui-combobox" name="type.id" id="searchType" style="width:100%;"
                           data-options="valueField:'id', textField:'name', url:'${pageContext.request.contextPath}/type/getType/1', value:'0'">
                </td>
                <td align="right" width="80">商品品牌：</td>
                <td width="150">
                    <input class="easyui-textbox" name="brand" id="searchBrand" style="width:100%;">
                </td>
                <td>
                    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="searchProduct()">查询</a>
                    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-clear" onclick="clearSearch()">重置</a>
                </td>
            </tr>
            <tr>
                <td align="right">价格范围：</td>
                <td colspan="2">
                    <input class="easyui-numberbox" name="priceFrom" id="searchPriceFrom" style="width:45%;" data-options="min:0, precision:2, prompt:'最低'">
                    ~
                    <input class="easyui-numberbox" name="priceTo" id="searchPriceTo" style="width:45%;" data-options="min:0, precision:2, prompt:'最高'">
                </td>
            </tr>
        </table>
    </form>
</div>

<%-- 工具栏 + 表格：无region，表格fit:true占满父容器 --%>
<div style="width:100%; height:calc(100% - 100px); overflow:hidden;">
    <!-- 操作工具栏 -->
    <div id="productToolbar" class="toolbar" style="padding:5px; background:#fafafa; border-bottom:1px solid #ddd;">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">添加商品</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">修改商品</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteProduct()">删除商品</a>
    </div>

    <!-- 商品表格：fit:true适配父容器高度 -->
    <table id="productDatagrid" class="easyui-datagrid"
           data-options="fit:true, toolbar:'#productToolbar', pagination:true, rownumbers:true, singleSelect:false">
    </table>
</div>

<%-- 商品添加/修改对话框：保留弹窗逻辑，不依赖布局 --%>
<div id="productDialog" class="easyui-dialog"
     data-options="title:'商品信息', closed:true, modal:true, buttons:'#productDialogBtns', minWidth:500, minHeight:450">
    <form id="productForm" method="post" enctype="multipart/form-data">
        <table style="margin:20px auto; width:80%; border-spacing:10px; font-size:14px;">
            <tr>
                <td align="right" width="100">商品状态：</td>
                <td>
                    <select class="easyui-combobox" name="status" id="productStatus" style="width:100%;">
                        <option value="1">在售</option>
                        <option value="0">下架</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right">商品类型：</td>
                <td>
                    <input class="easyui-combobox" name="type.id" id="productType" style="width:100%;"
                           data-options="valueField:'id', textField:'name', url:'${pageContext.request.contextPath}/type/getType/0', required:true">
                </td>
            </tr>
            <tr>
                <td align="right">商品名称：</td>
                <td>
                    <input class="easyui-textbox" name="name" id="productName" style="width:100%;" data-options="required:true">
                </td>
            </tr>
            <tr>
                <td align="right">商品编码：</td>
                <td>
                    <input class="easyui-textbox" name="code" id="productCode" style="width:100%;" data-options="required:true">
                </td>
            </tr>
            <tr>
                <td align="right">商品品牌：</td>
                <td>
                    <input class="easyui-textbox" name="brand" id="productBrand" style="width:100%;" data-options="required:true">
                </td>
            </tr>
            <tr>
                <td align="right">商品库存：</td>
                <td>
                    <input class="easyui-numberbox" name="num" id="productNum" style="width:100%;" data-options="min:0, required:true">
                </td>
            </tr>
            <tr>
                <td align="right">商品价格：</td>
                <td>
                    <input class="easyui-numberbox" name="price" id="productPrice" style="width:100%;" data-options="min:0, precision:2, required:true">
                </td>
            </tr>
            <tr>
                <td align="right">商品描述：</td>
                <td>
                    <input class="easyui-textbox" name="intro" id="productIntro" style="width:100%; height:80px;" data-options="multiline:true">
                </td>
            </tr>
            <tr>
                <td align="right">商品图片：</td>
                <td>
                    <input class="easyui-filebox" name="file" id="productFile" style="width:100%;"
                           data-options="buttonText:'选择图片', accept:'image/*', required:true">
                    <div id="picPreview" style="margin-top:10px; display:none;"><img id="previewImg" src="" style="max-width:200px; max-height:150px;"></div>
                </td>
            </tr>
        </table>
    </form>
</div>

<!-- 对话框按钮组 -->
<div id="productDialogBtns">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveProduct()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeDialog()">取消</a>
</div>

<%-- 子页面JS：确保DOM加载后执行，路径用basePath适配 --%>
<script type="text/javascript">
    var formUrl = '';
    var basePath = '${pageContext.request.contextPath}/'; // 动态获取项目根路径

    // 等待DOM加载完成（避免和主页面脚本冲突）
    $(function() {
        // 1. 初始化商品表格
        $('#productDatagrid').datagrid({
            url: basePath + 'productinfo/list', // 表格数据接口（适配项目根路径）
            method: 'get',
            pageSize: 10,
            pageList: [10, 15, 20],
            columns: [[
                {field:'id', title:'序号', width:60, align:'center', checkbox:true},
                {field:'name', title:'商品名称', width:'15%', align:'center'},
                {field:'type', title:'商品类型', width:'10%', align:'center',
                    formatter: function(value) { return value ? value.name : ''; }
                },
                {field:'status', title:'商品状态', width:'8%', align:'center',
                    formatter: function(value) { return value===1 ? '<span style="color:green">在售</span>' : '<span style="color:red">下架</span>'; }
                },
                {field:'code', title:'商品编码', width:'12%', align:'center'},
                {field:'brand', title:'商品品牌', width:'12%', align:'center'},
                {field:'price', title:'商品价格', width:'10%', align:'center',
                    formatter: function(value) { return '¥' + (value||0).toFixed(2); }
                },
                {field:'num', title:'库存数量', width:'10%', align:'center'},
                {field:'intro', title:'商品描述', width:'23%', align:'left'}
            ]],
            onLoadSuccess: function(data) {
                // 无数据时显示提示（合并9列，适配表格列数）
                if (data.total === 0) {
                    $(this).datagrid('appendRow', {name:'<span style="color:#999">暂无商品数据</span>'})
                        .datagrid('mergeCells', {index:0, field:'name', colspan:9, align:'center'});
                }
            }
        });

        // 2. 图片预览功能（适配子页面无冲突）
        $('#productFile').filebox({
            onChange: function() {
                var fileObj = this.files[0];
                if (fileObj && fileObj.type.match('image.*')) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        $('#previewImg').attr('src', e.target.result);
                        $('#picPreview').show();
                    };
                    reader.readAsDataURL(fileObj);
                } else {
                    $('#previewImg').attr('src', '');
                    $('#picPreview').hide();
                    $.messager.alert('提示', '请选择图片类型文件！', 'info');
                }
            }
        });
    });

    // 3. 打开添加商品对话框
    function openAddDialog() {
        formUrl = basePath + 'productinfo/addProduct';
        $('#productForm').form('clear');
        $('#picPreview').hide();
        $('#productDialog').dialog('open').dialog('setTitle', '添加商品');
        $('#productStatus').combobox('select', 1); // 默认在售
    }

    // 4. 打开修改商品对话框（修复图片路径拼接）
    function openEditDialog() {
        var rows = $('#productDatagrid').datagrid('getSelections');
        if (rows.length === 0) {
            $.messager.alert('提示', '请选择需要修改的商品！', 'info');
            return;
        }
        if (rows.length > 1) {
            $.messager.alert('提示', '一次只能修改一个商品！', 'info');
            return;
        }

        var product = rows[0];
        formUrl = basePath + 'productinfo/updateProduct?id=' + product.id;
        // 加载商品数据到表单
        $('#productForm').form('load', {
            'status': product.status,
            'type.id': product.type ? product.type.id : 0,
            'name': product.name,
            'code': product.code,
            'brand': product.brand,
            'num': product.num,
            'price': product.price,
            'intro': product.intro
        });

        // 图片预览（拼接项目根路径+图片目录，确保子页面能访问）
        if (product.pic) {
            $('#previewImg').attr('src', basePath + 'product_images/' + product.pic);
            $('#picPreview').show();
            $('#productFile').filebox('options').required = false; // 修改时图片非必选
        } else {
            $('#previewImg').attr('src', '');
            $('#picPreview').hide();
            $('#productFile').filebox('options').required = true;
        }

        $('#productDialog').dialog('open').dialog('setTitle', '修改商品');
    }

    // 5. 保存商品（添加/修改通用，适配子页面表单提交）
    function saveProduct() {
        $('#productForm').form('submit', {
            url: formUrl,
            onSubmit: function() {
                return $(this).form('validate'); // 表单验证
            },
            success: function(result) {
                var res = JSON.parse(result);
                $.messager.show({
                    title: res.success ? '成功' : '失败',
                    msg: res.message || (res.success ? '操作成功' : '操作失败'),
                    timeout: 3000,
                    showType: 'slide'
                });
                if (res.success) {
                    closeDialog();
                    $('#productDatagrid').datagrid('reload'); // 刷新表格
                }
            },
            error: function() {
                $.messager.alert('错误', '网络异常，请重试！', 'error');
            }
        });
    }

    // 6. 删除商品（补充flag参数，适配后端接口）
    function deleteProduct() {
        var rows = $('#productDatagrid').datagrid('getSelections');
        if (rows.length === 0) {
            $.messager.alert('提示', '请选择需要删除的商品！', 'info');
            return;
        }

        var ids = rows.map(function(row) {
            return row.id;
        }).join(',');

        // 删除确认框 - 这里应该显示中文
        $.messager.confirm({
            title: '确认下架',
            msg: '确定要下架选中的' + rows.length + '个商品吗？',
            ok: '确定',
            cancel: '取消',
            fn: function(r) {
                if (r) {
                    $.ajax({
                        url: basePath + 'productinfo/deleteProduct',
                        type: 'post',
                        data: {id: ids, flag: 0},
                        dataType: 'json',
                        success: function(res) {
                            $.messager.show({
                                title: res.success ? '成功' : '失败',
                                msg: res.message,
                                timeout: 3000,
                                showType: 'slide'
                            });
                            if (res.success) {
                                $('#productDatagrid').datagrid('reload');
                            }
                        },
                        error: function() {
                            $.messager.alert('错误', '下架失败，请重试！', 'error');
                        }
                    });
                }
            }
        });
    }

    // 7. 搜索商品（补充serializeObject方法，适配EasyUI表单序列化）
    function searchProduct() {
        // 序列化表单参数（子页面需手动实现该方法）
        var params = $('#searchForm').serializeObject();
        // 处理价格范围默认值（避免传递空字符串）
        params.priceFrom = params.priceFrom || 0;
        params.priceTo = params.priceTo || 0;
        $('#productDatagrid').datagrid('load', params);
    }

    // 8. 重置搜索条件
    function clearSearch() {
        $('#searchForm').form('clear');
        $('#searchType').combobox('setValue', 0); // 重置商品类型为“请选择”
        $('#productDatagrid').datagrid('load', {}); // 加载全部数据
    }

    // 9. 关闭对话框
    function closeDialog() {
        $('#productDialog').dialog('close');
        $('#picPreview').hide();
        $('#productFile').filebox('options').required = true; // 恢复图片必选
    }

    // 补充serializeObject方法（子页面必备，适配EasyUI表单参数序列化）
    $.fn.serializeObject = function() {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function() {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };
</script>