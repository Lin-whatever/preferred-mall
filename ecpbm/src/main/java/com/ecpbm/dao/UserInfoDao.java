package com.ecpbm.dao;

import com.ecpbm.pojo.UserInfo;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.annotations.Update;

import java.util.List;
import java.util.Map;

public interface UserInfoDao {
    // 获取合法用户（status=1）
    @Select("select * from user_info where status=1")
    List<UserInfo> getValidUser();

    // 根据ID查询用户
    @Select("select * from user_info where id=#{id}")
    UserInfo getUserInfoById(int id);

    // 分页查询用户
    @SelectProvider(type = com.ecpbm.dao.provider.UserInfoDynaSqlProvider.class, method = "selectWithParam")
    List<UserInfo> selectByPage(Map<String, Object> params);

    // 统计用户总数
    @SelectProvider(type = com.ecpbm.dao.provider.UserInfoDynaSqlProvider.class, method = "count")
    Integer count(Map<String, Object> params);

    // 更新用户状态
    @Update("update user_info set status=#{flag} where id in (${ids})")
    void updateState(@Param("ids") String ids, @Param("flag") int flag);
}