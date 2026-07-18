package com.ecpbm.service.impl;

import com.ecpbm.dao.AdminInfoDao;
import com.ecpbm.pojo.AdminInfo;
import com.ecpbm.service.AdminInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service("adminInfoService")  // 服务Bean名称，用于Controller注入
@Transactional(
        propagation = Propagation.REQUIRED,  // 事务传播机制：默认需要事务
        isolation = Isolation.DEFAULT        // 事务隔离级别：默认（跟随数据库）
)
public class AdminInfoServiceImpl implements AdminInfoService {

    @Autowired  // 自动注入AdminInfoDao
    private AdminInfoDao adminInfoDao;

    @Override
    public AdminInfo login(AdminInfo ai) {
        // 调用Dao层方法验证用户名和密码
        return adminInfoDao.selectByNameAndPwd(ai);
    }

    @Override
    public AdminInfo getAdminInfoAndFunctions(Integer id) {
        // 调用Dao层方法查询管理员及关联功能
        return adminInfoDao.selectById(id);
    }
}