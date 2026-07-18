package com.ecpbm.service;

import com.ecpbm.pojo.Type;

import java.util.List;

public interface TypeService {
    List<Type> getAll();
    Type selectById(int id);

    // 添加商品类型
    int addType(Type type);

    // 修改商品类型
    void updateType(Type type);
}