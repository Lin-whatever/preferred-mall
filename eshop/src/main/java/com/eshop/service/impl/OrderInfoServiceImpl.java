package com.eshop.service.impl;

import com.eshop.dao.OrderInfoDao;
import com.eshop.pojo.OrderInfo;
import com.eshop.service.OrderInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service("orderInfoService")
@Transactional
public class OrderInfoServiceImpl implements OrderInfoService {

    @Autowired
    private OrderInfoDao orderInfoDao;

    @Override
    public int addOrderInfo(OrderInfo oi) {
        return orderInfoDao.insertOrder(oi);
    }

    @Override
    public void addOrderDetail(int oid, int pid, int num) {
        orderInfoDao.insertOrderDetail(oid, pid, num);
    }

    @Override
    public List<OrderInfo> getOrdersByUid(int uid) {
        return orderInfoDao.selectByUid(uid);
    }

    @Override
    public OrderInfo getOrderById(int id) {
        return orderInfoDao.selectById(id);
    }

    @Override
    public void updateStatus(int id, String status) {
        orderInfoDao.updateStatus(id, status);
    }
}
