package com.ecpbm.dao;

import com.ecpbm.dao.provider.OrderInfoDynaSqlProvider;
import com.ecpbm.pojo.OrderDetail;
import com.ecpbm.pojo.OrderInfo;
import org.apache.ibatis.annotations.*;
import org.apache.ibatis.mapping.FetchType;

import java.util.List;
import java.util.Map;

public interface OrderInfoDao {
    // 原有方法（不变）
    @Results({
            @Result(id = true, property = "id", column = "id"),
            @Result(column = "uid", property = "ui", one = @One(select = "com.ecpbm.dao.UserInfoDao.getUserInfoById", fetchType = FetchType.EAGER))
    })
    @SelectProvider(type = OrderInfoDynaSqlProvider.class, method = "selectWithParam")
    List<OrderInfo> selectByPage(Map<String, Object> params);

    @SelectProvider(type = OrderInfoDynaSqlProvider.class, method = "count")
    Integer count(Map<String, Object> params);

    @Select("select * from order_info where id = #{id}")
    @Results({
            @Result(column = "uid", property = "ui", one = @One(select = "com.ecpbm.dao.UserInfoDao.getUserInfoById", fetchType = FetchType.EAGER))
    })
    OrderInfo getOrderInfoById(int id);

    @Select("select * from order_detail where oid = #{oid}")
    @Results({
            @Result(column = "pid", property = "pi", one = @One(select = "com.ecpbm.dao.ProductInfoDao.getProductInfoById", fetchType = FetchType.EAGER))
    })
    List<OrderDetail> getOrderDetailByOid(int oid);

    // 新增：删除订单主表
    @Delete("delete from order_info where id = #{oid}")
    void deleteOrderById(int oid);

    // 新增：删除订单明细（通过订单ID）
    @Delete("delete from order_detail where oid = #{oid}")
    void deleteOrderDetailByOid(int oid);

    // 新增：保存订单主表
    @Insert("insert into order_info(uid, status, ordertime, orderprice) " +
            "values(#{uid}, #{status}, #{ordertime}, #{orderprice})")
    @Options(useGeneratedKeys = true, keyProperty = "id") // 自动生成主键并回写id字段
    void insertOrderInfo(OrderInfo orderInfo);

    // 新增：保存订单明细
    @Insert("insert into order_detail(oid, pid, num) " +
            "values(#{oid}, #{pid}, #{num})")
    void insertOrderDetail(OrderDetail orderDetail);
}