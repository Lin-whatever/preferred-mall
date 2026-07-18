package com.ecpbm.controller;

import com.ecpbm.pojo.UserInfo;
import com.ecpbm.pojo.Pager;
import com.ecpbm.service.UserInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/userinfo")
public class UserInfoController {

    @Autowired
    private UserInfoService userInfoService;

    // 获取合法用户（用于订单创建）
    @RequestMapping("/getValidUser")
    @ResponseBody
    public List<UserInfo> getValidUser() {
        List<UserInfo> uiList = userInfoService.getValidUser();
        UserInfo defaultUser = new UserInfo();
        defaultUser.setId(0);
        defaultUser.setUserName("请选择...");
        uiList.add(0, defaultUser);
        return uiList;
    }

    // 用户列表分页查询
    @RequestMapping("/list")
    @ResponseBody
    public Map<String, Object> userlist(Integer page, Integer rows, UserInfo userInfo) {
        Pager pager = new Pager();
        pager.setCurPage(page);
        pager.setPerPageRows(rows);

        Map<String, Object> params = new HashMap<>();
        params.put("userInfo", userInfo);
        int totalCount = userInfoService.count(params);
        List<UserInfo> userinfos = userInfoService.findUserInfo(userInfo, pager);

        Map<String, Object> result = new HashMap<>(2);
        result.put("total", totalCount);
        result.put("rows", userinfos);
        return result;
    }

    // 启用/禁用用户
    @RequestMapping(value = "/setIsEnableUser", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String setIsEnableUser(@RequestParam("uids") String uids, @RequestParam("flag") int flag) {
        try {
            String ids = uids; // 去除末尾逗号
            userInfoService.modifyStatus(ids, flag);
            return "{\"success\":\"true\",\"message\":\"操作成功\"}";
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"success\":\"false\",\"message\":\"操作失败\"}";
        }
    }
}