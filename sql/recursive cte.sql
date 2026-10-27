-- recursive cte

with recursive cte_numbers as (
select 1 as num -- anchor query
union all
select num+1 -- recursive query
from cte_numbers
where num<6 -- filter to stop recursion
)

select num
from cte_numbers;