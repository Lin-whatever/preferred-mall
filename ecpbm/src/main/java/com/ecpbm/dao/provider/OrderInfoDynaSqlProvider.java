package com.ecpbm.dao.provider;

import java.util.Map;
import org.apache.ibatis.jdbc.SQL;
import com.ecpbm.pojo.OrderInfo;

public class OrderInfoDynaSqlProvider {
    // 分页动态查询
    public String selectWithParam(Map<String, Object> params) {
        return new SQL() {{
            SELECT("*");
            FROM("order_info");
            if (params.get("orderInfo") != null) {
                OrderInfo orderInfo = (OrderInfo) params.get("orderInfo");
                if (orderInfo.getId() != null && orderInfo.getId() > 0) {
                    WHERE(" id = #{orderInfo.id} ");
                } else {
                    // 修复语法错误：orderInfo.getOrderTimeFrom() 补充括号
                    if (orderInfo.getStatus() != null && !"请选择".equals(orderInfo.getStatus())) {
                        WHERE(" status = #{orderInfo.status} ");
                    }
                    if (orderInfo.getOrderTimeFrom() != null && !"".equals(orderInfo.getOrderTimeFrom())) {
                        WHERE(" ordertime >= #{orderInfo.orderTimeFrom} ");
                    }
                    if (orderInfo.getOrderTimeTo() != null && !"".equals(orderInfo.getOrderTimeTo())) {
                        WHERE(" ordertime < #{orderInfo.orderTimeTo} ");
                    }
                    if (orderInfo.getUid() > 0) {
                        WHERE(" uid = #{orderInfo.uid} ");
                    }
                }
            }
        }}.toString() + (params.get("pager") != null ? " limit #{pager.firstLimitParam} , #{pager.perPageRows} " : "");
    }

    // 统计订单总数
    public String count(Map<String, Object> params) {
        return new SQL() {{
            SELECT("count(*)");
            FROM("order_info");
            if (params.get("orderInfo") != null) {
                OrderInfo orderInfo = (OrderInfo) params.get("orderInfo");
                if (orderInfo.getId() != null && orderInfo.getId() > 0) {
                    WHERE(" id = #{orderInfo.id} ");
                } else {
                    if (orderInfo.getStatus() != null && !"请选择".equals(orderInfo.getStatus())) {
                        WHERE(" status = #{orderInfo.status} ");
                    }
                    if (orderInfo.getOrderTimeFrom() != null && !"".equals(orderInfo.getOrderTimeFrom())) {
                        WHERE(" ordertime >= #{orderInfo.orderTimeFrom} ");
                    }
                    if (orderInfo.getOrderTimeTo() != null && !"".equals(orderInfo.getOrderTimeTo())) {
                        WHERE(" ordertime < #{orderInfo.orderTimeTo} ");
                    }
                    if (orderInfo.getUid() > 0) {
                        WHERE(" uid = #{orderInfo.uid} ");
                    }
                }
            }
        }}.toString();
    }
}