package com.eshop.service;

import com.eshop.pojo.OrderInfo;
import java.util.List;

public interface OrderInfoService {
    int addOrderInfo(OrderInfo oi);
    void addOrderDetail(int oid, int pid, int num);
    List<OrderInfo> getOrdersByUid(int uid);
    OrderInfo getOrderById(int id);
    void updateStatus(int id, String status);
}
