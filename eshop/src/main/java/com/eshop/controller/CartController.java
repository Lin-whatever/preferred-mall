package com.eshop.controller;

import com.eshop.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.sql.DataSource;
import java.util.*;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private DataSource dataSource;

    private JdbcTemplate jdbc() {
        return new JdbcTemplate(dataSource);
    }

    private int getUserId(String token) {
        if (token == null || !JwtUtil.verify(token)) return 0;
        return JwtUtil.getUserId(token);
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    @ResponseBody
    public List<Map<String, Object>> list(@RequestHeader(value = "Authorization", required = false) String token) {
        int uid = getUserId(token);
        if (uid == 0) return new ArrayList<>();
        String sql = "SELECT c.id, c.product_code, c.quantity, p.id as pid, p.name, p.pic, p.price " +
                     "FROM cart c JOIN product_info p ON c.product_code = p.code WHERE c.user_id = ?";
        return jdbc().queryForList(sql, uid);
    }

    @RequestMapping(value = "/add", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> add(@RequestHeader(value = "Authorization", required = false) String token,
                                    @RequestParam int productId, @RequestParam(defaultValue = "1") int quantity) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUserId(token);
        if (uid == 0) { result.put("code", 401); result.put("msg", "not logged in"); return result; }
        try {
            String code = jdbc().queryForObject("SELECT code FROM product_info WHERE id = ?", String.class, productId);
            int count = jdbc().queryForObject("SELECT COUNT(*) FROM cart WHERE user_id = ? AND product_code = ?", Integer.class, uid, code);
            if (count > 0) {
                jdbc().update("UPDATE cart SET quantity = quantity + ? WHERE user_id = ? AND product_code = ?", quantity, uid, code);
            } else {
                jdbc().update("INSERT INTO cart(user_id, product_code, quantity, selected) VALUES(?,?,?,1)", uid, code, quantity);
            }
            result.put("code", 200);
        } catch (Exception e) {
            result.put("code", 500); result.put("msg", e.getMessage());
        }
        return result;
    }

    @RequestMapping(value = "/update", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> update(@RequestHeader(value = "Authorization", required = false) String token,
                                       @RequestParam int productId, @RequestParam int quantity) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUserId(token);
        if (uid == 0) { result.put("code", 401); return result; }
        try {
            String code = jdbc().queryForObject("SELECT code FROM product_info WHERE id = ?", String.class, productId);
            jdbc().update("UPDATE cart SET quantity = ? WHERE user_id = ? AND product_code = ?", quantity, uid, code);
            result.put("code", 200);
        } catch (Exception e) {
            result.put("code", 500); result.put("msg", e.getMessage());
        }
        return result;
    }

    @RequestMapping(value = "/remove", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> remove(@RequestHeader(value = "Authorization", required = false) String token,
                                       @RequestParam int productId) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUserId(token);
        if (uid == 0) { result.put("code", 401); return result; }
        try {
            String code = jdbc().queryForObject("SELECT code FROM product_info WHERE id = ?", String.class, productId);
            jdbc().update("DELETE FROM cart WHERE user_id = ? AND product_code = ?", uid, code);
            result.put("code", 200);
        } catch (Exception e) {
            result.put("code", 500); result.put("msg", e.getMessage());
        }
        return result;
    }

    @RequestMapping(value = "/clear", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> clear(@RequestHeader(value = "Authorization", required = false) String token) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUserId(token);
        if (uid == 0) { result.put("code", 401); return result; }
        jdbc().update("DELETE FROM cart WHERE user_id = ?", uid);
        result.put("code", 200);
        return result;
    }
}
