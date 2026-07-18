package com.eshop.pojo;

public class OrderInfo {
    private Integer id;
    private int uid;
    private String status;
    private String ordertime;
    private double orderprice;

    // set/get方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public int getUid() { return uid; }
    public void setUid(int uid) { this.uid = uid; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getOrdertime() { return ordertime; }
    public void setOrdertime(String ordertime) { this.ordertime = ordertime; }
    public double getOrderprice() { return orderprice; }
    public void setOrderprice(double orderprice) { this.orderprice = orderprice; }

    @Override
    public String toString() {
        return "OrderInfo{" +
                "id=" + id +
                ", uid=" + uid +
                ", status='" + status + '\'' +
                ", ordertime='" + ordertime + '\'' +
                ", orderprice=" + orderprice +
                '}';
    }
}