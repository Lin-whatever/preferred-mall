<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 子页面：无外层html/body，适配admin.jsp嵌入 -->
<div style="padding:20px; width:100%; height:100%; overflow:hidden;">
    <%-- 订单基本信息表单 --%>
    <div style="margin-bottom:20px; padding:15px; background:#f9f9f9; border-radius:5px;">
        <form id="orderForm" method="post">
            <table style="width:100%; border-spacing:15px;">
                <tr>
                    <td align="right" width="100"><strong>客户名称：</strong></td>
                    <td width="200">
                        <input class="easyui-combobox" name="uid" id="orderUserId" style="width:100%;"
                               data-options="valueField:'id', textField:'userName', url:'${pageContext.request.contextPath}/userinfo/getValidUser', required:true, value:'0'">
                    </td>
                    <td align="right" width="100"><strong>订单状态：</strong></td>
                    <td width="200">
                        <input class="easyui-combobox" name="status" id="orderStatus" style="width:100%;"
                               data-options="valueField:'value', textField:'text', data:[{'value':'未付款','text':'未付款'},{'value':'已付款','text':'已付款'}], required:true, value:'未付款'">
                    </td>
                    <td align="right" width="100"><strong>订单日期：</strong></td>
                    <td width="200">
                        <input class="easyui-datebox" name="ordertime" id="orderDate" style="width:100%;"
                               data-options="required:true" value="<%=new java.util.Date().toLocaleString().split(" ")[0]%>">
                    </td>
                    <td align="right" width="100"><strong>订单金额：</strong></td>
                    <td>
                        <input class="easyui-numberbox" id="orderTotalPrice" style="width:120px; font-weight:bold; color:red;"
                               data-options="precision:2, disabled:true" value="0.00">
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <%-- 订单明细操作区 --%>
    <div style="margin-bottom:10px;">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="addOrderDetail()">添加订单明细</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" onclick="saveOrder()">保存订单</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteOrderDetail()">删除订单明细</a>
    </div>

    <%-- 订单明细表格（可编辑） --%>
    <div style="width:100%; height:calc(100% - 150px);">
        <table id="orderDetailEditDg" class="easyui-datagrid"
               data-options="fit:true, pagination:false, rownumbers:true, singleSelect:false, idField:'id', editable:true">
        </table>
    </div>
</div>

