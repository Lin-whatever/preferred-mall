package com.ecpbm.service;

import com.ecpbm.pojo.OrderDetail;
import com.ecpbm.pojo.OrderInfo;
import com.ecpbm.pojo.Pager;

import java.util.List;
import java.util.Map;

public interface OrderInfoService {
    // 原有方法
    List<OrderInfo> findOrderInfo(OrderInfo orderInfo, Pager pager);
    Integer count(Map<String, Object> params);
    OrderInfo getOrderInfoById(int id);
    List<OrderDetail> getOrderDetailByOid(int oid);

    // 新增：删除订单（主表+明细）
    void deleteOrder(int oid);

    // 新增：保存订单主表（commitOrder 接口依赖）
    void addOrderInfo(OrderInfo orderInfo);

    // 新增：保存订单明细（commitOrder 接口依赖）
    void addOrderDetail(OrderDetail orderDetail);
}