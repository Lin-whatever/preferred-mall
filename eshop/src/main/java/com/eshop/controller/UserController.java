package com.eshop.controller;

import com.eshop.dao.AdminInfoDao;
import com.eshop.pojo.UserInfo;
import org.springframework.jdbc.core.JdbcTemplate;
import javax.sql.DataSource;
import com.eshop.service.UserInfoService;
import com.eshop.util.JwtUtil;
import com.eshop.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserInfoService userInfoService;

    @Autowired
    private AdminInfoDao adminInfoDao;
    @Autowired
    private DataSource dataSource;
    private JdbcTemplate jdbc() { return new JdbcTemplate(dataSource); }

    @RequestMapping(value = "/login", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> login(@RequestParam String userName, @RequestParam String password) {
        Map<String, Object> result = new HashMap<>();
        UserInfo user = userInfoService.login(userName, password);
        if (user != null) {
            // Auto-upgrade plaintext password to BCrypt
            if (!user.getPassword().startsWith("$2")) {
                String hashed = PasswordUtil.encode(password);
                userInfoService.updatePassword(user.getId(), hashed);
            }
            String token = JwtUtil.createToken(user.getId(), user.getUserName());
            result.put("code", 200);
            result.put("token", token);
            result.put("user", user);
            result.put("role", "user");
            return result;
        }
        // Also check admin_info
        Map<String, Object> admin = adminInfoDao.selectByLogin(userName, password);
        if (admin != null) {
            String pwd = (String) admin.get("pwd");
            if (!PasswordUtil.matches(password, pwd)) { admin = null; }
            // Admin passwords NOT auto-upgraded to keep ecpbm compatibility
        }
        if (admin != null) {
            int adminId = (Integer) admin.get("id");
            String adminName = (String) admin.get("userName");
            String token = JwtUtil.createToken(adminId, adminName);
            admin.put("token", null);
            result.put("code", 200);
            result.put("token", token);
            result.put("user", admin);
            result.put("role", "admin");
            return result;
        }
        result.put("code", 401);
        result.put("msg", "user or password error");
        return result;
    }

    @RequestMapping(value = "/register", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> register(UserInfo user) {
        Map<String, Object> result = new HashMap<>();
        user.setPassword(PasswordUtil.encode(user.getPassword()));
        UserInfo newUser = userInfoService.register(user);
        if (newUser != null) {
            result.put("code", 200);
            result.put("msg", "register success");
        } else {
            result.put("code", 400);
            result.put("msg", "username exists");
        }
        return result;
    }

    @RequestMapping(value = "/info", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> getUserInfo(@RequestHeader(value = "Authorization", required = false) String token) {
        Map<String, Object> result = new HashMap<>();
        if (token == null || !JwtUtil.verify(token)) {
            result.put("code", 401);
            result.put("msg", "not logged in");
            return result;
        }
        int userId = JwtUtil.getUserId(token);
        UserInfo user = userInfoService.getUserById(userId);
        if (user != null) {
            user.setPassword(null);
            result.put("code", 200);
            result.put("user", user);
        } else {
            result.put("code", 404);
            result.put("msg", "user not found");
        }
        return result;
    }
    @RequestMapping(value = "/changePwd", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> changePwd(@RequestHeader(value = "Authorization", required = false) String token,
                                          @RequestParam String oldPwd, @RequestParam String newPwd) {
        Map<String, Object> result = new HashMap<>();
        if (token == null || !JwtUtil.verify(token)) {
            result.put("code", 401); result.put("msg", "请先登录"); return result;
        }
        int uid = JwtUtil.getUserId(token);
        UserInfo user = userInfoService.getUserById(uid);
        if (user == null || !PasswordUtil.matches(oldPwd, user.getPassword())) {
            result.put("code", 400); result.put("msg", "原密码错误"); return result;
        }
        userInfoService.updatePassword(uid, PasswordUtil.encode(newPwd));
        result.put("code", 200); result.put("msg", "修改成功");
        return result;
    }

}