<script type="text/javascript">
    var basePath = '${pageContext.request.contextPath}/';
    var totalPrice = 0.00;

    $(function() {
        // 初始化明细表格（可编辑）
        $('#orderDetailEditDg').datagrid({
            columns: [[
                {field:'pid', title:'商品名称', width:200, align:'center',
                    editor: {
                        type: 'combobox',
                        options: {
                            valueField: 'id',
                            textField: 'name',
                            url: basePath + 'productinfo/getOnSaleProduct',
                            required: true,
                            onSelect: function(record) {
                                var $combobox = $(this);
                                var $tr = $combobox.closest('tr.datagrid-row');
                                var index = parseInt($tr.attr('datagrid-row-index'));
                                if (isNaN(index)) return;

                                // 【关键修复：直接更新行数据，不重新开始编辑】
                                var row = $('#orderDetailEditDg').datagrid('getRows')[index];
                                var isEditing = $tr.hasClass('datagrid-row-editing');

                                $.get(basePath + 'productinfo/getPriceById?pid=' + record.id, function(price) {
                                    var priceNum = parseFloat(price) || 0;
                                    var num = row.num || 1;
                                    var totalpriceNum = priceNum * num;

                                    // 更新行数据
                                    row.price = priceNum;
                                    row.num = num;
                                    row.totalprice = totalpriceNum;
                                    row.productName = record.name; // 保存商品名称用于显示

                                    // 【关键修复：使用updateRow方法更新行，不重新进入编辑状态】
                                    $('#orderDetailEditDg').datagrid('updateRow', {
                                        index: index,
                                        row: row
                                    });

                                    // 【优化：如果正在编辑，同步更新其他编辑器的值】
                                    if (isEditing) {
                                        // 更新单价编辑器
                                        var priceEditor = $('#orderDetailEditDg').datagrid('getEditor', {
                                            index: index,
                                            field: 'price'
                                        });
                                        if (priceEditor) {
                                            $(priceEditor.target).numberbox('setValue', priceNum);
                                        }

                                        // 更新数量编辑器
                                        var numEditor = $('#orderDetailEditDg').datagrid('getEditor', {
                                            index: index,
                                            field: 'num'
                                        });
                                        if (numEditor) {
                                            $(numEditor.target).numberbox('setValue', num);
                                        }

                                        // 更新小计编辑器
                                        var totalpriceEditor = $('#orderDetailEditDg').datagrid('getEditor', {
                                            index: index,
                                            field: 'totalprice'
                                        });
                                        if (totalpriceEditor) {
                                            $(totalpriceEditor.target).numberbox('setValue', totalpriceNum);
                                        }
                                    }

                                    calculateTotalPrice();
                                });
                            }
                        }
                    },
                    formatter: function(value, row) {
                        // 显示商品名称而不是ID
                        if (value && row.productName) {
                            return row.productName;
                        } else if (value) {
                            // 如果没有productName，尝试从combobox获取
                            var combobox = $('#orderDetailEditDg').datagrid('getEditor', {index: row.index, field: 'pid'});
                            if (combobox) {
                                var text = $(combobox.target).combobox('getText');
                                return text || '';
                            }
                        }
                        return '';
                    }
                },
                {field:'price', title:'单价', width:100, align:'center',
                    editor: {type: 'numberbox', options: {precision:2, disabled:true}},
                    formatter: function(value) {
                        return value !== undefined ? parseFloat(value).toFixed(2) : '0.00';
                    }
                },
                {field:'num', title:'数量', width:80, align:'center',
                    editor: {
                        type: 'numberbox',
                        options: {
                            min:1,
                            required:true,
                            onChange: function(newValue, oldValue) {
                                if (newValue === oldValue) return;

                                var $numBox = $(this);
                                var $tr = $numBox.closest('tr.datagrid-row');
                                var index = parseInt($tr.attr('datagrid-row-index'));
                                if (isNaN(index)) return;

                                var num = parseInt(newValue) || 1;
                                var row = $('#orderDetailEditDg').datagrid('getRows')[index];
                                var priceNum = parseFloat(row.price) || 0;
                                var totalpriceNum = priceNum * num;

                                // 更新行数据
                                row.num = num;
                                row.totalprice = totalpriceNum;

                                // 更新行显示
                                $('#orderDetailEditDg').datagrid('updateRow', {
                                    index: index,
                                    row: row
                                });

                                // 更新小计编辑器
                                var totalpriceEditor = $('#orderDetailEditDg').datagrid('getEditor', {
                                    index: index,
                                    field: 'totalprice'
                                });
                                if (totalpriceEditor) {
                                    $(totalpriceEditor.target).numberbox('setValue', totalpriceNum);
                                }

                                calculateTotalPrice();
                            }
                        }
                    }
                },
                {field:'totalprice', title:'小计', width:100, align:'center',
                    editor: {type: 'numberbox', options: {precision:2, disabled:true}},
                    formatter: function(value) {
                        return value !== undefined ? parseFloat(value).toFixed(2) : '0.00';
                    }
                }
            ]],
            // 【优化：添加onEndEdit事件保持数据同步】
            onEndEdit: function(index, row) {
                // 结束编辑时更新行数据
                $('#orderDetailEditDg').datagrid('updateRow', {
                    index: index,
                    row: row
                });
                calculateTotalPrice();
            }
        });
    });

    // 添加订单明细行
    function addOrderDetail() {
        var newRow = {
            id: 'temp_' + new Date().getTime(),
            pid: '',
            price: 0.00,
            num: 1,
            totalprice: 0.00,
            productName: ''
        };

        // 添加行到顶部
        $('#orderDetailEditDg').datagrid('insertRow', {
            index: 0,
            row: newRow
        });

        // 开启编辑
        setTimeout(function() {
            $('#orderDetailEditDg').datagrid('beginEdit', 0);
        }, 100);
    }

    // 删除选中的明细行
    function deleteOrderDetail() {
        var rows = $('#orderDetailEditDg').datagrid('getSelections');
        if (rows.length === 0) {
            $.messager.alert('提示', '请选择要删除的明细行！', 'info');
            return;
        }

        // 先结束所有编辑
        var editTr = $('#orderDetailEditDg').datagrid('getPanel').find('tr.datagrid-row-editing');
        if (editTr.length > 0) {
            var editIndex = parseInt(editTr.attr('datagrid-row-index'));
            $('#orderDetailEditDg').datagrid('endEdit', editIndex);
        }

        // 从后往前删除，避免索引变化
        var indices = [];
        for (var i = 0; i < rows.length; i++) {
            indices.push($('#orderDetailEditDg').datagrid('getRowIndex', rows[i]));
        }
        indices.sort(function(a, b) { return b - a; }); // 降序排列

        for (var i = 0; i < indices.length; i++) {
            $('#orderDetailEditDg').datagrid('deleteRow', indices[i]);
        }

        calculateTotalPrice();
    }

    // 计算订单总金额
    function calculateTotalPrice() {
        totalPrice = 0.00;
        var rows = $('#orderDetailEditDg').datagrid('getRows');
        for (var i = 0; i < rows.length; i++) {
            var rowTotal = parseFloat(rows[i].totalprice) || 0;
            totalPrice += rowTotal;
        }
        $('#orderTotalPrice').numberbox('setValue', totalPrice.toFixed(2));
    }

    // 保存订单 - 完全修复版
    function saveOrder() {
        // 1. 强制结束所有编辑状态
        var editRows = $('#orderDetailEditDg').datagrid('getPanel').find('tr.datagrid-row-editing');
        var forceEndEditSuccess = true;
        var errorRowIndex = -1;

        // 先尝试正常结束编辑
        if (editRows.length > 0) {
            editRows.each(function() {
                var index = parseInt($(this).attr('datagrid-row-index'));
                if (!isNaN(index)) {
                    var result = $('#orderDetailEditDg').datagrid('endEdit', index);
                    if (!result) {
                        forceEndEditSuccess = false;
                        errorRowIndex = index;
                        return false; // 停止循环
                    }
                }
            });
        }

        // 如果正常结束编辑失败，使用强制方法
        if (!forceEndEditSuccess) {
            // 强制取消编辑状态
            for (var i = 0; i < $('#orderDetailEditDg').datagrid('getRows').length; i++) {
                if ($('#orderDetailEditDg').datagrid('validateRow', i)) {
                    $('#orderDetailEditDg').datagrid('endEdit', i);
                } else {
                    // 验证失败的行，取消编辑
                    $('#orderDetailEditDg').datagrid('cancelEdit', i);
                }
            }
        }

        // 2. 验证表单
        if (!$('#orderForm').form('validate')) {
            $.messager.alert('提示', '请完善订单基本信息！', 'info');
            return;
        }

        // 3. 验证明细
        var rows = $('#orderDetailEditDg').datagrid('getRows');
        if (rows.length === 0) {
            $.messager.alert('提示', '请添加至少一条订单明细！', 'info');
            return;
        }

        // 4. 验证每条明细是否完整 - 添加更详细的日志
        console.log('=== 保存前所有行数据检查 ===');
        var hasError = false;
        var errorMsg = '';
        for (var i = 0; i < rows.length; i++) {
            console.log('第' + (i + 1) + '行数据:', rows[i]);

            // 详细验证每个字段
            if (!rows[i].pid || rows[i].pid === '' || rows[i].pid === undefined) {
                hasError = true;
                errorMsg = '第' + (i + 1) + '行的商品名称不能为空！';
                console.log('第' + (i + 1) + '行错误: pid为空', rows[i]);
                break;
            }
            if (!rows[i].num || rows[i].num < 1 || isNaN(rows[i].num)) {
                hasError = true;
                errorMsg = '第' + (i + 1) + '行的数量必须大于0！';
                console.log('第' + (i + 1) + '行错误: num无效', rows[i]);
                break;
            }
            if (!rows[i].price || rows[i].price <= 0 || isNaN(rows[i].price)) {
                hasError = true;
                errorMsg = '第' + (i + 1) + '行的单价无效！';
                console.log('第' + (i + 1) + '行错误: price无效', rows[i]);
                break;
            }
        }

        if (hasError) {
            $.messager.alert('提示', errorMsg, 'info');
            return;
        }

        // 5. 构造订单数据
        var orderData = {
            uid: $('#orderUserId').combobox('getValue'),
            status: $('#orderStatus').combobox('getValue'),
            ordertime: $('#orderDate').datebox('getValue'),
            orderprice: totalPrice
        };

        // 6. 构造明细数据 - 确保格式正确
        var detailData = [];
        for (var i = 0; i < rows.length; i++) {
            // 根据后端需求，只发送必要的字段
            detailData.push({
                pid: rows[i].pid,
                num: rows[i].num,
                // 以下字段根据后端需要决定是否发送
                // price: rows[i].price,
                // totalprice: rows[i].totalprice
            });

            console.log('添加到detailData的第' + (i+1) + '条记录:', detailData[detailData.length-1]);
        }

        // 7. 提交保存 - 添加详细的请求日志
        console.log('提交的orderinfo:', JSON.stringify([orderData]));
        console.log('提交的inserted:', JSON.stringify(detailData));

        $.ajax({
            url: basePath + 'orderinfo/commitOrder',
            type: 'post',
            data: {
                orderinfo: JSON.stringify([orderData]),
                inserted: JSON.stringify(detailData)
            },
            dataType: 'text',
            success: function(result) {
                console.log('后端返回结果:', result);
                if (result === 'success') {
                    $.messager.show({
                        title: '成功',
                        msg: '订单创建成功！共添加了' + rows.length + '个商品',
                        timeout: 3000,
                        showType: 'slide'
                    });
                    // 关闭当前标签页
                    if (window.parent && window.parent.$('#mainTabs')) {
                        window.parent.$('#mainTabs').tabs('close', '创建订单');
                        // 刷新订单列表
                        if (window.parent.$('#orderDg')) {
                            window.parent.$('#orderDg').datagrid('reload');
                        }
                    }
                } else {
                    $.messager.alert('失败', '订单创建失败：' + result, 'error');
                }
            },
            error: function(xhr, status, error) {
                console.error('AJAX错误:', status, error);
                $.messager.alert('错误', '网络异常：' + error + '，请检查控制台日志', 'error');
            }
        });
    }
</script>