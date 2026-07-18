package com.eshop.service.impl;

import com.eshop.dao.UserInfoDao;
import com.eshop.pojo.UserInfo;
import com.eshop.service.UserInfoService;
import com.eshop.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("userInfoService")
public class UserInfoServiceImpl implements UserInfoService {

    @Autowired
    private UserInfoDao userInfoDao;

    @Override
    public UserInfo login(String userName, String password) {
        UserInfo user = userInfoDao.selectByLogin(userName, password);
        if (user != null && PasswordUtil.matches(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    @Override
    public UserInfo register(UserInfo user) {
        UserInfo exist = userInfoDao.selectByUserName(user.getUserName());
        if (exist != null) return null;
        userInfoDao.insert(user);
        return user;
    }

    @Override
    public void updatePassword(int id, String newPwd) {
        userInfoDao.updatePassword(id, newPwd);
    }

    @Override
    public UserInfo getUserById(int id) {
        return userInfoDao.selectById(id);
    }
}
