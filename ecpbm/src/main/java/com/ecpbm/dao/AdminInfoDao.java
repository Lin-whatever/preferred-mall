package com.ecpbm.dao;

import com.ecpbm.pojo.AdminInfo;
import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.mapping.FetchType;

public interface AdminInfoDao {
    /**
     * 按用户名和密码查询管理员（登录验证）
     */
    @Select("SELECT * FROM admin_info WHERE name = #{name} AND pwd = #{pwd}")
    AdminInfo selectByNameAndPwd(AdminInfo ai);

    /**
     * 按ID查询管理员，并关联查询其功能权限
     */
    @Select("SELECT * FROM admin_info WHERE id = #{id}")
    @Results({
            @Result(id = true, column = "id", property = "id"),
            @Result(column = "name", property = "name"),
            @Result(column = "pwd", property = "pwd"),
            // 关联查询功能权限（多对多，通过FunctionDao查询）
            @Result(
                    column = "id",
                    property = "fs",
                    many = @Many(
                            select = "com.ecpbm.dao.FunctionDao.selectByAdminId",
                            fetchType = FetchType.EAGER  // 立即加载
                    )
            )
    })
    AdminInfo selectById(Integer id);
}