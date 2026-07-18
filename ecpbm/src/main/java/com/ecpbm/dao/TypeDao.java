package com.ecpbm.dao;

import com.ecpbm.pojo.Type;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import java.util.List;

public interface TypeDao {
    // 查询所有商品类型
    @Select("select * from type")
    List<Type> selectAll();

    // 根据ID查询类型
    @Select("select * from type where id = #{id}")
    Type selectById(int id);

    // 添加商品类型
    @Insert("insert into type(name) values(#{name})")
    @SelectKey(keyProperty = "id", before = false, resultType = Integer.class, statement = "select last_insert_id() as id")
    int addType(Type type);

    // 修改商品类型
    @Update("update type set name = #{name} where id = #{id}")
    int update(Type type);
}