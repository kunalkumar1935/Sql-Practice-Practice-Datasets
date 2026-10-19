/*
The Pareto principle states that for many outcomes, roughly 80% of consequences come from 20% of causes. eg:

1- 80% of the productivity come from 20% of the employees.
2- 80% of your sales come from 20% of your clients.
3- 80% of decisions in a meeting are made in 20% of the time.

4- 80% of your sales comes from 20% of your products or services.
*/

with product_wise_sales as (
select product_id, sum(sales) product_sales
from orders
group by product_id),
calc_sales as (
select product_id,product_sales, 
sum(product_sales) over(order by product_sales desc rows between unbounded preceding and 0 preceding) as running_sales,
0.8*sum(product_sales) over() as total_sales
from product_wise_sales)

select * from calc_sales where running_sales <= total_sales;
