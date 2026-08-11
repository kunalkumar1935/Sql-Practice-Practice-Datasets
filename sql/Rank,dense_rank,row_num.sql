
SELECT *,
 rank() over(order by `sales` desc) rnk,
dense_rank() over(order by `sales` desc) dens ,
row_number() over(order by `sales` desc) rownum
FROM `sqladvanced`.`Sales`;

CREATE TABLE Sales (
    ID INT PRIMARY KEY,
    Sale_Date DATE,
    Sales INT
);

INSERT INTO Sales (ID, Sale_Date, Sales) VALUES
(1, '2022-06-22', 603),
(2, '2022-06-21', 478),
(3, '2022-06-20', 679),
(4, '2022-06-19', 443),
(5, '2022-06-18', 540),
(6, '2022-06-17', 740),
(7, '2022-06-16', 478),
(8, '2022-06-15', 604),
(9, '2022-06-14', 478),
(10, '2022-06-13', 603);

CREATE TABLE Employee (
    ID INT PRIMARY KEY,
    Department VARCHAR(20),
    Salary INT
);

INSERT INTO Employee (ID, Department, Salary) VALUES
(1, 'SALES', 1000),
(2, 'IT', 1500),
(3, 'SALES', 2000),
(4, 'SALES', 1700),
(5, 'IT', 1800),
(6, 'ACCOUNTS', 1200),
(7, 'ACCOUNTS', 1100);

select *, 
rank() over(partition by `Department` order by `Salary`) emprank,
dense_rank() over(partition by `Department` order by `Salary`) densemp,
row_number() over(partition by `Department` order by `Salary`) rowemp
From employee;