package com.ecpbm.controller;

import com.ecpbm.pojo.ProductInfo;
import com.ecpbm.pojo.Pager;
import com.ecpbm.service.ProductInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/productinfo")
public class ProductInfoController {

    @Autowired
    private ProductInfoService productInfoService;

    // 商品列表分页查询
    @RequestMapping(value = "/list")
    @ResponseBody
    public Map<String, Object> list(Integer page, Integer rows, ProductInfo productInfo) {
        Pager pager = new Pager();
        pager.setCurPage(page);
        pager.setPerPageRows(rows);

        Map<String, Object> params = new HashMap<>();
        params.put("productInfo", productInfo);
        int totalCount = productInfoService.count(params);
        List<ProductInfo> productinfos = productInfoService.findProductInfo(productInfo, pager);

        Map<String, Object> result = new HashMap<>(2);
        result.put("total", totalCount);
        result.put("rows", productinfos);
        return result;
    }

    // 添加商品（支持图片上传）
    @RequestMapping(value = "/addProduct", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String addProduct(ProductInfo pi,
                             @RequestParam(value = "file", required = false) MultipartFile file,
                             HttpServletRequest request) {
        // 图片保存路径
        String path = request.getSession().getServletContext().getRealPath("product_images");
        if (file != null && !file.isEmpty()) {
            String fileName = file.getOriginalFilename();
            File targetFile = new File(path, fileName);
            if (!targetFile.getParentFile().exists()) {
                targetFile.getParentFile().mkdirs();
            }
            try {
                file.transferTo(targetFile);
                pi.setPic(fileName);
            } catch (Exception e) {
                e.printStackTrace();
                return "{\"success\":\"false\",\"message\":\"图片上传失败\"}";
            }
        }

        try {
            productInfoService.addProductInfo(pi);
            return "{\"success\":\"true\",\"message\":\"商品添加成功\"}";
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"success\":\"false\",\"message\":\"商品添加失败\"}";
        }
    }

    // 修改商品
    @RequestMapping(value = "/updateProduct", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String updateProduct(ProductInfo pi,
                                @RequestParam(value = "file", required = false) MultipartFile file,
                                HttpServletRequest request) {
        // 图片更新（可选）
        if (file != null && !file.isEmpty()) {
            String path = request.getSession().getServletContext().getRealPath("product_images");
            String fileName = file.getOriginalFilename();
            File targetFile = new File(path, fileName);
            if (!targetFile.getParentFile().exists()) {
                targetFile.getParentFile().mkdirs();
            }
            try {
                file.transferTo(targetFile);
                pi.setPic(fileName);
            } catch (Exception e) {
                e.printStackTrace();
                return "{\"success\":\"false\",\"message\":\"图片更新失败\"}";
            }
        }

        try {
            productInfoService.modifyProductInfo(pi);
            return "{\"success\":\"true\",\"message\":\"商品修改成功\"}";
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"success\":\"false\",\"message\":\"商品修改失败\"}";
        }
    }

    // 商品下架（删除）
    @RequestMapping(value = "/deleteProduct", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String deleteProduct(@RequestParam("id") String id, @RequestParam("flag") int flag) {
        try {
//            String ids = id.substring(0, id.length() - 1); // 去除末尾逗号
            productInfoService.modifyStatus(id, flag);
            return "{\"success\":\"true\",\"message\":\"操作成功\"}";
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"success\":\"false\",\"message\":\"操作失败\"}";
        }
    }

    // 根据商品ID获取单价（用于订单创建）
    @ResponseBody
    @RequestMapping("/getPriceById")
    public String getPriceById(@RequestParam("pid") String pid) {
        if (pid != null && !"".equals(pid)) {
            ProductInfo pi = productInfoService.getProductInfoById(Integer.parseInt(pid));
            return pi.getPrice() + "";
        }
        return "";
    }

    // 获取在售商品（用于订单创建）
    @ResponseBody
    @RequestMapping("/getOnSaleProduct")
    public List<ProductInfo> getOnSaleProduct() {
        return productInfoService.getOnSaleProduct();
    }
}