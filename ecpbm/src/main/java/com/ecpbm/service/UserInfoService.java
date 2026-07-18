package com.ecpbm.service;

import com.ecpbm.pojo.UserInfo;
import com.ecpbm.pojo.Pager;

import java.util.List;
import java.util.Map;

public interface UserInfoService {
    List<UserInfo> getValidUser();
    UserInfo getUserInfoById(int id);
    List<UserInfo> findUserInfo(UserInfo userInfo, Pager pager);
    Integer count(Map<String, Object> params);
    void modifyStatus(String ids, int flag);
}