package com.eshop.controller;

import com.eshop.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import javax.sql.DataSource;
import java.util.*;

@Controller
@RequestMapping("/address")
public class AddressController {

    @Autowired
    private DataSource dataSource;
    private JdbcTemplate jdbc() { return new JdbcTemplate(dataSource); }
    private int getUid(String token) {
        if (token == null || !JwtUtil.verify(token)) return 0;
        return JwtUtil.getUserId(token);
    }

    // 地址列表
    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> list(@RequestHeader(value = "Authorization", required = false) String token) {
        Map<String, Object> r = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { r.put("code", 401); return r; }
        r.put("code", 200);
        r.put("list", jdbc().queryForList("SELECT * FROM addresses WHERE user_id = ? AND status = 1 ORDER BY is_default DESC, id DESC", uid));
        return r;
    }

    // 添加地址
    @PostMapping("/add")
    @ResponseBody
    public Map<String, Object> add(@RequestHeader("Authorization") String token,
            @RequestParam String receiverName, @RequestParam String receiverPhone,
            @RequestParam String province, @RequestParam String city,
            @RequestParam String district, @RequestParam String detailAddress,
            @RequestParam(defaultValue = "0") int isDefault) {
        Map<String, Object> r = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { r.put("code", 401); return r; }
        if (isDefault == 1) jdbc().update("UPDATE addresses SET is_default = 0 WHERE user_id = ?", uid);
        jdbc().update("INSERT INTO addresses(user_id,receiver_name,receiver_phone,province,city,district,detail_address,is_default) VALUES(?,?,?,?,?,?,?,?)",
            uid, receiverName, receiverPhone, province, city, district, detailAddress, isDefault);
        r.put("code", 200); r.put("msg", "添加成功");
        return r;
    }

    // 删除地址
    @PostMapping("/delete/{id}")
    @ResponseBody
    public Map<String, Object> delete(@RequestHeader("Authorization") String token, @PathVariable int id) {
        Map<String, Object> r = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { r.put("code", 401); return r; }
        jdbc().update("UPDATE addresses SET status = 0 WHERE id = ? AND user_id = ?", id, uid);
        r.put("code", 200); r.put("msg", "删除成功");
        return r;
    }

    // 设为默认
    @PostMapping("/setDefault/{id}")
    @ResponseBody
    public Map<String, Object> setDefault(@RequestHeader("Authorization") String token, @PathVariable int id) {
        Map<String, Object> r = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { r.put("code", 401); return r; }
        jdbc().update("UPDATE addresses SET is_default = 0 WHERE user_id = ?", uid);
        jdbc().update("UPDATE addresses SET is_default = 1 WHERE id = ? AND user_id = ?", id, uid);
        r.put("code", 200); r.put("msg", "设置成功");
        return r;
    }
}
