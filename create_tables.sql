CREATE DATABASE IF NOT EXTISTS ecommerce;
USE ecommerce;

CREATE TABLE user_behavior(
user_id int,
goods_id int,
category_id int,	
behavior varchar(5),
timestamp int,
sex int,
address varchar(20),
device varchar(20),
price decimal(10,2),
amount int,
comment varchar(100)
);

CREATE TABLE customer_shopping_data(
invoice_no varchar(20),	
customer_id varchar(20),	
gender varchar(20),
age int,
category varchar(20),
quantity int,
price decimal(10,2),
payment_method varchar(20),
invoice_date varchar(20)
);