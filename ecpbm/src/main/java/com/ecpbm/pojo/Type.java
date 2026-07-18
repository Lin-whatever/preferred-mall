package com.ecpbm.pojo;

import lombok.Data;

/**
 * 商品类型实体（对应数据库type表）
 */
@Data
public class Type {
    private int id;          // 类型ID（主键）
    private String name;     // 类型名称
}