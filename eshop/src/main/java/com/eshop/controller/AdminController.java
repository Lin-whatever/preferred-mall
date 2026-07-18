package com.eshop.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import javax.sql.DataSource;
import java.io.File;
import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private DataSource dataSource;
    private JdbcTemplate jdbc() { return new JdbcTemplate(dataSource); }

    // Upload to external directory that Spring Boot serves
    
    @GetMapping("/stats")
    @ResponseBody
    public Map<String, Object> stats() {
        Map<String, Object> r = new HashMap<>();
        int products = jdbc().queryForObject("SELECT COUNT(*) FROM product_info", Integer.class);
        int orders = jdbc().queryForObject("SELECT COUNT(*) FROM order_info", Integer.class);
        int users = jdbc().queryForObject("SELECT COUNT(*) FROM user_info", Integer.class);
        Double revenue = jdbc().queryForObject("SELECT COALESCE(SUM(orderprice),0) FROM order_info WHERE status IN('已付款','已完成')", Double.class);
        r.put("code", 200);
        r.put("products", products);
        r.put("orders", orders);
        r.put("users", users);
        r.put("revenue", revenue);
        return r;
    }


    private static final String UPLOAD_DIR = "E:/webweb/eshop/uploads/";

    @PostMapping("/uploadForProduct")
    @ResponseBody
    public Map<String, Object> uploadForProduct(@RequestParam("file") MultipartFile file, @RequestParam int productId) {
        Map<String, Object> r = new HashMap<>();
        try {
            File dir = new File(UPLOAD_DIR);
            if (!dir.exists()) dir.mkdirs();
            // Save as productId.png (user can use PNG)
            String fileName = productId + ".png";
            File dest = new File(dir, fileName);
            file.transferTo(dest);
            // Update database
            jdbc().update("UPDATE product_info SET pic = ? WHERE id = ?", fileName, productId);
            r.put("code", 200);
            r.put("msg", "上传成功！刷新首页即可看到");
        } catch (Exception e) {
            r.put("code", 500);
            r.put("msg", e.getMessage());
        }
        return r;
    }
}
