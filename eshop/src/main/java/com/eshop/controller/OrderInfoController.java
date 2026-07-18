package com.eshop.controller;

import com.eshop.pojo.OrderInfo;
import com.eshop.pojo.ProductInfo;
import com.eshop.service.OrderInfoService;
import com.eshop.service.ProductInfoService;
import com.eshop.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/order")
public class OrderInfoController {

    @Autowired
    private OrderInfoService orderInfoService;
    @Autowired
    private ProductInfoService productInfoService;

    private int getUid(String token) {
        if (token == null || !JwtUtil.verify(token)) return 0;
        return JwtUtil.getUserId(token);
    }

    // 提交订单
    @RequestMapping(value = "/submit", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> submit(
            @RequestHeader(value = "Authorization", required = false) String token,
            @RequestParam String cartJson) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { result.put("code", 401); result.put("msg", "请先登录"); return result; }
        try {
            List<Map<String, Object>> cartItems = new com.fasterxml.jackson.databind.ObjectMapper()
                .readValue(cartJson, new com.fasterxml.jackson.core.type.TypeReference<List<Map<String, Object>>>() {});
            if (cartItems == null || cartItems.isEmpty()) {
                result.put("code", 400); result.put("msg", "购物车为空"); return result;
            }
            OrderInfo oi = new OrderInfo();
            oi.setUid(uid);
            oi.setStatus("待付款");
            oi.setOrdertime(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            double total = 0;
            for (Map<String, Object> ci : cartItems) {
                int pid = (Integer) ci.get("id");
                int count = (Integer) ci.get("count");
                ProductInfo pi = productInfoService.getProductInfoById(pid);
                if (pi == null) { result.put("code", 400); result.put("msg", "商品不存在"); return result; }
                total += count * pi.getPrice();
            }
            oi.setOrderprice(total);
            orderInfoService.addOrderInfo(oi);
            for (Map<String, Object> ci : cartItems) {
                int pid = (Integer) ci.get("id");
                int count = (Integer) ci.get("count");
                orderInfoService.addOrderDetail(oi.getId(), pid, count);
            }
            result.put("code", 200);
            result.put("msg", "下单成功");
            result.put("orderId", oi.getId());
        } catch (Exception e) {
            result.put("code", 500); result.put("msg", e.getMessage());
        }
        return result;
    }

    // 我的订单列表
    @RequestMapping(value = "/myOrders", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> myOrders(
            @RequestHeader(value = "Authorization", required = false) String token) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { result.put("code", 401); result.put("msg", "请先登录"); return result; }
        List<OrderInfo> orders = orderInfoService.getOrdersByUid(uid);
        result.put("code", 200);
        result.put("list", orders);
        return result;
    }

    // 订单详情
    @RequestMapping(value = "/detail/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> detail(
            @RequestHeader(value = "Authorization", required = false) String token,
            @PathVariable int id) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { result.put("code", 401); return result; }
        OrderInfo order = orderInfoService.getOrderById(id);
        if (order == null || order.getUid() != uid) {
            result.put("code", 404); result.put("msg", "订单不存在"); return result;
        }
        result.put("code", 200);
        result.put("order", order);
        return result;
    }

    // 取消订单
    @RequestMapping(value = "/cancel/{id}", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> cancel(
            @RequestHeader(value = "Authorization", required = false) String token,
            @PathVariable int id) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { result.put("code", 401); return result; }
        OrderInfo order = orderInfoService.getOrderById(id);
        if (order == null || order.getUid() != uid) {
            result.put("code", 404); result.put("msg", "订单不存在"); return result;
        }
        orderInfoService.updateStatus(id, "已取消");
        result.put("code", 200); result.put("msg", "订单已取消");
        return result;
    }

    // 模拟支付
    @RequestMapping(value = "/pay/{id}", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> pay(
            @RequestHeader(value = "Authorization", required = false) String token,
            @PathVariable int id) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { result.put("code", 401); return result; }
        OrderInfo order = orderInfoService.getOrderById(id);
        if (order == null || order.getUid() != uid) {
            result.put("code", 404); return result;
        }
        if (!"待付款".equals(order.getStatus())) {
            result.put("code", 400); result.put("msg", "订单状态不允许支付"); return result;
        }
        orderInfoService.updateStatus(id, "已付款");
        result.put("code", 200); result.put("msg", "支付成功");
        return result;
    }

    // 确认收货
    @RequestMapping(value = "/confirm/{id}", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> confirm(
            @RequestHeader(value = "Authorization", required = false) String token,
            @PathVariable int id) {
        Map<String, Object> result = new HashMap<>();
        int uid = getUid(token);
        if (uid == 0) { result.put("code", 401); return result; }
        OrderInfo order = orderInfoService.getOrderById(id);
        if (order == null || order.getUid() != uid) {
            result.put("code", 404); return result;
        }
        orderInfoService.updateStatus(id, "已完成");
        result.put("code", 200); result.put("msg", "已确认收货");
        return result;
    }
}
