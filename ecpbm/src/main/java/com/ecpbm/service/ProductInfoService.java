package com.ecpbm.service;

import com.ecpbm.pojo.ProductInfo;
import com.ecpbm.pojo.Pager;

import java.util.List;
import java.util.Map;

public interface ProductInfoService {
    List<ProductInfo> findProductInfo(ProductInfo productInfo, Pager pager);
    Integer count(Map<String, Object> params);

    // 添加商品
    void addProductInfo(ProductInfo pi);

    // 修改商品
    void modifyProductInfo(ProductInfo pi);

    // 更新商品状态
    void modifyStatus(String ids, int flag);

    // 根据ID查询商品
    ProductInfo getProductInfoById(int id);

    // 获取在售商品
    List<ProductInfo> getOnSaleProduct();
}