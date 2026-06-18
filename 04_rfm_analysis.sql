-- RFM用户分层

-- 1、按消费者ID分组算出R、F、M的值
WITH rfm AS (
    SELECT
        CustomerID,
        TIMESTAMPDIFF(DAY, MAX(InvoiceDate), max_date) AS recency,
        COUNT(DISTINCT InvoiceNo) AS frequency,
        SUM(Quantity * UnitPrice) AS monetary
    FROM
        (
            SELECT
                *,
                (
                    SELECT
                        MAX(InvoiceDate)
                    FROM
                        sales_data
                ) AS max_date
            FROM
                sales_data
        ) tt
    WHERE
        Quantity > 0
    GROUP BY
        CustomerID
),
-- 2、根据R、F、M的值进行分箱打分
rfm_score AS (
    SELECT
        CustomerID,
        NTILE(5) OVER(
            ORDER BY
                recency DESC
        ) AS r_score,
        NTILE(5) OVER(
            ORDER BY
                frequency
        ) AS f_score,
        NTILE(5) OVER(
            ORDER BY
                monetary
        ) AS m_score
    FROM
        rfm
),
-- 3、根据R、F、M的得分对用户进行分层：
-- 共分四层——高价值、潜力、一般、流失
cust_seg AS (
    SELECT
        *,
        CASE
            WHEN r_score >= 4
            AND f_score >= 4
            AND m_score >= 4 THEN '高价值用户'
            WHEN r_score <= 2
            AND f_score <= 2
            AND m_score <= 2 THEN '流失用户'
            ELSE '一般用户'
        END AS Customer_segment
    FROM
        rfm_score
) 
-- 各分层用户总人数及所占比例
-- 各分层用户总消费金额及所占比例
SELECT
    Customer_segment,
    COUNT(DISTINCT t2.CustomerID) cust_num,
    (
        SELECT
            COUNT(DISTINCT CustomerID)
        FROM
            sales_data
        WHERE
            Quantity > 0
    ) total_num,
    CONCAT(
        ROUND(
            COUNT(DISTINCT t2.CustomerID) /(
                SELECT
                    COUNT(DISTINCT CustomerID)
                FROM
                    sales_data
                WHERE
                    Quantity > 0
            ) * 100,
            0
        ),
        '%'
    ) cust_num_ratio,
    SUM(UnitPrice * Quantity) cust_money,
    (
        SELECT
            SUM(UnitPrice * Quantity)
        FROM
            sales_data
        WHERE
            Quantity > 0
    ) total_money,
    CONCAT(
        ROUND(
            SUM(UnitPrice * Quantity) /(
                SELECT
                    SUM(UnitPrice * Quantity)
                FROM
                    sales_data
                WHERE
                    Quantity > 0
            ) * 100,
            0
        ),
        '%'
    ) cust_money_ratio
FROM
    sales_data t1
    JOIN cust_seg t2 ON t1.CustomerID = t2.CustomerID
WHERE
    Quantity > 0
GROUP BY
    t2.Customer_segment;