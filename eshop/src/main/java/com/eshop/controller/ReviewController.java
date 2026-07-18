package com.eshop.controller;

import com.eshop.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import javax.sql.DataSource;
import java.util.*;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private DataSource dataSource;
    private JdbcTemplate jdbc() { return new JdbcTemplate(dataSource); }
    private int getUid(String token) {
        if (token == null || !JwtUtil.verify(token)) return 0;
        return JwtUtil.getUserId(token);
    }

    // 获取某商品的评价列表
    @GetMapping("/list/{productId}")
    @ResponseBody
    public Map<String, Object> list(@PathVariable int productId) {
        Map<String, Object> r = new HashMap<>();
        try {
            String code = jdbc().queryForObject("SELECT code FROM product_info WHERE id = ?", String.class, productId);
            String sql = "SELECT r.*, u.userName, u.realName FROM reviews r LEFT JOIN user_info u ON r.user_id = u.id WHERE r.product_code = ? AND r.status = 1 ORDER BY r.created_time DESC";
            List<Map<String, Object>> list = jdbc().queryForList(sql, code);
            r.put("code", 200);
            r.put("list", list);
        } catch (Exception e) {
            r.put("code", 200); r.put("list", new ArrayList<>());
        }
        return r;
    }

    // 发表评价
    @PostMapping("/add")
    @ResponseBody
    public Map<String, Object> add(@RequestHeader("Authorization") String token,
            @RequestParam int productId, @RequestParam int rating,
            @RequestParam String comment, @RequestParam(defaultValue = "0") int anonymous) {
        Map<String, Object> r = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { r.put("code", 401); r.put("msg", "请先登录"); return r; }
        try {
            String code = jdbc().queryForObject("SELECT code FROM product_info WHERE id = ?", String.class, productId);
            jdbc().update("INSERT INTO reviews(user_id, product_code, rating, comment, is_anonymous, status, created_time) VALUES(?,?,?,?,?,1,NOW())",
                uid, code, rating, comment, anonymous);
            r.put("code", 200); r.put("msg", "评价成功");
        } catch (Exception e) {
            r.put("code", 500); r.put("msg", e.getMessage());
        }
        return r;
    }
}
