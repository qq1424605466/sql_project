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
-- sales_data 表：54万-->40万

-- 1、处理空值：数据量从541909条到406829条
DELETE FROM sales_data 
WHERE InvoiceNo IS NULL OR InvoiceNo = ''
OR StockCode IS NULL OR StockCode = ''
OR Description IS NULL OR Description = ''
OR Quantity IS NULL 
OR InvoiceDate IS NULL OR InvoiceDate = ''
OR UnitPrice IS NULL 
OR CustomerID IS NULL OR CustomerID = ''
OR Country IS NULL OR Country = '';

-- 2、处理重复值：406829条-->401604条数据
--创建去重表
CREATE TABLE sales_data_dedup 
AS
SELECT DISTINCT *
FROM sales_data;
--删除原表
DROP TABLE sales_data;
--重命名新表
ALTER TABLE sales_data_dedup RENAME sales_data;


InvoiceNo,StockCode,Description,Quantity,InvoiceDate,UnitPrice,CustomerID,Country
-- 3、处理异常值：401604条-->399656条数据
DELETE FROM sales_data 
WHERE InvoiceNo NOT REGEXP '^C?[0-9]{6}$'  
OR StockCode NOT REGEXP '^[0-9]{5}[A-Z]*$'
OR UnitPrice <=0
OR CustomerID NOT REGEXP '^[0-9]{5}$';

DELETE SELECT * FROM sales_data 
WHERE (InvoiceNo REGEXP '^[0-9]{6}$' AND Quantity<=0) 
OR (InvoiceNo REGEXP '^C[0-9]{6}$' AND Quantity>=0);

-- 4、格式转换：将字符串格式时间%m/%d/%Y %H:%i转化为日期时间格式
ALTER TABLE sales_data
ADD COLUMN InvoiceDate_1 DATETIME
AFTER InvoiceDate;

UPDATE sales_data
SET InvoiceDate_1=STR_TO_DATE(InvoiceDate,'%m/%d/%Y %H:%i');

ALTER TABLE sales_data
DROP COLUMN InvoiceDate;

ALTER TABLE sales_data
CHANGE InvoiceDate_1 InvoiceDate DATETIME;

--时间范围：从 2010-12-01 08:26  到 2011-12-09 12:50





