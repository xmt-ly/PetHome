# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

萌宠之家 (Cute Pet Home) — A Chinese-language pet care and e-commerce web application built with Jakarta EE 11 (Tomcat + MySQL 8.0).

## Web Application (`web/`) — Architecture

### Tech Stack

| Layer | Technology |
|-------|-----------|
| Runtime | Jakarta EE 11 (Servlet 6.1), Tomcat 11 |
| Database | MySQL 8.0 (`utf8mb4_unicode_ci`) |
| JDBC | Raw JDBC (mysql-connector-j-9.7.0), no connection pool |
| Frontend | JSP 3.0, Tailwind CSS CDN, vanilla JS |
| IDE | IntelliJ IDEA (module: PetHome.iml) |
| Java | Java 17+ (`LocalDateTime`, `record`-eligible model classes) |

### Package Structure (`web/src/com/pethome/`)

```
com.pethome
├── filter/
│   ├── AuthFilter.java          — Login + admin role guard (web.xml mapped)
│   └── EncodingFilter.java      — UTF-8 request/response encoding
├── model/
│   ├── User.java                 — t_user table
│   ├── Category.java             — t_category table (icon + subcategories)
│   ├── Product.java              — t_product table
│   ├── Service.java              — t_service table
│   ├── Order.java                — t_order table (has items list, statusText)
│   ├── OrderItem.java            — t_order_item table
│   └── CartItem.java             — In-memory (session) cart item, no DB table
├── dao/
│   ├── BaseDao.java              — Abstract generic DAO: update/queryForList/queryForObject/count
│   ├── CategoryDao.java          — Category findAll/findById
│   ├── UserDao.java              — User CRUD + login/findByUsername/password update
│   ├── ProductDao.java           — Product CRUD + pagination/search/decreaseStock
│   ├── ServiceDao.java           — Service CRUD + findByCategory
│   └── OrderDao.java             — Order CRUD + transaction createOrder/findItemsByOrderId
├── servlet/
│   ├── UserServlet.java          — /user (login/register/logout/update/updatePassword)
│   ├── ProductServlet.java       — /product (list/detail/search/category)
│   ├── ServiceServlet.java       — /service (grouped by category)
│   ├── CartServlet.java          — /cart (add/remove/update/clear, session-based)
│   ├── OrderServlet.java         — /order (create/list/detail/cancel/updateStatus)
│   └── AdminServlet.java         — /admin (full CRUD for product/service/order/user)
└── util/
    └── DBUtil.java               — JDBC connection helper, static driver load
```

### Database Schema (MySQL 8.0, `pethome` database)

6 tables: `t_user` → `t_category` → `t_product` → `t_service` → `t_order` → `t_order_item`

Key relationships:
- `t_product.category_id` → `t_category.id`
- `t_order.user_id` → `t_user.id`
- `t_order_item.order_id` → `t_order.id`, `t_order_item.product_id` → `t_product.id`
- `t_category` has `icon` (emoji) and `subcategories` (子类目描述) columns for the 8-category system
- Initial data in `web/sql/init.sql`: admin/testuser/xiaoming users, 8 categories (🍖食品 🎒出行 🎾玩耍 🛋️居家 🧹清洁 👗服饰 🥣食具 🤖智能), 11 products, 7 services

### Servlet URL Map

| URL Pattern | Servlet | Actions |
|-------------|---------|---------|
| `/user` | UserServlet | login, register, logout, update, updatePassword |
| `/product` | ProductServlet | list, detail, search, category |
| `/service` | ServiceServlet | (grouped by grooming/boarding/clinic) |
| `/cart` | CartServlet | list, add, remove, update, clear |
| `/order` | OrderServlet | create, list, detail, cancel, updateStatus |
| `/admin` | AdminServlet | modules: product, service, order, user |

### Request Flow

```
Browser → Servlet (/user?action=login) → Servlet handles param/validation
         → DAO (UserDao.login) → BaseDao (JDBC query) → MySQL
         → JSP forward (login error) or redirect (login success)
```

All `doPost` delegates to `doGet` or vice versa. Admin routes are guarded by `AuthFilter` (web.xml mapped) and `AdminServlet` double-checks role.

### JSP Structure

```
web/
├── index.jsp                         — Homepage
├── jsp/
│   ├── login.jsp, register.jsp       — Auth
│   ├── services.jsp, shop.jsp        — Browse
│   ├── cart.jsp, checkout.jsp        — Shopping
│   ├── order-list.jsp, order-detail.jsp  — Orders
│   ├── user-profile.jsp              — Profile
│   ├── about.jsp                     — About
│   ├── product-detail.jsp            — Product detail
│   ├── common/
│   │   ├── head.jspf                 — Prelude (Tailwind config, fonts, CSS)
│   │   ├── common-scripts.jspf       — Coda (scroll effects, IntersectionObserver)
│   │   ├── header.jspf               — Nav bar with user dropdown
│   │   └── footer.jspf               — Footer with links
│   ├── admin/
│   │   ├── dashboard.jsp             — Stats overview
│   │   ├── product-manage.jsp        — Product CRUD table
│   │   ├── service-manage.jsp        — Service CRUD table
│   │   ├── order-manage.jsp          — Order management
│   │   └── user-manage.jsp           — User management
│   └── error/
│       ├── 404.jsp, 500.jsp          — Error pages
└── static/css/pethome.css            — Global stylesheet
```

### Key Configuration Files

- **`web/WEB-INF/web.xml`** — EncodingFilter (Tomcat's built-in), AuthFilter mapping, JSP prelude/coda (head.jspf + common-scripts.jspf), error pages, session timeout (30min)
- **`web/WEB-INF/lib/`** — Runtime JARs: `mysql-connector-j-9.7.0.jar`
- **`PetHome.iml`** — IntelliJ module: source root `web/src`, output to `web/WEB-INF/classes`, libs: tomcat11-servlet-api, mysql-connector-j-9.7.0
- **`web/sql/init.sql`** — Full schema + seed data

### Database Connection

`DBUtil.java` connects to `localhost:3306/pethome` with hardcoded credentials (root/980139XMT) — no connection pool. Uses static `Class.forName` driver registration.

### Security Notes

- **Passwords stored in plaintext** — `init.sql` inserts raw passwords, `UserDao.login` compares `WHERE username = ? AND password = ?`, no hashing
- **DB credentials hardcoded** — `DBUtil.java` has plaintext MySQL password
- **AuthFilter** guards protected pages (cart, checkout, orders, profile, admin) and requires role=1 for `/admin/*`

### Build & Deploy

No build tool (no Maven/Gradle). Standard Tomcat deployment:
1. Compile Java sources to `web/WEB-INF/classes/`
2. Deploy entire `web/` directory as a Tomcat webapp (or deploy the project in IntelliJ with Tomcat 11 run config)
3. Run `web/sql/init.sql` against MySQL to initialize database

## Shared Conventions (Both Subsystems)

- **Encoding**: UTF-8 everywhere (JSP page directives, Servlet request/response, Filter, MySQL charset)
- **Design language**: Material Design 3 inspired (warm orange primary #FF8C42, teal secondary #43AA8B)
- **Typography**: Plus Jakarta Sans (headings) + Be Vietnam Pro (body), paired with PingFang SC / Noto Sans SC for Chinese
- **Tailwind config** is identical across all HTML/JSP files — keep in sync when modifying
