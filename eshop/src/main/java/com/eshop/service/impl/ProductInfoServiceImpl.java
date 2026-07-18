package com.eshop.service.impl;

import com.eshop.dao.ProductInfoDao;
import com.eshop.pojo.ProductInfo;
import com.eshop.service.ProductInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

@Service("productInfoService")
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT)
public class ProductInfoServiceImpl implements ProductInfoService {

    @Autowired
    private ProductInfoDao productInfoDao;

    @Override
    public List<ProductInfo> getProductInfo() {
        return productInfoDao.selectProductInfo();
    }

    @Override
    public ProductInfo getProductInfoById(int id) {
        return productInfoDao.selectProductInfoById(id);
    }

    @Override
    public List<ProductInfo> searchProductInfo(String keyword) {
        return productInfoDao.searchProductInfo(keyword);
    }

    @Override
    public Map<String, Object> getProductInfoByPage(int page, int size) {
        int total = productInfoDao.countProductInfo();
        int offset = (page - 1) * size;
        List<ProductInfo> list = productInfoDao.selectProductInfoByPage(offset, size);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("total", total);
        result.put("page", page);
        result.put("size", size);
        result.put("pages", (int) Math.ceil((double) total / size));
        return result;
    }
}
