package com.eshop.dao;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.Map;

public interface AdminInfoDao {
    @Select("SELECT id, name as userName, pwd, 'admin' as role FROM admin_info WHERE name = #{name}")
    Map<String, Object> selectByLogin(@Param("name") String name, @Param("pwd") String pwd);
}
