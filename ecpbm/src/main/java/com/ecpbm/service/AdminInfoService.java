package com.ecpbm.service;

import com.ecpbm.pojo.AdminInfo;

public interface AdminInfoService {
    /**
     * 管理员登录验证
     * @param ai 包含用户名和密码的AdminInfo对象
     * @return 验证通过返回完整AdminInfo，否则返回null
     */
    AdminInfo login(AdminInfo ai);

    /**
     * 按ID查询管理员及其关联的功能权限
     * @param id 管理员ID
     * @return 包含功能权限的AdminInfo对象
     */
    AdminInfo getAdminInfoAndFunctions(Integer id);
}