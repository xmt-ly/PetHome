# 萌宠之家 (PetHome)

A Chinese-language pet care and e-commerce web application built with Jakarta EE 11.

## 项目简介

萌宠之家是一个面向宠物主人的综合性电商平台，提供宠物商品在线购物与宠物服务预约一站式体验。系统涵盖 **8 大品类**（食品、出行、玩耍、居家、清洁、服饰、食具、智能）和 **3 大服务类别**（美容、寄养、医疗），包含完整的用户管理、商品浏览、购物车、订单交易和后台管理功能。

> 本项目为 Java Web 课程综合实践，采用传统 MVC 架构，无前端构建工具。

## 技术栈

| 层级 | 技术 |
|------|------|
| 运行容器 | Apache Tomcat 11 |
| 后端框架 | Jakarta EE 11 (Servlet 6.1, JSP 3.0) |
| 数据库 | MySQL 8.0 (`utf8mb4_unicode_ci`) |
| 数据访问 | 原生 JDBC（`mysql-connector-j-9.7.0`） |
| 前端样式 | Tailwind CSS 3.4（预编译）+ 自定义设计系统 |
| 字体 | Plus Jakarta Sans / Be Vietnam Pro / 思源黑体 |
| IDE | IntelliJ IDEA |
| Java | Java 17+ |

## 快速开始

### 环境要求

- JDK 17+
- Apache Tomcat 11
- MySQL 8.0
- （可选）Node.js 18+ — 用于重新编译 Tailwind CSS

### 1. 初始化数据库

```bash
mysql -u root -p < web/sql/init.sql
```

脚本会自动创建 `pethome` 数据库、6 张数据表，并插入初始数据（3 个用户、8 个分类、89 个商品、15 个服务）。

### 2. 部署到 Tomcat

#### 方式一：IntelliJ IDEA（推荐）

1. 打开 `PetHome.iml` 模块
2. 配置 Tomcat 11 运行环境
3. 运行即可

#### 方式二：手动部署

1. 编译 Java 源码：
   ```bash
   # 下载 Jakarta Servlet API（如本地没有）
   curl -o /tmp/jakarta.servlet-api-6.1.0.jar \
     https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.1.0/jakarta.servlet-api-6.1.0.jar

   # 编译
   javac -cp /tmp/jakarta.servlet-api-6.1.0.jar:web/WEB-INF/lib/mysql-connector-j-9.7.0.jar:web/src \
     -d web/WEB-INF/classes \
     web/src/com/pethome/**/*.java
   ```
2. 将 `web/` 目录整体复制到 Tomcat 的 `webapps/` 下，或作为独立 WAR 部署

### 3. 访问系统

- 首页：http://localhost:8080/PetHome/index.jsp
- 登录：http://localhost:8080/PetHome/jsp/login.jsp
- 商城：http://localhost:8080/PetHome/product
- 服务：http://localhost:8080/PetHome/service
- 后台：http://localhost:8080/PetHome/admin

### 测试账号

| 用户名 | 密码 | 角色 |
|--------|------|------|
| admin | admin123 | 管理员 (role=1) |
| testuser | 123456 | 普通用户 |
| xiaoming | 123456 | 普通用户 |

## 功能概览

### 前台功能

| 模块 | 功能点 |
|------|--------|
| 用户 | 注册（含验证码）、登录、退出、个人信息修改、密码修改 |
| 商品 | 分页浏览、分类筛选、关键词搜索、商品详情、同类推荐 |
| 服务 | 按美容/寄养/医疗分类浏览、服务详情、同类推荐 |
| 购物车 | 添加商品、修改数量、删除、清空（Session 存储） |
| 订单 | 创建订单（事务）、订单列表、订单详情、取消订单、状态更新 |

### 后台管理

| 模块 | 功能点 |
|------|--------|
| 仪表盘 | 商品/订单/用户统计概览 |
| 商品管理 | 新增（含图片上传）、编辑、删除 |
| 服务管理 | 新增、编辑、删除 |
| 订单管理 | 查看全部订单、更新订单状态 |
| 用户管理 | 查看用户列表、删除普通用户 |

## 系统架构

