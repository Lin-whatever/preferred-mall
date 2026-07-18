package com.ecpbm.dao;

import com.ecpbm.pojo.ProductInfo;
import org.apache.ibatis.annotations.*;
import org.apache.ibatis.mapping.FetchType;

import java.util.List;
import java.util.Map;

public interface ProductInfoDao {
    // 分页获取商品
    @SelectProvider(type = com.ecpbm.dao.provider.ProductInfoDynaSqlProvider.class, method = "selectWithParam")
    @Results({
            @Result(id = true, column = "id", property = "id"),
            @Result(column = "tid", property = "type", one = @One(select = "com.ecpbm.dao.TypeDao.selectById", fetchType = FetchType.EAGER))
    })
    List<ProductInfo> selectByPage(Map<String, Object> params);

    // 统计商品总数
    @SelectProvider(type = com.ecpbm.dao.provider.ProductInfoDynaSqlProvider.class, method = "count")
    Integer count(Map<String, Object> params);

    // 添加商品
    @Insert("insert into product_info(code,name,tid,brand,pic,num,price,intro,status) " +
            "values(#{code},#{name},#{type.id},#{brand},#{pic},#{num},#{price},#{intro},#{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void save(ProductInfo pi);

    // 修改商品
    @Update("update product_info set code=#{code},name=#{name},tid=#{type.id}," +
            "brand=#{brand},pic=#{pic},num=#{num},price=#{price},intro=#{intro},status=#{status} where id=#{id}")
    void edit(ProductInfo pi);

    // 更新商品状态（下架/上架）
    @Update("update product_info set status=#{flag} where id in (${ids})")
    void updateState(@Param("ids") String ids, @Param("flag") int flag);

    // 根据ID查询商品（用于订单明细）
    @Select("select * from product_info where id=#{id}")
    ProductInfo getProductInfoById(int id);

    // 获取在售商品（用于创建订单）
    @Select("select * from product_info where status=1")
    List<ProductInfo> getOnSaleProduct();
}