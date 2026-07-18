package com.ecpbm.controller;

import com.ecpbm.pojo.OrderDetail;
import com.ecpbm.pojo.OrderInfo;
import com.ecpbm.pojo.Pager;
import com.ecpbm.service.OrderInfoService;
import com.ecpbm.service.ProductInfoService;
import com.ecpbm.service.UserInfoService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/orderinfo")
public class OrderInfoController {

    @Autowired
    private OrderInfoService orderInfoService;
    @Autowired
    private UserInfoService userInfoService;
    @Autowired
    private ProductInfoService productInfoService;

    // 原有接口：订单列表分页查询
    @RequestMapping("/list")
    @ResponseBody
    public Map<String, Object> list(Integer page, Integer rows, OrderInfo orderInfo) {
        Pager pager = new Pager();
        pager.setCurPage(page);
        pager.setPerPageRows(rows);

        Map<String, Object> params = new HashMap<>();
        params.put("orderInfo", orderInfo);
        int totalCount = orderInfoService.count(params);
        List<OrderInfo> orderinfos = orderInfoService.findOrderInfo(orderInfo, pager);

        Map<String, Object> result = new HashMap<>(2);
        result.put("rows", orderinfos);
        result.put("total", totalCount);

        return result;
    }
    // 新增接口：保存订单（主表+明细）
    @ResponseBody
    @RequestMapping("/commitOrder")
    public String commitOrder(@RequestParam("inserted") String inserted, @RequestParam("orderinfo") String orderinfo) throws IOException {
        try {
            ObjectMapper mapper = new ObjectMapper();
            // 忽略未知属性，避免JSON转换报错
            mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
            mapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);

            // 解析订单主表
            OrderInfo oi = mapper.readValue(orderinfo, OrderInfo[].class)[0];
            orderInfoService.addOrderInfo(oi);

            // 解析订单明细
            List<OrderDetail> odList = mapper.readValue(inserted, new TypeReference<ArrayList<OrderDetail>>() {});
            for (OrderDetail od : odList) {
                od.setOid(oi.getId()); // 关联订单ID
                orderInfoService.addOrderDetail(od);
            }
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "failure";
        }
    }



    // 原有接口：查看订单明细（跳转页面）
    @RequestMapping("/getOrderInfo")
    public String getOrderInfo(String oid, Model model) {
        OrderInfo oi = orderInfoService.getOrderInfoById(Integer.parseInt(oid));
        model.addAttribute("oi", oi);
        // 如果JSP文件在webapp根目录下
        return "forward:/orderdetail.jsp";
    }

    // 原有接口：获取订单明细数据
    @RequestMapping("/getOrderDetails")
    @ResponseBody
    public List<OrderDetail> getOrderDetails(String oid) {
        List<OrderDetail> ods = orderInfoService.getOrderDetailByOid(Integer.parseInt(oid));
        for (OrderDetail od : ods) {
            od.setPrice(od.getPi().getPrice());
            od.setTotalprice(od.getPrice() * od.getNum());
        }
        return ods;
    }


    // 新增接口：删除订单（主表+明细）- 修复版
    @ResponseBody
    @RequestMapping(value = "/deleteOrder", produces = "application/json;charset=UTF-8")
    public Map<String, Object> deleteOrder(@RequestParam("oids") String oids) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 检查参数是否为空
            if (oids == null || oids.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "订单ID不能为空！");
                return result;
            }

            // 去除可能的末尾逗号
            if (oids.endsWith(",")) {
                oids = oids.substring(0, oids.length() - 1);
            }

            String[] ids = oids.split(",");
            int successCount = 0;
            int failCount = 0;

            for (String idStr : ids) {
                try {
                    // 过滤空字符串
                    if (idStr != null && !idStr.trim().isEmpty()) {
                        int id = Integer.parseInt(idStr.trim());
                        orderInfoService.deleteOrder(id);
                        successCount++;
                    }
                } catch (NumberFormatException e) {
                    failCount++;
                    e.printStackTrace();
                } catch (Exception e) {
                    failCount++;
                    e.printStackTrace();
                }
            }

            result.put("success", true);
            result.put("message", "删除完成！成功：" + successCount + "个，失败：" + failCount + "个");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "删除过程中发生异常：" + e.getMessage());
        }

        return result;
    }


}