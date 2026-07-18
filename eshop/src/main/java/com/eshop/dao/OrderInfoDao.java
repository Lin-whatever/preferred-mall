package com.eshop.dao;

import com.eshop.pojo.OrderInfo;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface OrderInfoDao {
    @Insert("INSERT INTO order_info(uid, status, ordertime, orderprice) VALUES(#{uid}, #{status}, #{ordertime}, #{orderprice})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertOrder(OrderInfo oi);

    @Insert("INSERT INTO order_detail(oid, pid, num) VALUES(#{oid}, #{pid}, #{num})")
    void insertOrderDetail(@Param("oid") int oid, @Param("pid") int pid, @Param("num") int num);

    @Select("SELECT * FROM order_info WHERE uid = #{uid} ORDER BY id DESC")
    List<OrderInfo> selectByUid(@Param("uid") int uid);

    @Select("SELECT * FROM order_info WHERE id = #{id}")
    OrderInfo selectById(@Param("id") int id);

    @Update("UPDATE order_info SET status = #{status} WHERE id = #{id}")
    void updateStatus(@Param("id") int id, @Param("status") String status);
}
