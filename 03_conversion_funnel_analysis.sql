# 用户行为转化漏斗（浏览pv，加购cart，购买buy）

## 浏览到加购的转化率：
## 浏览用户数3314，浏览并加购对应商品的用户数10671
select concat(round(count(distinct t1.user_id)/(
select count(distinct user_id) from user_behavior where behavior='pv'
)*100,2),'%') as pv_cart_ratio
from user_behavior t1 join user_behavior t2 
on t1.user_id=t2.user_id and t1.goods_id=t2.goods_id 
where t1.behavior='pv' and t2.behavior='cart' and t1.timestamp<t2.timestamp；

## 加购到购买的转化率：
## 加购用户数1630，加购并购买对应商品的用户数7404
select concat(round(count(distinct t1.user_id)/(
select count(distinct user_id) from user_behavior where behavior='cart'
)*100,2),'%') as cart_buy_ratio
from user_behavior t1 join user_behavior t2 
on t1.user_id=t2.user_id and t1.goods_id=t2.goods_id 
where t1.behavior='cart' and t2.behavior='buy' and t1.timestamp<t2.timestamp；