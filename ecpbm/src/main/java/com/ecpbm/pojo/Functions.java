package com.ecpbm.pojo;

import java.util.HashSet;
import java.util.Set;

public class Functions implements Comparable<Functions> {
    private int id;
    private String name;    // 功能名称（如“商品列表”）
    private int parentid;   // 父功能ID（0表示顶级功能）
    private boolean isleaf; // 是否为叶子节点（true=无下级功能）
    private Set ais = new HashSet();  // 关联的管理员集合（多对多）

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

    public int getParentid() {
        return parentid;
    }

    public void setParentid(int parentid) {
        this.parentid = parentid;
    }

    public boolean isIsleaf() {
        return isleaf;
    }

    public void setIsleaf(boolean isleaf) {
        this.isleaf = isleaf;
    }

    public Set getAis() {
        return ais;
    }

    public void setAis(Set ais) {
        this.ais = ais;
    }

    // 按ID排序（用于功能列表排序）
    @Override
    public int compareTo(Functions o) {
        return Integer.compare(this.getId(), o.getId());
    }
}