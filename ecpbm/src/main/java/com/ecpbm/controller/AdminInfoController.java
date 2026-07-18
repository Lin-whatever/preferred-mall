package com.ecpbm.controller;

import com.ecpbm.pojo.AdminInfo;
import com.ecpbm.pojo.TreeNode;
import com.ecpbm.service.AdminInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;

import java.util.List;

@SessionAttributes(value = {"admin"})
@Controller
@RequestMapping("/admininfo")
public class AdminInfoController {

    @Autowired
    private AdminInfoService adminInfoService;

    // 登录接口（原有代码）
    @RequestMapping(value = "/login", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String login(AdminInfo ai, ModelMap model) {
        AdminInfo admininfo = adminInfoService.login(ai);
        if (admininfo != null && admininfo.getName() != null) {
            admininfo = adminInfoService.getAdminInfoAndFunctions(admininfo.getId());
            if (admininfo.getFs().size() > 0) {
                model.put("admin", admininfo);
                return "{\"success\":\"true\",\"message\":\"登录成功\"}";
            } else {
                return "{\"success\":\"false\",\"message\":\"无权限，请联系超级管理员\"}";
            }
        } else {
            return "{\"success\":\"false\",\"message\":\"登录失败\"}";
        }
    }

    // 退出接口
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    @ResponseBody
    public String logout(SessionStatus status) {
        status.setComplete(); // 清除session
        return "{\"success\":\"true\",\"message\":\"注销成功\"}";
    }

    // Tree结构数据接口（原有代码）
    @RequestMapping("getTree")
    @ResponseBody
    public List<TreeNode> getTree(@RequestParam("adminid") String adminid) {
        AdminInfo admininfo = adminInfoService.getAdminInfoAndFunctions(Integer.parseInt(adminid));
        List<com.ecpbm.pojo.Functions> functionsList = admininfo.getFs();

        java.util.Collections.sort(functionsList);
        List<com.ecpbm.pojo.TreeNode> nodes = new java.util.ArrayList<>();
        for (com.ecpbm.pojo.Functions func : functionsList) {
            com.ecpbm.pojo.TreeNode treeNode = new com.ecpbm.pojo.TreeNode();
            treeNode.setId(func.getId());
            treeNode.setFid(func.getParentid());
            treeNode.setText(func.getName());
            nodes.add(treeNode);
        }

        return com.ecpbm.util.JsonFactory.buildtree(nodes, 0);
    }
}