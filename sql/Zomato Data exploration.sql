select * from `zomato_customer`;

select *  from `zomato_orders`;

select * from `zomato_restaurants`;

UPDATE zomato_customer
SET signup_time = REPLACE(signup_time, '-', '/');

UPDATE zomato_orders
SET order_timestamp = REPLACE(order_timestamp, '-', '/');

UPDATE `zomato_customer`
SET signup_time = STR_TO_DATE(signup_time, '%d/%m/%Y');


UPDATE `zomato_orders`
SET order_timestamp = STR_TO_DATE(order_timestamp, '%m/%d/%Y');

-- Revenue Analaysis

-- 1. What is the total revenue

select sum(order_amount) total_revenue from zomato_orders
where order_status='Delivered';

-- 2. What is the monthly revenue trend

select DATE_FORMAT(order_timestamp, '%Y-%m-01')  as month_year, sum(order_amount) monthly_revenue from zomato_orders
where order_status='Delivered'
group by  month_year;

-- 3. Which city contributes the highest revenue

select city, sum(order_amount) total_revenue 
from zomato_customer a 
join zomato_orders b
on a.Customer_id= b.customer_id
where order_status='Delivered'
group by city
order by total_revenue desc
limit 1;

-- 4. Which payment mode generate the most revenue

select payment_mode, sum(order_amount) revenue from zomato_orders
where order_status='Delivered'
group by  payment_mode
order by revenue desc
limit 1 ;


-- 5. Avg order value (AOV)

select sum(order_amount)/count(distinct order_id) AOV  from zomato_orders
where order_status='Delivered';

-- Customer Analysis

-- 1. Top 20 customers by revenue

select *, row_number() over(order by total_revenue desc) as rnk from (
select customer_id, sum(order_amount) as total_revenue from zomato_orders
where order_status='Delivered'
group by customer_id ) a
limit 20;

-- 2. What percentage of revenue comes from top customers

with cte as(
select *, row_number() over(order by total_revenue desc) as rnk from (
select customer_id, sum(order_amount) as total_revenue from zomato_orders
where order_status='Delivered'
group by customer_id ) a
limit 20)

select sum(total_revenue)*100/(select sum(order_amount) from zomato_orders where order_status='Delivered') as percentage_of_top_cust
from cte;

-- 3. Which acquisition channel bring the highest-value customers

select acquisition_channel, count(distinct customer_id) total_customers from zomato_customer
group by 1
order by 2 desc
limit 1;

-- 4. How many repeat customers do we have

WITH first AS (
    SELECT customer_id, MIN(order_timestamp) AS first_time
    FROM zomato_orders
    GROUP BY customer_id
)

SELECT 
    DATE_FORMAT(a.order_timestamp, '%Y-%m-01') AS month,
    COUNT(DISTINCT a.customer_id) AS repeat_customers
FROM zomato_orders a
JOIN first b 
    ON a.customer_id = b.customer_id
WHERE  a.order_timestamp > b.first_time
GROUP BY 1
ORDER BY 1;


-- Restaurant Performance

-- 1. Which restaurants generate the highest revenue

select b.restaurant_id,b.restaurant_name, sum(order_amount) as total_revenue from zomato_orders a
join zomato_restaurants b on a.restaurant_id=b.restaurant_id
where order_status= 'Delivered'
group by a.restaurant_id,restaurant_name
order by sum(order_amount) desc;

-- 2. Which restaurants recieve most orders 


 select b.restaurant_id,b.restaurant_name, count(distinct order_id) as total_orders from zomato_orders a
join zomato_restaurants b on a.restaurant_id=b.restaurant_id
where order_status= 'Delivered'
group by a.restaurant_id,restaurant_name
order by total_orders  desc;

-- 3. Which cousines are most popular 

select cuisine,count(cuisine) ordered from
zomato_restaurants a join zomato_orders b
on a.restaurant_id=b.restaurant_id
where order_status= 'Delivered'
group by cuisine
order by count(cuisine) desc;

