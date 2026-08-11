CREATE TABLE Sales2 (
    ID INT PRIMARY KEY,
    Sale_Date DATE,
    Sales INT
);

INSERT INTO Sales2 (ID, Sale_Date, Sales) VALUES
(1, '2021-01-01', 52),
(2, '2021-01-02', 74),
(3, '2021-01-03', 32),
(4, '2021-01-04', 66),
(5, '2021-01-05', 79),
(6, '2021-01-06', 69),
(7, '2021-01-07', 53),
(8, '2021-01-08', 67),
(9, '2021-01-09', 69),
(10, '2021-01-10', 48),
(11, '2021-01-11', 78),
(12, '2021-01-12', 34),
(13, '2021-01-13', 44),
(14, '2021-01-14', 65);

select *, sum(`sales`) over(order by `Sale_date` rows between 1 preceding and 1 following) total_sales_today_lastday_nextday
from Sales2;

select *, sum(`sales`) over(order by `Sale_date` rows between 2 preceding and 3 following) total_sales_today_last2day_next3day
from Sales2;

select *, sum(`sales`) over(order by `Sale_date` rows between unbounded preceding and unbounded following) total_sales_today_alldaybefore_allnextday
from Sales2;