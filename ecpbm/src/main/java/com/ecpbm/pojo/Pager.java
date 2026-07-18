package com.ecpbm.pojo;

import lombok.Data;

/**
 * 分页工具类（计算分页参数）
 */
@Data
public class Pager {
    private int curPage;     // 当前页码
    private int perPageRows; // 每页显示条数
    private int rowCount;    // 总记录数
    private int pageCount;   // 总页数（自动计算）

    // 计算总页数
    public int getPageCount() {
        return (rowCount + perPageRows - 1) / perPageRows;
    }

    // 获取分页查询偏移量（MySQL limit起始值）
    public int getFirstLimitParam() {
        return (this.curPage - 1) * this.perPageRows;
    }
}