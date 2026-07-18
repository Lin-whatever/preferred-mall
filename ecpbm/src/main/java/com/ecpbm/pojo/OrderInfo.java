package com.ecpbm.pojo;

public class OrderInfo {
    private Integer id;
    private int uid; // 客户ID
    private UserInfo ui; // 关联用户
    private String status; // 订单状态（未付款/已付款）
    private String ordertime; // 下单时间
    private double orderprice; // 订单金额
    private String orderTimeFrom; // 查询用：开始时间
    private String orderTimeTo; // 查询用：结束时间

    // setter和getter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public int getUid() { return uid; }
    public void setUid(int uid) { this.uid = uid; }
    public UserInfo getUi() { return ui; }
    public void setUi(UserInfo ui) { this.ui = ui; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getOrdertime() { return ordertime; }
    public void setOrdertime(String ordertime) { this.ordertime = ordertime; }
    public double getOrderprice() { return orderprice; }
    public void setOrderprice(double orderprice) { this.orderprice = orderprice; }
    public String getOrderTimeFrom() { return orderTimeFrom; }
    public void setOrderTimeFrom(String orderTimeFrom) { this.orderTimeFrom = orderTimeFrom; }
    public String getOrderTimeTo() { return orderTimeTo; }
    public void setOrderTimeTo(String orderTimeTo) { this.orderTimeTo = orderTimeTo; }
}