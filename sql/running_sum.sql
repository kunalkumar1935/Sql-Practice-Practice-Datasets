select *, sum(`sales`) over( order by `Sale_Date` rows between unbounded preceding and current row) rolling_sum
 from sales ;

CREATE TABLE Sales_Data (
    ID INT PRIMARY KEY,
    State VARCHAR(20),
    Sale_Date DATE,
    Sales INT
);

INSERT INTO Sales_Data (ID, State, Sale_Date, Sales) VALUES
(1, 'Jharkhand', '2022-06-22', 603),
(2, 'Jharkhand', '2022-06-21', 478),
(3, 'Jharkhand', '2022-06-20', 679),
(4, 'Jharkhand', '2022-06-19', 443),
(5, 'Jharkhand', '2022-06-18', 540),
(6, 'Jharkhand', '2022-06-17', 806),
(7, 'Jharkhand', '2022-06-16', 939),
(8, 'Jharkhand', '2022-06-15', 803),
(9, 'Jharkhand', '2022-06-14', 440),
(10, 'Jharkhand', '2022-06-13', 444),

(11, 'Bihar', '2022-06-22', 563),
(12, 'Bihar', '2022-06-21', 371),
(13, 'Bihar', '2022-06-20', 881),
(14, 'Bihar', '2022-06-19', 541),
(15, 'Bihar', '2022-06-18', 829),
(16, 'Bihar', '2022-06-17', 846),
(17, 'Bihar', '2022-06-16', 653),
(18, 'Bihar', '2022-06-15', 531),
(19, 'Bihar', '2022-06-14', 327),
(20, 'Bihar', '2022-06-13', 717),

(21, 'Maharashtra', '2022-06-22', 925),
(22, 'Maharashtra', '2022-06-21', 896),
(23, 'Maharashtra', '2022-06-20', 647),
(24, 'Maharashtra', '2022-06-19', 419),
(25, 'Maharashtra', '2022-06-18', 762),
(26, 'Maharashtra', '2022-06-17', 415),
(27, 'Maharashtra', '2022-06-16', 834),
(28, 'Maharashtra', '2022-06-15', 822),
(29, 'Maharashtra', '2022-06-14', 887),
(30, 'Maharashtra', '2022-06-13', 828);

select *, sum(`sales`) over(partition by `State` order by `Sale_Date` rows between unbounded preceding and current row) rolling_sum
 from sales_data ;