```
Browser
   │
   ▼
┌─────────────────────────────────┐
│  View (JSP + Tailwind CSS)      │  ← 响应式前端界面
│  ├── index.jsp                  │
│  ├── jsp/shop.jsp               │
│  ├── jsp/cart.jsp               │
│  ├── jsp/admin/*.jsp            │
│  └── jsp/common/*.jspf          │  ← 公共页面片段
└──────────────┬──────────────────┘
               │ request/forward
               ▼
┌─────────────────────────────────┐
│  Controller (Servlet)           │  ← 请求分发与参数处理
│  ├── UserServlet (/user)        │
│  ├── ProductServlet (/product)  │
│  ├── CartServlet (/cart)        │
│  ├── OrderServlet (/order)      │
│  ├── AdminServlet (/admin)      │
│  └── ImageServlet (/captcha)    │  ← 验证码生成
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  Filter (web.xml)               │  ← 横切关注点
│  ├── AuthFilter                 │  ← 登录鉴权 + 管理员角色校验
│  └── EncodingFilter             │  ← UTF-8 编码
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  Model + DAO                    │  ← 业务数据 + 数据访问
│  ├── model/*.java (7 个 JavaBean)│
│  ├── BaseDao (泛型 JDBC 模板)    │
│  ├── UserDao / ProductDao ...   │
│  └── util/DBUtil                │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  MySQL 8.0                      │  ← 6 张数据表
│  pethome.*                     │
└─────────────────────────────────┘
```

### 包结构

```
web/src/com/pethome/
├── filter/
│   ├── AuthFilter.java          — 登录验证 + 管理员权限
│   └── EncodingFilter.java      — UTF-8 编码
├── model/
│   ├── User.java                — 用户
│   ├── Category.java            — 商品分类
│   ├── Product.java             — 商品
│   ├── Service.java             — 服务
│   ├── Order.java               — 订单（含明细列表）
│   ├── OrderItem.java           — 订单明细
│   └── CartItem.java            — 购物车项（Session，无 DB 表）
├── dao/
│   ├── BaseDao.java             — 泛型 JDBC 基类
│   ├── CategoryDao.java
│   ├── UserDao.java
│   ├── ProductDao.java
│   ├── ServiceDao.java
│   └── OrderDao.java            — 含事务 createOrder()
├── servlet/
│   ├── UserServlet.java
│   ├── ProductServlet.java
│   ├── ServiceServlet.java
│   ├── CartServlet.java
│   ├── OrderServlet.java
│   ├── AdminServlet.java        — 后台 CRUD + 图片上传
│   └── ImageServlet.java        — 验证码生成
└── util/
    └── DBUtil.java              — JDBC 连接工具
```

## 数据库

### 数据表

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `t_user` | 用户表 | username, password, role(0/1) |
| `t_category` | 商品分类 | name, icon(emoji), subcategories |
| `t_product` | 商品表 | name, price, stock, category_id, status, tag |
| `t_service` | 服务表 | name, price, category(grooming/boarding/clinic) |
| `t_order` | 订单表 | order_no, user_id, total_amount, status |
| `t_order_item` | 订单明细 | order_id, product_id, quantity |

### 订单状态

| 值 | 含义 |
|----|------|
| 0 | 待付款 |
| 1 | 已付款 |
| 2 | 已发货 |
| 3 | 已完成 |
| 4 | 已取消 |

## 关键设计

- **BaseDao 泛型模板** — 封装 `queryForList`、`queryForObject`、`update`、`count`，子类仅需实现 `resultSetToModel`
- **JDBC 事务** — 订单创建时原子性地执行"插入订单 → 插入明细 → 扣减库存"，任一失败回滚
- **AuthFilter 权限控制** — 拦截受保护资源，未登录用户保存原始 URL 登录后跳回，管理员路径校验 `role=1`
- **Session 购物车** — 购物车数据存储在 HttpSession 中，无需数据库表
- **图片上传** — AdminServlet 使用 `@MultipartConfig` + `HttpServletRequest.getPart()`，UUID 生成唯一文件名
- **验证码** — Java2D 绘制 4 位随机字符，一次性校验后清除

## 注意事项

- 密码以明文存储（教学项目，生产环境应使用 bcrypt/Argon2）
- DB 连接信息硬编码在 `DBUtil.java`（生产环境应使用环境变量或配置文件）
- 无连接池，每次请求新建 JDBC 连接（生产环境建议使用 HikariCP）
- Tailwind CSS 已预编译为 `web/static/css/tailwind/tailwind.min.css`，如需修改样式需安装 Node.js 依赖后重新编译

## License

MIT
