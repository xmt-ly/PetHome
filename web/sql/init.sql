-- ============================================================
-- 萌宠之家 (PetHome) 数据库初始化脚本
-- MySQL 8.0 + utf8mb4
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS pethome
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE pethome;

-- ============================================================
-- 1. 用户表
-- ============================================================
DROP TABLE IF EXISTS t_order_item;
DROP TABLE IF EXISTS t_order;
DROP TABLE IF EXISTS t_service;
DROP TABLE IF EXISTS t_product;
DROP TABLE IF EXISTS t_category;
DROP TABLE IF EXISTS t_user;

CREATE TABLE t_user (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(100) NOT NULL,
    nickname    VARCHAR(50)  DEFAULT '',
    email       VARCHAR(100) DEFAULT '',
    phone       VARCHAR(20)  DEFAULT '',
    avatar      VARCHAR(255) DEFAULT '',
    role        TINYINT      DEFAULT 0 COMMENT '0=普通用户, 1=管理员',
    created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2. 商品分类表
-- ============================================================
CREATE TABLE t_category (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(50) NOT NULL,
    icon            VARCHAR(20)  DEFAULT '' COMMENT 'emoji 图标',
    subcategories   VARCHAR(200) DEFAULT '' COMMENT '子类目描述',
    sort_order      INT          DEFAULT 0,
    created_at      DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3. 商品表
-- ============================================================
CREATE TABLE t_product (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(200) NOT NULL,
    description     TEXT,
    price           DECIMAL(10,2) NOT NULL,
    original_price  DECIMAL(10,2) DEFAULT NULL,
    image_url       VARCHAR(500) DEFAULT '',
    category_id     INT NOT NULL,
    brand           VARCHAR(100) DEFAULT '',
    stock           INT DEFAULT 0,
    sales           INT DEFAULT 0,
    status          TINYINT DEFAULT 1 COMMENT '0=下架, 1=上架',
    tag             VARCHAR(50) DEFAULT '' COMMENT '热销/新品/限时折',
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES t_category(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4. 服务表
-- ============================================================
CREATE TABLE t_service (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    price       DECIMAL(10,2) NOT NULL,
    category    VARCHAR(50) NOT NULL COMMENT 'grooming=美容, boarding=寄宿, clinic=医疗',
    image_url   VARCHAR(500) DEFAULT '',
    status      TINYINT DEFAULT 1 COMMENT '0=下架, 1=上架',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 5. 订单表
-- ============================================================
CREATE TABLE t_order (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    order_no        VARCHAR(50) NOT NULL UNIQUE,
    user_id         INT NOT NULL,
    total_amount    DECIMAL(10,2) NOT NULL,
    status          TINYINT DEFAULT 0 COMMENT '0=待付款, 1=已付款, 2=已发货, 3=已完成, 4=已取消',
    address         VARCHAR(500) DEFAULT '',
    phone           VARCHAR(20) DEFAULT '',
    receiver        VARCHAR(50) DEFAULT '',
    remark          VARCHAR(500) DEFAULT '',
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES t_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 6. 订单明细表
-- ============================================================
CREATE TABLE t_order_item (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    product_name    VARCHAR(200) NOT NULL,
    price           DECIMAL(10,2) NOT NULL,
    quantity        INT NOT NULL DEFAULT 1,
    FOREIGN KEY (order_id)   REFERENCES t_order(id),
    FOREIGN KEY (product_id) REFERENCES t_product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 初始数据
-- ============================================================

-- 管理员账户（密码均为明文，课程作业使用）
INSERT INTO t_user (username, password, nickname, role) VALUES
('admin',    'admin123',  '系统管理员', 1),
('testuser', '123456',    '测试用户',   0),
('xiaoming', '123456',    '小明',       0);

-- 商品分类（八大品类体系）
INSERT INTO t_category (id, name, icon, subcategories, sort_order) VALUES
(1,  '食品', '🍖', '主粮 · 零食 · 营养品', 1),
(2,  '出行', '🎒', '背包 · 推车 · 旅行装备', 2),
(3,  '玩耍', '🎾', '互动 · 益智 · 陪伴', 3),
(4,  '居家', '🛋️', '窝垫 · 家具 · 安睡空间', 4),
(5,  '清洁', '🧹', '日常护理 · 深度清洁', 5),
(6,  '服饰', '👗', '造型 · 保暖 · 出行穿搭', 6),
(7,  '食具', '🥣', '餐碗 · 饮水机 · 智能喂养', 7),
(8,  '智能', '🤖', '自动喂养 · 健康监测', 8);

-- 商品数据（全部品类图片，共89个商品）
INSERT INTO t_product (name, description, price, original_price, image_url, category_id, brand, stock, sales, tag) VALUES
('抑菌除臭喷雾', '专业清洁护理，守护爱宠健康。养宠必备好物。', 10.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-34-20.png', 5, '绿宠 (GreenPet)', 30, 200, '热销'),
('宠物专用湿巾', '专业清洁护理，守护爱宠健康。养宠必备好物。', 20.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-34-29.png', 5, '绿宠 (GreenPet)', 33, 188, '新品'),
('免洗泡沫干洗', '专业清洁护理，守护爱宠健康。养宠必备好物。', 35.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-34-34.png', 5, '绿宠 (GreenPet)', 36, 176, NULL),
('电动剪毛器', '专业清洁护理，守护爱宠健康。养宠必备好物。', 50.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-34-39.png', 5, '绿宠 (GreenPet)', 39, 164, NULL),
('宠物指甲剪', '专业清洁护理，守护爱宠健康。养宠必备好物。', 60.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-34-45.png', 5, '绿宠 (GreenPet)', 42, 152, NULL),
('洗耳液套装', '专业清洁护理，守护爱宠健康。养宠必备好物。', 75.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-34-49.png', 5, '绿宠 (GreenPet)', 45, 140, NULL),
('宠物牙刷套装', '专业清洁护理，守护爱宠健康。养宠必备好物。', 90.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-34-54.png', 5, '绿宠 (GreenPet)', 48, 128, NULL),
('除螨除毛滚轮', '专业清洁护理，守护爱宠健康。养宠必备好物。', 100.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-34-59.png', 5, '绿宠 (GreenPet)', 51, 116, NULL),
('宠物尿垫', '专业清洁护理，守护爱宠健康。养宠必备好物。', 115.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-35-06.png', 5, '绿宠 (GreenPet)', 54, 104, NULL),
('吸水毛巾', '专业清洁护理，守护爱宠健康。养宠必备好物。', 130.00, NULL, 'static/images/clean/Snipaste_2026-06-21_12-35-10.png', 5, '绿宠 (GreenPet)', 57, 92, '限时折'),
('韩版宠物卫衣', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 25.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-35-44.png', 6, 'PetStyle', 30, 200, '热销'),
('四脚宠物棉服', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 45.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-35-53.png', 6, 'PetStyle', 33, 188, '新品'),
('宠物防水雨衣', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 65.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-35-57.png', 6, 'PetStyle', 36, 176, NULL),
('宠物领结', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 85.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-36-01.png', 6, 'PetStyle', 39, 164, NULL),
('宠物围巾', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 100.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-36-07.png', 6, 'PetStyle', 42, 152, NULL),
('宠物太阳镜', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 120.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-48-09.png', 6, 'PetStyle', 45, 140, NULL),
('宠物凉凉衣', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 140.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-48-14.png', 6, 'PetStyle', 48, 128, NULL),
('宠物帽子', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 160.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-48-19.png', 6, 'PetStyle', 51, 116, NULL),
('宠物鞋子', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 180.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-48-26.png', 6, 'PetStyle', 54, 104, NULL),
('宠物项圈', '时尚与舒适兼备，让爱宠成为街上最靓的崽。', 200.00, NULL, 'static/images/fashion/Snipaste_2026-06-21_12-48-31.png', 6, 'PetStyle', 57, 92, NULL),
('全价全期猫粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 30.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-23-12.png', 1, '萌宠之家甄选', 30, 200, '热销'),
('全价幼犬粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 45.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-23-59.png', 1, '萌宠之家甄选', 33, 188, '新品'),
('冻干生骨肉', '优质原料精心配比，为爱宠提供全面均衡的营养。', 60.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-24-06.png', 1, '萌宠之家甄选', 36, 176, NULL),
('风干牛肉配方', '优质原料精心配比，为爱宠提供全面均衡的营养。', 75.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-24-14.png', 1, '萌宠之家甄选', 39, 164, NULL),
('鸡肉糙米犬粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 95.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-24-21.png', 1, '萌宠之家甄选', 42, 152, NULL),
('三文鱼配方猫粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 110.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-24-27.png', 1, '萌宠之家甄选', 45, 140, NULL),
('无谷低敏犬粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 125.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-24-35.png', 1, '萌宠之家甄选', 48, 128, NULL),
('室内猫控毛球粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 140.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-24-41.png', 1, '萌宠之家甄选', 51, 116, NULL),
('老年犬关节护理粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 155.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-24-47.png', 1, '萌宠之家甄选', 54, 104, NULL),
('幼猫奶糕粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 175.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-24-53.png', 1, '萌宠之家甄选', 57, 92, NULL),
('全价兔肉配方', '优质原料精心配比，为爱宠提供全面均衡的营养。', 190.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-00.png', 1, '萌宠之家甄选', 60, 80, NULL),
('低脂减肥犬粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 205.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-06.png', 1, '萌宠之家甄选', 63, 68, NULL),
('鸭肉甜薯配方', '优质原料精心配比，为爱宠提供全面均衡的营养。', 220.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-12.png', 1, '萌宠之家甄选', 66, 56, NULL),
('肠胃处方粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 240.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-18.png', 1, '萌宠之家甄选', 69, 44, NULL),
('泌尿护理猫粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 255.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-24.png', 1, '萌宠之家甄选', 72, 32, NULL),
('全价鹌鹑配方', '优质原料精心配比，为爱宠提供全面均衡的营养。', 270.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-29.png', 1, '萌宠之家甄选', 75, 20, NULL),
('鱼肉燕麦犬粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 285.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-38.png', 1, '萌宠之家甄选', 78, 8, NULL),
('雪山野味配方', '优质原料精心配比，为爱宠提供全面均衡的营养。', 300.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-46.png', 1, '萌宠之家甄选', 81, 5, NULL),
('室内幼猫粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 320.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-51.png', 1, '萌宠之家甄选', 84, 5, NULL),
('高蛋白牛肉配方', '优质原料精心配比，为爱宠提供全面均衡的营养。', 335.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-25-56.png', 1, '萌宠之家甄选', 87, 5, NULL),
('全价鹿肉粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 350.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-26-07.png', 1, '萌宠之家甄选', 90, 5, NULL),
('深海鱼油猫粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 365.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-26-22.png', 1, '萌宠之家甄选', 93, 5, NULL),
('低敏水解蛋白粮', '优质原料精心配比，为爱宠提供全面均衡的营养。', 380.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-26-32.png', 1, '萌宠之家甄选', 96, 5, NULL),
('全价羊肉配方', '优质原料精心配比，为爱宠提供全面均衡的营养。', 400.00, NULL, 'static/images/food/Snipaste_2026-06-21_12-26-41.png', 1, '萌宠之家甄选', 99, 5, '限时折'),
('记忆棉宠物窝', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 35.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-24-19.png', 4, '萌宠之家', 30, 200, '热销'),
('四季通用猫吊床', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 70.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-24-27.png', 4, '萌宠之家', 33, 188, '新品'),
('欧式宠物沙发', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 105.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-24-33.png', 4, '萌宠之家', 36, 176, NULL),
('可拆洗冰垫', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 145.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-24-37.png', 4, '萌宠之家', 39, 164, NULL),
('宠物楼梯', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 180.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-24-43.png', 4, '萌宠之家', 42, 152, NULL),
('加高狗碗架', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 215.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-24-48.png', 4, '萌宠之家', 45, 140, NULL),
('蒙古包猫窝', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 250.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-24-53.png', 4, '萌宠之家', 48, 128, NULL),
('藤编狗窝', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 285.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-24-57.png', 4, '萌宠之家', 51, 116, NULL),
('四季通用凉席垫', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 325.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-25-05.png', 4, '萌宠之家', 54, 104, NULL),
('仿真羊皮垫', '给爱宠一个温暖舒适的专属空间。用心呵护每一刻。', 360.00, NULL, 'static/images/home/Snipaste_2026-06-21_13-25-09.png', 4, '萌宠之家', 57, 92, NULL),
('麻绳磨牙结绳', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 15.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-32-33.png', 3, '萌宠之家原创', 30, 200, '热销'),
('乳胶发声玩具', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 30.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-32-46.png', 3, '萌宠之家原创', 33, 188, '新品'),
('逗猫棒套装', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 50.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-32-54.png', 3, '萌宠之家原创', 36, 176, NULL),
('飞盘训练器', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 65.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-33-00.png', 3, '萌宠之家原创', 39, 164, NULL),
('漏食球', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 85.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-33-08.png', 3, '萌宠之家原创', 42, 152, NULL),
('猫隧道玩具', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 100.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-33-13.png', 3, '萌宠之家原创', 45, 140, NULL),
('不倒翁漏食器', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 115.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-33-20.png', 3, '萌宠之家原创', 48, 128, NULL),
('益智嗅觉垫', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 135.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-33-31.png', 3, '萌宠之家原创', 51, 116, NULL),
('响纸玩偶', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 150.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-33-39.png', 3, '萌宠之家原创', 54, 104, NULL),
('网球发射器', '激发宠物天性，增进互动乐趣。陪伴快乐时光。', 170.00, NULL, 'static/images/play/Snipaste_2026-06-21_12-33-45.png', 3, '萌宠之家原创', 57, 92, NULL),
('智能喂食器', '科技改变养宠方式。智能生活触手可及。', 90.00, NULL, 'static/images/smart/Snipaste_2026-06-21_13-27-23.png', 8, 'TechPet', 30, 200, '热销'),
('智能饮水机', '科技改变养宠方式。智能生活触手可及。', 290.00, NULL, 'static/images/smart/Snipaste_2026-06-21_13-27-32.png', 8, 'TechPet', 33, 188, '新品'),
('自动逗猫器', '科技改变养宠方式。智能生活触手可及。', 495.00, NULL, 'static/images/smart/Snipaste_2026-06-21_13-27-38.png', 8, 'TechPet', 36, 176, NULL),
('智能猫砂盆', '科技改变养宠方式。智能生活触手可及。', 695.00, NULL, 'static/images/smart/Snipaste_2026-06-21_13-27-46.png', 8, 'TechPet', 39, 164, NULL),
('宠物摄像头', '科技改变养宠方式。智能生活触手可及。', 900.00, NULL, 'static/images/smart/Snipaste_2026-06-21_13-27-50.png', 8, 'TechPet', 42, 152, NULL),
('不锈钢双碗', '科学喂养从一套好餐具开始。用餐也是享受。', 20.00, NULL, 'static/images/tableware/Snipaste_2026-06-21_13-25-53.png', 7, 'SmartPet', 30, 200, '热销'),
('慢食盆', '科学喂养从一套好餐具开始。用餐也是享受。', 55.00, NULL, 'static/images/tableware/Snipaste_2026-06-21_13-26-04.png', 7, 'SmartPet', 33, 188, '新品'),
('陶瓷猫碗', '科学喂养从一套好餐具开始。用餐也是享受。', 90.00, NULL, 'static/images/tableware/Snipaste_2026-06-21_13-26-10.png', 7, 'SmartPet', 36, 176, NULL),
('自动喂食器', '科学喂养从一套好餐具开始。用餐也是享受。', 125.00, NULL, 'static/images/tableware/Snipaste_2026-06-21_13-26-15.png', 7, 'SmartPet', 39, 164, NULL),
('悬挂水壶', '科学喂养从一套好餐具开始。用餐也是享受。', 160.00, NULL, 'static/images/tableware/Snipaste_2026-06-21_13-26-20.png', 7, 'SmartPet', 42, 152, NULL),
('宠物餐桌', '科学喂养从一套好餐具开始。用餐也是享受。', 195.00, NULL, 'static/images/tableware/Snipaste_2026-06-21_13-26-25.png', 7, 'SmartPet', 45, 140, NULL),
('折叠硅胶碗', '科学喂养从一套好餐具开始。用餐也是享受。', 230.00, NULL, 'static/images/tableware/Snipaste_2026-06-21_13-26-31.png', 7, 'SmartPet', 48, 128, NULL),
('不锈钢铁盆', '科学喂养从一套好餐具开始。用餐也是享受。', 265.00, NULL, 'static/images/tableware/Snipaste_2026-06-21_13-26-35.png', 7, 'SmartPet', 51, 116, NULL),
('便携双碗', '科学喂养从一套好餐具开始。用餐也是享受。', 300.00, NULL, 'static/images/tableware/Snipaste_2026-06-21_13-26-39.png', 7, 'SmartPet', 54, 104, NULL),
('轻便宠物双肩包', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 60.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-30-14.png', 2, 'OutdoorPro', 30, 200, '热销'),
('多功能宠物推车', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 115.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-30-36.png', 2, 'OutdoorPro', 33, 188, '新品'),
('航空托运箱', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 165.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-30-47.png', 2, 'OutdoorPro', 36, 176, NULL),
('车载宠物垫', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 220.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-30-58.png', 2, 'OutdoorPro', 39, 164, NULL),
('折叠宠物水碗', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 275.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-31-06.png', 2, 'OutdoorPro', 42, 152, NULL),
('可伸缩牵引绳', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 330.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-31-14.png', 2, 'OutdoorPro', 45, 140, NULL),
('宠物救生衣', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 385.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-31-22.png', 2, 'OutdoorPro', 48, 128, NULL),
('宠物旅行帐篷', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 435.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-31-33.png', 2, 'OutdoorPro', 51, 116, NULL),
('便携宠物床', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 490.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-31-38.png', 2, 'OutdoorPro', 54, 104, NULL),
('狗狗雨衣', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 545.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-31-46.png', 2, 'OutdoorPro', 57, 92, NULL),
('宠物GPS定位器', '带爱宠看世界，从这件装备开始。让旅途更安心舒适。', 600.00, NULL, 'static/images/travel/Snipaste_2026-06-21_12-31-57.png', 2, 'OutdoorPro', 60, 80, '限时折');

-- 服务数据（三个分类各5项，共15项）
INSERT INTO t_service (name, description, price, category, image_url) VALUES
-- 美容 (grooming)
('基础洗护 Bath',
 '包含深层洁毛、除味护理、指甲修剪、耳道清洁及眼部卫生，让爱宠焕发清新活力。适合日常护理。',
 88.00, 'grooming',
 'static/images/clean/Snipaste_2026-06-21_12-34-20.png'),

('全套造型 Full Clip',
 '在洗护基础上，根据宠物品种及体型进行的精细化修剪和个性化造型设计。含头部、身体、尾部精修。',
 158.00, 'grooming',
 'static/images/clean/Snipaste_2026-06-21_12-34-29.png'),

('高端SPA护理 SPA',
 '精油香薰、药浴按摩、深层滋养泥膜，有效改善皮肤问题，缓解爱宠压力。含30分钟穴位按摩。',
 358.00, 'grooming',
 'static/images/clean/Snipaste_2026-06-21_12-34-34.png'),

('去底绒护理',
 '针对换毛期宠物的深层去底绒服务，有效减少家中飞毛现象。含毛发梳理+护毛素护理。',
 128.00, 'grooming',
 'static/images/clean/Snipaste_2026-06-21_12-34-39.png'),

('宠物手足护理',
 '包含指甲修剪打磨、脚底毛修剪、肉垫滋润护理。适合不爱剪指甲的宝贝。',
 68.00, 'grooming',
 'static/images/clean/Snipaste_2026-06-21_12-34-45.png'),

-- 寄宿 (boarding)
('总统套房寄宿 VIP',
 '24小时恒温控制，全屋新风系统，配备智能监控摄像头，可随时随地通过APP查看爱宠状态。',
 120.00, 'boarding',
 'static/images/home/Snipaste_2026-06-21_13-24-19.png'),

('标准萌宠间寄宿',
 '适合中小型宠物，温馨舒适独立空间。每日深度消毒，提供专业看护和定时遛宠服务。',
 60.00, 'boarding',
 'static/images/home/Snipaste_2026-06-21_13-24-27.png'),

('豪华猫别墅寄宿',
 '多层猫爬架+观景窗，独立猫砂区。每日罐头加餐，专人陪伴玩耍。专为猫咪设计的度假空间。',
 98.00, 'boarding',
 'static/images/home/Snipaste_2026-06-21_13-24-33.png'),

('日间托管 Daycare',
 '早送晚接，含2次户外遛放、午餐喂养、社交游戏。适合工作繁忙的宠物家长。',
 45.00, 'boarding',
 'static/images/play/Snipaste_2026-06-21_12-32-33.png'),

('宠物训练寄宿',
 '寄宿期间含基础行为训练（坐、卧、等待、拒食）。由专业训犬师一对一指导。',
 198.00, 'boarding',
 'static/images/play/Snipaste_2026-06-21_12-32-46.png'),

-- 医疗 (clinic)
('常规体检套餐',
 '早期预防优于治疗。包含血常规、生化12项、粪便检查、皮肤检查及专业兽医咨询。',
 299.00, 'clinic',
 'static/images/tableware/Snipaste_2026-06-21_13-25-53.png'),

('疫苗接种套餐',
 '严选进口疫苗，完整档案管理，到期自动提醒。含基础三联/五联及狂犬疫苗。',
 199.00, 'clinic',
 'static/images/tableware/Snipaste_2026-06-21_13-26-04.png'),

('消化系统检查',
 '针对呕吐、腹泻、食欲不振等消化问题的专项检查。含粪便镜检、腹部B超、快速试纸检测。',
 249.00, 'clinic',
 'static/images/tableware/Snipaste_2026-06-21_13-26-10.png'),

('皮肤科专项检查',
 '针对皮肤病、脱毛、瘙痒等问题的全面诊断。含皮肤刮片、真菌培养、过敏原筛查。',
 179.00, 'clinic',
 'static/images/clean/Snipaste_2026-06-21_12-34-49.png'),

('牙齿清洁护理',
 '专业超声波洁牙，去除牙结石和牙菌斑。含术前检查、麻醉监护和术后护理。',
 399.00, 'clinic',
 'static/images/clean/Snipaste_2026-06-21_12-34-54.png');
