-- Window Functions

SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN	employee_salary sal
ON  dem.employee_id= sal.employee_id
GROUP BY gender;

-- using WF

SELECT dem.first_name,dem.last_name, gender, AVG(salary) OVER(partition by gender)
FROM employee_demographics dem
JOIN	employee_salary sal
ON  dem.employee_id= sal.employee_id;

SELECT dem.first_name,dem.last_name, gender, SUM(salary) OVER(partition by gender)
FROM employee_demographics dem
JOIN	employee_salary sal
ON  dem.employee_id= sal.employee_id;

-- ROLLING TOTAL

SELECT dem.first_name,dem.last_name, gender, salary,
		SUM(salary) OVER(partition by gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN	employee_salary sal
ON  dem.employee_id= sal.employee_id;

SELECT  dem.employee_id,dem.first_name,dem.last_name, gender, salary,
		ROW_NUMBER() OVER(partition by gender ORDER BY salary DESC) row_num,
        RANK() OVER(partition by gender ORDER BY salary DESC) rank_num,
        DENSE_RANK() OVER(partition by gender ORDER BY salary DESC) dense_rank_num
FROM employee_demographics dem
JOIN	employee_salary sal
ON  dem.employee_id= sal.employee_id;


