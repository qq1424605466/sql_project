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

-- 创建用户销售数据表（用于：RFM分层）
CREATE TABLE sales_data(
InvoiceNo VARCHAR(10),
StockCode VARCHAR(10),
Description VARCHAR(50),
Quantity INT,
InvoiceDate VARCHAR(30),
UnitPrice DECIMAL(10,2),
CustomerID VARCHAR(10),
Country VARCHAR(30)
);