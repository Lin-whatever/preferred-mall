package com.eshop.controller;

import com.eshop.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import javax.sql.DataSource;
import java.util.*;

@Controller
@RequestMapping("/favorite")
public class FavoriteController {

    @Autowired
    private DataSource dataSource;
    private JdbcTemplate jdbc() { return new JdbcTemplate(dataSource); }
    private int getUid(String token) {
        if (token == null || !JwtUtil.verify(token)) return 0;
        return JwtUtil.getUserId(token);
    }

    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> list(@RequestHeader("Authorization") String token) {
        Map<String, Object> r = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { r.put("code", 401); return r; }
        String sql = "SELECT f.id, p.id as pid, p.name, p.pic, p.price, f.created_time FROM favorites f JOIN product_info p ON f.product_code = p.code WHERE f.user_id = ? ORDER BY f.id DESC";
        r.put("code", 200);
        r.put("list", jdbc().queryForList(sql, uid));
        return r;
    }

    @PostMapping("/add")
    @ResponseBody
    public Map<String, Object> add(@RequestHeader("Authorization") String token, @RequestParam int productId) {
        Map<String, Object> r = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { r.put("code", 401); return r; }
        try {
            String code = jdbc().queryForObject("SELECT code FROM product_info WHERE id = ?", String.class, productId);
            int cnt = jdbc().queryForObject("SELECT COUNT(*) FROM favorites WHERE user_id = ? AND product_code = ?", Integer.class, uid, code);
            if (cnt == 0) jdbc().update("INSERT INTO favorites(user_id, product_code, created_time) VALUES(?,?,NOW())", uid, code);
            r.put("code", 200); r.put("msg", "收藏成功");
        } catch (Exception e) { r.put("code", 500); r.put("msg", e.getMessage()); }
        return r;
    }

    @PostMapping("/remove")
    @ResponseBody
    public Map<String, Object> remove(@RequestHeader("Authorization") String token, @RequestParam int productId) {
        Map<String, Object> r = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { r.put("code", 401); return r; }
        try {
            String code = jdbc().queryForObject("SELECT code FROM product_info WHERE id = ?", String.class, productId);
            jdbc().update("DELETE FROM favorites WHERE user_id = ? AND product_code = ?", uid, code);
            r.put("code", 200); r.put("msg", "已取消收藏");
        } catch (Exception e) { r.put("code", 500); }
        return r;
    }

    @GetMapping("/check/{productId}")
    @ResponseBody
    public Map<String, Object> check(@RequestHeader("Authorization") String token, @PathVariable int productId) {
        Map<String, Object> r = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { r.put("code", 401); return r; }
        try {
            String code = jdbc().queryForObject("SELECT code FROM product_info WHERE id = ?", String.class, productId);
            int cnt = jdbc().queryForObject("SELECT COUNT(*) FROM favorites WHERE user_id = ? AND product_code = ?", Integer.class, uid, code);
            r.put("code", 200); r.put("favorited", cnt > 0);
        } catch (Exception e) { r.put("code", 200); r.put("favorited", false); }
        return r;
    }
}
