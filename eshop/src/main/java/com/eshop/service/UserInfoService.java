package com.eshop.service;

import com.eshop.pojo.UserInfo;

public interface UserInfoService {
    UserInfo login(String userName, String password);
    UserInfo register(UserInfo user);
    UserInfo getUserById(int id);
    void updatePassword(int id, String newPwd);
}
