package com.eshop.dao;

import com.eshop.pojo.ProductInfo;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

public interface ProductInfoDao {
    @Select("select * from product_info")
    List<ProductInfo> selectProductInfo();

    @Select("select * from product_info where id = #{id}")
    ProductInfo selectProductInfoById(@Param("id") int id);

    @Select("select * from product_info where name like CONCAT('%',#{keyword},'%') or brand like CONCAT('%',#{keyword},'%')")
    List<ProductInfo> searchProductInfo(@Param("keyword") String keyword);

    @Select("select * from product_info limit #{offset}, #{limit}")
    List<ProductInfo> selectProductInfoByPage(@Param("offset") int offset, @Param("limit") int limit);

    @Select("select count(*) from product_info")
    int countProductInfo();
}