-- 4. Do highly rated restaurants generate more revenue


 select a.restaurant_name, a.avg_rating,sum(order_amount) as total_revenue from zomato_restaurants a
join zomato_orders b on a.restaurant_id=b.restaurant_id
where order_status= 'Delivered'
group by a.restaurant_name, a.avg_rating
order by sum(order_amount)  desc;

-- 5. Last 5 restaurant

select * from (
select restaurant_name,total_revenue, row_number() over(order by total_revenue ) as rnk from (
select b.restaurant_name, sum(order_amount) as total_revenue from zomato_orders a
join zomato_restaurants b on a.restaurant_id=b.restaurant_id
where order_status= 'Delivered'
group by b.restaurant_name
order by sum(order_amount) ) c )d
where rnk<=5;

-- Cancellation and refund analysis

-- 1. Cancellation Rate

select count(distinct case when order_status = 'Cancelled' then order_id end)/count(distinct order_id) canc_rate from zomato_orders;

-- 2. Refund rate 

select count(distinct case when order_status = 'Refunded' then order_id end)/count(distinct order_id) ref_rate from zomato_orders;


-- 3. How much revenue is lost when cancellation 

select sum(order_amount) revenue_lost from zomato_orders
where order_status='Cancelled';

-- 4. Which restaurants have highest cancellation rate

with cte as (
select restaurant_id,count(distinct case when order_status = 'Cancelled' then order_id end)/count(distinct order_id) canc_rate from zomato_orders
group by 1)

select a.restaurant_name,b.canc_rate from zomato_restaurants a join cte b on a.restaurant_id=b.restaurant_id
order by 2 desc;

-- Customer Churn Analysis

-- 1. How many customers have churned (havent ordered in last 90 days)


with last as (
select max(order_timestamp) last_txn from zomato_orders),

cust_last as (
select customer_id,max(order_timestamp) MAXlast_txn from zomato_orders
group by customer_id )

select count(*) cust_churn from cust_last a
cross join last b
where datediff(b.last_txn,a.MAXlast_txn) >90;

-- 2. Churn rate

with last as (
select max(order_timestamp) last_txn from zomato_orders),

cust_last as (
select customer_id,max(order_timestamp) MAXlast_txn from zomato_orders
group by customer_id ),

churn_ as(
select *, case when datediff(b.last_txn,a.MAXlast_txn) >90 then 1 else 0 end as is_churn from cust_last a
cross join last b )

select sum(is_churn)/count(*) from churn_;

-- 3. Which city has the highest churn

with last as (
select max(order_timestamp) last_txn from zomato_orders),

cust_last as (
select a.customer_id,city,max(order_timestamp) MAXlast_txn from zomato_orders a
join zomato_customer b on a.Customer_id=b.Customer_id 
group by customer_id,city )


select city,count(*) churn_cust from cust_last a 
cross join last b 
where datediff(b.last_txn,a.MAXlast_txn) >90
group by city
order by churn_cust desc;




-- 4. How much revenue lost due to churn


with last as (
select max(order_timestamp) last_txn from zomato_orders),

cust_last as (
select a.customer_id,city,max(order_timestamp) MAXlast_txn from zomato_orders a
join zomato_customer b on a.Customer_id=b.Customer_id 
group by customer_id,city ),

churn as (
select customer_id from cust_last a 
cross join last b 
where datediff(b.last_txn,a.MAXlast_txn) >90 )

select sum(order_amount) lost_revenue from zomato_orders
where customer_id in (select customer_id from churn);

-- 5. Who are the high value churn customers

with last as (
select max(order_timestamp) last_txn from zomato_orders),

cust_last as (
select a.customer_id,city,max(order_timestamp) MAXlast_txn from zomato_orders a
join zomato_customer b on a.Customer_id=b.Customer_id 
group by customer_id,city ),

churn as (
select customer_id from cust_last a 
cross join last b 
where datediff(b.last_txn,a.MAXlast_txn) >90 )

select customer_id,sum(order_amount) lost_revenue from zomato_orders
where customer_id in (select customer_id from churn)
group by 1
order by 2 desc
limit 10;

