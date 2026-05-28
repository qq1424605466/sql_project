--  user_behavior 表

-- 1、查看空值：无
SELECT COUNT(*) 
FROM user_behavior 
WHERE user_id IS NULL
OR goods_id IS NULL 
OR category_id IS NULL 
OR behavior IS NULL
OR timestamp IS NULL;

-- 2、查看重复值：无
SELECT *,COUNT(*)
FROM user_behavior 
GROUP BY 1,2,3,4,5,6,7,8,9,10,11 
HAVING COUNT(*)>=2 
ORDER BY 1,2,3,4,5;

-- 3、处理异常值：timestamp 列有7268个异常值为'value'
DELETE FROM user_behavior 
WHERE behavior NOT IN ('pv','fav','cart','buy')
OR sex NOT IN ('0','1')
OR price <0
OR amount <0
OR timestamp=0;

-- 4、格式转换：
-- 将UNIX时间戳转换为yyyy-mm-dd时间格式：
ALTER TABLE user_behavior
ADD COLUMN datetime DATETIME
AFTER timestamp;

UPDATE user_behavior
SET datetime=FROM_UNIXTIME(timestamp);

ALTER TABLE user_behavior
DROP COLUMN timestamp;

ALTER TABLE user_behavior
CHANGE datetime timestamp DATETIME;

-- 时间范围：2024-05-29 10:40:00 到 2024-06-04 10:39:55
SELECT MIN(timestamp),MAX(timestamp) 
FROM user_behavior;


--  ======================================
-- customer_shopping_data 表

-- 1、查看空值：无
SELECT COUNT(*) 
FROM customer_shopping_data 
WHERE invoice_no IS NULL
OR customer_id IS NULL 
OR quantity IS NULL 
OR price IS NULL
OR invoice_date IS NULL;

-- 2、查看重复值：无
SELECT *,count(*) 
FROM customer_shopping_data 
GROUP BY 1,2,3,4,5,6,7,8,9 
HAVING COUNT(*)>=2 
ORDER BY 1,2,3,4,5,6,7,8,9 ;

-- 3、查看异常值：无
SELECT COUNT(*)
FROM customer_shopping_data 
WHERE invoice_no regexp '~^I[0-9]{6}' 
OR customer_id regexp '~^C[0-9]{6}'
OR gender NOT IN ('Female','Male')
OR age >=120
OR quantity <0
OR price <=0;

-- 4、格式转换：
-- 去掉末尾换行符
UPDATE customer_shopping_data 
SET invoice_date=REPLACE(invoice_date,'\r','');   

-- 将 d/m/yyyy 转换为 yyyy-mm-dd时间格式
UPDATE customer_shopping_data 
SET invoice_date=STR_TO_DATE(invoice_date,'%d/%m/%Y');

-- 5、时间范围筛选：
-- 原始时间范围：2021-01-01 到 2023-03-08
SELECT MIN(invoice_date),MAX(invoice_date) 
FROM customer_shopping_data;   

-- 筛选出2021-09-01到2022-08-31 的数据
DELETE FROM customer_shopping_data
WHERE invoice_date NOT BETWEEN '2021-09-01'  AND '2022-08-31';  




