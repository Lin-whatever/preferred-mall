package com.ecpbm.pojo;

import lombok.Data;

/**
 * 商品信息实体（对应数据库product_info表）
 */
@Data
public class ProductInfo {
    private int id;          // 商品ID（主键）
    private String code;     // 商品编码
    private String name;     // 商品名称
    private Type type;       // 关联商品类型（多对一）
    private String brand;    // 商品品牌
    private String pic;      // 商品图片路径
    private int num;         // 商品库存
    private double price;    // 商品价格
    private String intro;    // 商品描述
    private int status;      // 商品状态（1-在售，0-下架）
    // 条件查询字段
    private double priceFrom; // 价格查询起始值
    private double priceTo;   // 价格查询结束值
}