-- CTEs (COMMON TABLE EXPRESSION)

SELECT AVG(avg_sal) as avgg
FROM ( SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal , MIN(salary) min_sal, COUNT(salary) count_sal
    FROM employee_demographics dem
    JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id
    GROUP BY gender) avg_avg_sal;
    

WITH CTE_EXAMPLE (Gender, avg_sal,max_sal, min_sal, count_sal) AS
(
	SELECT gender, AVG(salary) , MAX(salary)  , MIN(salary), COUNT(salary) 
    FROM employee_demographics dem
    JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id
    GROUP BY gender
)

SELECT *
FROM CTE_EXAMPLE;

WITH CTE_EXAMPLE2 AS 
( SELECT employee_id,gender,birth_date
	FROM employee_demographics
    WHERE birth_date > '1985-01-01' ),
    
CTE_EXAMPLE3 AS 
( SELECT employee_id, salary
FROM employee_salary
WHERE salary> 50000)

SELECT * 
FROM CTE_EXAMPLE2 ex2
JOIN CTE_EXAMPLE3 ex3
ON ex2.employee_id= ex3.employee_id;




 