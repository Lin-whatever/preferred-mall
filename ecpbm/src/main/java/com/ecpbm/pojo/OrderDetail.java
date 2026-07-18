package com.ecpbm.pojo;

public class OrderDetail {
    private int id;
    private int oid; // 订单ID
    private OrderInfo oi; // 关联订单
    private int pid; // 商品ID
    private ProductInfo pi; // 关联商品
    private int num; // 购买数量
    private double price; // 商品单价
    private double totalprice; // 小计（数量×单价）

    // setter和getter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOid() { return oid; }
    public void setOid(int oid) { this.oid = oid; }
    public OrderInfo getOi() { return oi; }
    public void setOi(OrderInfo oi) { this.oi = oi; }
    public int getPid() { return pid; }
    public void setPid(int pid) { this.pid = pid; }
    public ProductInfo getPi() { return pi; }
    public void setPi(ProductInfo pi) { this.pi = pi; }
    public int getNum() { return num; }
    public void setNum(int num) { this.num = num; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public double getTotalprice() { return totalprice; }
    public void setTotalprice(double totalprice) { this.totalprice = totalprice; }
}