package com.eshop.controller;

import com.eshop.pojo.ProductInfo;
import com.eshop.service.ProductInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/product")
public class ProductInfoController {

    @Autowired
    private ProductInfoService productInfoService;

    @RequestMapping(value = "/getProduct", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public List<ProductInfo> getProductInfo() {
        return productInfoService.getProductInfo();
    }

    @RequestMapping(value = "/getProductById/{id}", method = RequestMethod.GET)
    @ResponseBody
    public ProductInfo getProductById(@PathVariable("id") Integer id) {
        return productInfoService.getProductInfoById(id);
    }

    @RequestMapping(value = "/search", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public List<ProductInfo> searchProduct(@RequestParam String keyword) {
        return productInfoService.searchProductInfo(keyword);
    }

    @RequestMapping(value = "/page", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> getProductByPage(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size) {
        return productInfoService.getProductInfoByPage(page, size);
    }
}
