package com.eshop.dao;

import com.eshop.pojo.UserInfo;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

public interface UserInfoDao {
    @Select("SELECT * FROM user_info WHERE userName = #{userName}")
    UserInfo selectByLogin(@Param("userName") String userName, @Param("password") String password);

    @Select("SELECT * FROM user_info WHERE id = #{id}")
    UserInfo selectById(@Param("id") int id);

    @Select("SELECT * FROM user_info WHERE userName = #{userName}")
    UserInfo selectByUserName(@Param("userName") String userName);

    @Insert("INSERT INTO user_info(userName, password, realName, sex, email, regDate, status) VALUES(#{userName}, #{password}, #{realName}, #{sex}, #{email}, NOW(), 1)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(UserInfo user);

    @Update("UPDATE user_info SET password = #{newPwd} WHERE id = #{id}")
    void updatePassword(@Param("id") int id, @Param("newPwd") String newPwd);
}
