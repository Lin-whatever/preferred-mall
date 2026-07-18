package com.ecpbm.controller;

import com.ecpbm.pojo.Type;
import com.ecpbm.service.TypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/type")
public class TypeController {

    @Autowired
    private TypeService typeService;

    // 获取商品类型（支持添加默认选项）
    @RequestMapping("/getType/{flag}")
    @ResponseBody
    public List<Type> getType(@PathVariable("flag") Integer flag) {
        List<Type> typeList = typeService.getAll();
        if (flag == 1) {
            Type defaultType = new Type();
            defaultType.setId(0);
            defaultType.setName("请选择...");
            typeList.add(0, defaultType);
        }
        return typeList;
    }

    // 添加商品类型
    @RequestMapping(value = "/addType", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String addType(Type type) {
        try {
            typeService.addType(type);
            return "{\"success\":\"true\",\"message\":\"添加成功\"}";
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"success\":\"false\",\"message\":\"添加失败\"}";
        }
    }

    // 修改商品类型
    @RequestMapping(value = "/updateType", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String updateType(Type type) {
        try {
            typeService.updateType(type);
            return "{\"success\":\"true\",\"message\":\"修改成功\"}";
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"success\":\"false\",\"message\":\"修改失败\"}";
        }
    }
}