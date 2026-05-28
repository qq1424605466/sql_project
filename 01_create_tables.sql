-- 创建ecommerce数据库
CREATE DATABASE IF NOT EXTISTS ecommerce;
USE ecommerce;

-- 创建用户行为数据表（用于：转化漏斗）
CREATE TABLE user_behavior(
user_id INT,
goods_id INT,
category_id INT,	
behavior VARCHAR(5),
timestamp INT,
sex INT,
address VARCHAR(20),
device VARCHAR(20),
price DECIMAL(10,2),
amount INT,
comment TEXT
);


-- 创建用户购物数据表（用于：RFM分层）
CREATE TABLE customer_shopping_data(
invoice_no CHAR(7),	
customer_id CHAR(7),	
gender VARCHAR(7),
age INT,
category VARCHAR(20),
quantity INT,
price DECIMAL(10,2),
payment_method VARCHAR(12),
invoice_date VARCHAR(12)
);