
-- query to return the table that returns start date , end date, and result between that range
drop table if exists tasks;
create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success');

with all_dates as
(
select *,
row_number() over(partition by state order by date_value asc) as rn,
DATE_SUB(
           date_value,
           INTERVAL ROW_NUMBER() OVER (
               PARTITION BY state
               ORDER BY date_value
           ) DAY
       ) AS group_date
from tasks
order by date_value
)

select min(date_value) as start_date, max(date_value) as end_date,state
from all_dates
group by group_date,state
order by start_date