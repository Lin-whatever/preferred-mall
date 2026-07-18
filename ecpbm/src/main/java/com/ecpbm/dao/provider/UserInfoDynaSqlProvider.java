package com.ecpbm.dao.provider;

import com.ecpbm.pojo.UserInfo;
import org.apache.ibatis.jdbc.SQL;

import java.util.Map;

public class UserInfoDynaSqlProvider {
    // 分页查询SQL
    public String selectWithParam(Map<String, Object> params) {
        return new SQL() {{
            SELECT("*");
            FROM("user_info");
            if (params.get("userInfo") != null) {
                UserInfo userInfo = (UserInfo) params.get("userInfo");
                if (userInfo.getUserName() != null && !"".equals(userInfo.getUserName())) {
                    WHERE("userName LIKE CONCAT('%',#{userInfo.userName},'%')");
                }
            }
        }}.toString() + (params.get("pager") != null ? " limit #{pager.firstLimitParam}, #{pager.perPageRows}" : "");
    }

    // 统计SQL
    public String count(Map<String, Object> params) {
        return new SQL() {{
            SELECT("count(*)");
            FROM("user_info");
            if (params.get("userInfo") != null) {
                UserInfo userInfo = (UserInfo) params.get("userInfo");
                if (userInfo.getUserName() != null && !"".equals(userInfo.getUserName())) {
                    WHERE("userName LIKE CONCAT('%',#{userInfo.userName},'%')");
                }
            }
        }}.toString();
    }
}