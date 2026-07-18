# 优选商城 (Preferred Mall)

Spring Boot + Vue 2 全栈电商平台，从零搭建的完整在线购物系统。

## 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | Vue 2 + Vuex + Vue Router + Axios |
| 后端 | Spring Boot 2.7 + MyBatis + Spring MVC |
| 数据库 | MySQL 8.0 |
| 安全 | JWT 鉴权 + BCrypt 密码加密 |
| 构建 | Maven + Vue CLI |

## 功能

### 商城前台
- 商品浏览 —— 首页推荐 + 分类筛选 + 列表分页 + 模糊搜索
- 用户系统 —— 注册 / 登录 / JWT Token / 管理员登录
- 购物车 —— 未登录 localStorage / 已登录数据库双写
- 订单流程 —— 确认订单 → 支付 → 收货 → 完成（支持取消）
- 商品评价 —— 五星打分 + 文字评论 + 匿名评价
- 收藏功能 —— 商品收藏 / 取消 + 收藏列表
- 个人中心 —— 收货地址管理 + 修改密码 + 我的订单

### 后台管理
- 商品管理 —— 商品列表 + 商品类型 + 图片上传
- 订单管理 —— 查询订单 + 创建订单
- 用户管理 —— 用户列表
- 权限控制 —— 菜单树 + 角色权限

### 管理员工具
- 图片管理 —— 一键上传 PNG/JPG，自动更新商品图片

## 项目结构

```
webweb/
├── eshop/              Spring Boot 商城后端
│   ├── src/main/java/com/eshop/
│   │   ├── controller/ 控制器（Product/User/Order/Cart/Favorite/Review）
│   │   ├── dao/         MyBatis DAO 接口
│   │   ├── pojo/        实体类
│   │   ├── service/     业务逻辑
│   │   ├── util/        JWT / BCrypt 工具
│   │   └── config/      Spring 配置
│   └── src/main/resources/
│       └── application.properties.template  配置模板
├── shopping/           Vue 2 前端源码
│   ├── src/views/      页面组件
│   ├── src/components/ 通用组件
│   ├── src/router/     路由
│   └── src/store/       Vuex 状态管理
├── ecpbm/              后台管理系统（Spring MVC + JSP）
│   └── web/             JSP 页面
└── plan.md             开发计划
```

## 快速启动

### 前置要求
- JDK 17+
- MySQL 8.0
- Maven 3.6+
- Node.js 16+

### 1. 数据库

```sql
CREATE DATABASE eshop DEFAULT CHARACTER SET utf8mb4;
-- 导入项目中的 SQL 文件（如有）
```

### 2. 配置

复制 `eshop/src/main/resources/application.properties.template` 为 `application.properties`，填入你的 MySQL 密码：

```properties
spring.datasource.password=你的密码
```

### 3. 启动

```bash
# 商城后端（内嵌前端）
cd eshop
mvn clean package -DskipTests
java -jar target/eshop-1.0.0.jar

# 后台管理（可选）
# 配置 Tomcat 9 部署 ecpbm，端口 8081
```

### 4. 访问

| 页面 | 地址 |
|------|------|
| 商城首页 | http://localhost:8080/eshop/ |
| 用户登录 | http://localhost:8080/eshop/login |
| 后台管理 | http://localhost:8081/ecpbm/admin_login.jsp |
| 图片管理 | http://localhost:8080/eshop/admin |

### 测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 普通用户 | john | 123456 |
| 管理员 | admin | 123456 |

## 前端开发

```bash
cd shopping
npm install
npm run serve    # 开发模式（端口 8088）
npm run build    # 生产构建
```

## License

仅供学习交流使用。
