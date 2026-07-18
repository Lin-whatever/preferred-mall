package com.ecpbm.dao;

import com.ecpbm.pojo.Functions;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface FunctionDao {
    /**
     * 按管理员ID查询其拥有的功能权限（关联powers中间表）
     */
    @Select("SELECT * FROM functions WHERE id IN (SELECT fid FROM powers WHERE aid = #{aid})")
    List<Functions> selectByAdminId(Integer aid);
}