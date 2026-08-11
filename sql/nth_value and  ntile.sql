
 select *, case when sales_difference > 0 then "Yes" else "No" end as increased_sales_from_day_1 from
 (SELECT *,
       NTH_VALUE(sales, 4) OVER (
           PARTITION BY state
           ORDER BY sale_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       )
       -
       FIRST_VALUE(sales) OVER (
           PARTITION BY state
           ORDER BY sale_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS sales_difference
FROM sales_data) a
;

select * ,
case when a.n=1 then "High Sales" when a.n=2 then "Medium Sales" else "Low Sales" end as sales_value
from (
select *, ntile(3) over(partition by state order by sales desc) n
from sales_data) a;