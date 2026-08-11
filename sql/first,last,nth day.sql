select * ,
first_value(`sales`) over(partition by `state` order by `sale_date`) first_day_sales,
last_value(`sales`) over(partition by `state` order by `sale_date` rows between unbounded preceding and unbounded following ) last_day_sales,
nth_value(`sales`,5) over(partition by `state` order by `sale_date`) fifth_day_sale
from sales_data;