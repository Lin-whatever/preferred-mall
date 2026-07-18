package com.eshop.pojo;

public class OrderDetail {
    private int id;
    private int oid;
    private int pid;
    private int num;

    // set/get方法
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOid() { return oid; }
    public void setOid(int oid) { this.oid = oid; }
    public int getPid() { return pid; }
    public void setPid(int pid) { this.pid = pid; }
    public int getNum() { return num; }
    public void setNum(int num) { this.num = num; }

    @Override
    public String toString() {
        return "OrderDetail{" +
                "id=" + id +
                ", oid=" + oid +
                ", pid=" + pid +
                ", num=" + num +
                '}';
    }
}