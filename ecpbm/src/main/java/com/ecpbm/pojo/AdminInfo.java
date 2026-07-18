package com.ecpbm.pojo;

import java.util.List;

public class AdminInfo {
    private int id;
    private String name;  // 用户名
    private String pwd;   // 密码
    private List<Functions> fs;  // 关联的功能权限集合

    // Getter和Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public List<Functions> getFs() {
        return fs;
    }

    public void setFs(List<Functions> fs) {
        this.fs = fs;
    }
}