package com.eshop.service;

import com.eshop.pojo.ProductInfo;
import java.util.List;
import java.util.Map;

public interface ProductInfoService {
    List<ProductInfo> getProductInfo();
    ProductInfo getProductInfoById(int id);
    List<ProductInfo> searchProductInfo(String keyword);
    Map<String, Object> getProductInfoByPage(int page, int size);
}
