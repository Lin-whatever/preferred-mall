package com.ecpbm.service.impl;

import com.ecpbm.dao.OrderInfoDao;
import com.ecpbm.pojo.OrderDetail;
import com.ecpbm.pojo.OrderInfo;
import com.ecpbm.pojo.Pager;
import com.ecpbm.service.OrderInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("orderInfoService")
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT)
public class OrderInfoServiceImpl implements OrderInfoService {

    @Autowired
    private OrderInfoDao orderInfoDao;

    // 原有方法实现（不变）
    @Override
    public List<OrderInfo> findOrderInfo(OrderInfo orderInfo, Pager pager) {
        Map<String, Object> params = new HashMap<>();
        params.put("orderInfo", orderInfo);
        int recordCount = count(params);
        pager.setRowCount(recordCount);
        if (recordCount > 0) {
            params.put("pager", pager);
        }
        return orderInfoDao.selectByPage(params);
    }

    @Override
    public Integer count(Map<String, Object> params) {
        return orderInfoDao.count(params);
    }

    @Override
    public OrderInfo getOrderInfoById(int id) {
        return orderInfoDao.getOrderInfoById(id);
    }

    @Override
    public List<OrderDetail> getOrderDetailByOid(int oid) {
        return orderInfoDao.getOrderDetailByOid(oid);
    }

    // 新增：删除订单（先删明细，再删主表，避免外键约束）
    @Override
    public void deleteOrder(int oid) {
        // 1. 删除该订单的所有明细
        orderInfoDao.deleteOrderDetailByOid(oid);
        // 2. 删除订单主表
        orderInfoDao.deleteOrderById(oid);
    }

    // 新增：保存订单主表
    @Override
    public void addOrderInfo(OrderInfo orderInfo) {
        orderInfoDao.insertOrderInfo(orderInfo);
    }

    // 新增：保存订单明细
    @Override
    public void addOrderDetail(OrderDetail orderDetail) {
        orderInfoDao.insertOrderDetail(orderDetail);
    }
}