package com.ecpbm.dao.provider;

import com.ecpbm.pojo.ProductInfo;
import com.ecpbm.pojo.Pager;
import org.apache.ibatis.jdbc.SQL;
import java.util.Map;

/**
 * 商品表动态SQL生成器
 */
public class ProductInfoDynaSqlProvider {

    // 分页查询商品
    // 分页查询商品（动态SQL，适配MyBatis 3.5.9）
    public String selectWithParam(Map<String, Object> params) {
        ProductInfo productInfo = (ProductInfo) params.get("productInfo");
        // 先构建基础SQL
        SQL sql = new SQL() {{
            SELECT("*");
            FROM("product_info");
            // 条件过滤（这部分不变，保留原来的）
            if (productInfo != null) {
                if (productInfo.getCode() != null && !productInfo.getCode().isEmpty()) {
                    WHERE("code = #{productInfo.code}");
                }
                if (productInfo.getName() != null && !productInfo.getName().isEmpty()) {
                    WHERE("name like concat('%', #{productInfo.name}, '%')");
                }
                if (productInfo.getBrand() != null && !productInfo.getBrand().isEmpty()) {
                    WHERE("brand like concat('%', #{productInfo.brand}, '%')");
                }
                if (productInfo.getType() != null && productInfo.getType().getId() > 0) {
                    WHERE("tid = #{productInfo.type.id}");
                }
                if (productInfo.getPriceFrom() > 0) {
                    WHERE("price > #{productInfo.priceFrom}");
                }
                if (productInfo.getPriceTo() > 0) {
                    WHERE("price <= #{productInfo.priceTo}");
                }
                // 只查询在售商品（状态1）
                WHERE("status = 1");
            }
        }};

        // 分页参数：直接拼接limit（MyBatis 3.5.9支持这种方式）
        if (params.get("pager") != null) {
            Pager pager = (Pager) params.get("pager");
            String limit = String.format(" limit %d, %d",
                    pager.getFirstLimitParam(), pager.getPerPageRows());
            // 把limit拼接到基础SQL后面
            return sql.toString() + limit;
        }

        // 没有分页参数时，直接返回基础SQL
        return sql.toString();
    }

    // 统计商品总数
    public String count(Map<String, Object> params) {
        ProductInfo productInfo = (ProductInfo) params.get("productInfo");
        return new SQL() {{
            SELECT("count(*)");
            FROM("product_info");
            if (productInfo != null) {
                // 同查询条件（复用过滤逻辑）
                if (productInfo.getCode() != null && !"".equals(productInfo.getCode())) {
                    WHERE("code = #{productInfo.code}");
                }
                if (productInfo.getName() != null && !"".equals(productInfo.getName())) {
                    WHERE("name like concat('%', #{productInfo.name}, '%')");
                }
                if (productInfo.getBrand() != null && !"".equals(productInfo.getBrand())) {
                    WHERE("brand like concat('%', #{productInfo.brand}, '%')");
                }
                if (productInfo.getType() != null && productInfo.getType().getId() > 0) {
                    WHERE("tid = #{productInfo.type.id}");
                }
                if (productInfo.getPriceFrom() > 0) {
                    WHERE("price > #{productInfo.priceFrom}");
                }
                if (productInfo.getPriceTo() > 0) {
                    WHERE("price <= #{productInfo.priceTo}");
                }
                WHERE("status = 1");
            }
        }}.toString();
    }

    // 添加商品
    public String insert(ProductInfo productInfo) {
        return new SQL() {{
            INSERT_INTO("product_info");
            if (productInfo.getCode() != null) {
                VALUES("code", "#{code}");
            }
            if (productInfo.getName() != null) {
                VALUES("name", "#{name}");
            }
            if (productInfo.getType() != null && productInfo.getType().getId() > 0) {
                VALUES("tid", "#{type.id}");
            }
            if (productInfo.getBrand() != null) {
                VALUES("brand", "#{brand}");
            }
            if (productInfo.getPic() != null) {
                VALUES("pic", "#{pic}");
            }
            if (productInfo.getNum() > 0) {
                VALUES("num", "#{num}");
            }
            if (productInfo.getPrice() > 0) {
                VALUES("price", "#{price}");
            }
            if (productInfo.getIntro() != null) {
                VALUES("intro", "#{intro}");
            }
            // 默认状态：在售（1）
            VALUES("status", "1");
        }}.toString();
    }

    // 修改商品
    public String update(ProductInfo productInfo) {
        return new SQL() {{
            UPDATE("product_info");
            if (productInfo.getCode() != null) {
                SET("code = #{code}");
            }
            if (productInfo.getName() != null) {
                SET("name = #{name}");
            }
            if (productInfo.getType() != null && productInfo.getType().getId() > 0) {
                SET("tid = #{type.id}");
            }
            if (productInfo.getBrand() != null) {
                SET("brand = #{brand}");
            }
            if (productInfo.getPic() != null) {
                SET("pic = #{pic}");
            }
            if (productInfo.getNum() > 0) {
                SET("num = #{num}");
            }
            if (productInfo.getPrice() > 0) {
                SET("price = #{price}");
            }
            if (productInfo.getIntro() != null) {
                SET("intro = #{intro}");
            }
            if (productInfo.getStatus() >= 0) {
                SET("status = #{status}");
            }
            // 条件：商品ID
            WHERE("id = #{id}");
        }}.toString();
    }
}