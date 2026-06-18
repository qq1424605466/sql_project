# 用户行为转化漏斗（浏览pv，加购cart，购买buy）

## 浏览到加购的转化率 31.06% ：
## 浏览用户数10671，浏览并加购对应商品的用户数3314
SELECT
    COUNT(DISTINCT t1.user_id) pv_cart_num,
    (
        SELECT
            COUNT(DISTINCT user_id)
        FROM
            user_behavior
        WHERE
            behavior = 'pv'
    ) pv_num,
    CONCAT(
        ROUND(
            COUNT(DISTINCT t1.user_id) * 100 / (
                SELECT
                    COUNT(DISTINCT user_id)
                FROM
                    user_behavior
                WHERE
                    behavior = 'pv'
            ),
            2
        ),
        '%'
    ) AS pv_cart_ratio
FROM
    user_behavior t1
    JOIN user_behavior t2 ON t1.user_id = t2.user_id
    AND t1.goods_id = t2.goods_id
WHERE
    t1.behavior = 'pv'
    AND t2.behavior = 'cart'
    AND t1.timestamp < t2.timestamp;

## 加购到购买的转化率 22.02% ：
## 加购用户数7404，加购并购买对应商品的用户数1630
SELECT
    COUNT(DISTINCT t1.user_id) cart_buy_num,
    (
        SELECT
            COUNT(DISTINCT user_id)
        FROM
            user_behavior
        WHERE
            behavior = 'cart'
    ) cart_num,
    CONCAT(
        ROUND(
            COUNT(DISTINCT t1.user_id) * 100 / (
                SELECT
                    COUNT(DISTINCT user_id)
                FROM
                    user_behavior
                WHERE
                    behavior = 'cart'
            ),
            2
        ),
        '%'
    ) AS cart_buy_ratio
FROM
    user_behavior t1
    JOIN user_behavior t2 ON t1.user_id = t2.user_id
    AND t1.goods_id = t2.goods_id
WHERE
    t1.behavior = 'cart'
    AND t2.behavior = 'buy'
    AND t1.timestamp < t2.timestamp;