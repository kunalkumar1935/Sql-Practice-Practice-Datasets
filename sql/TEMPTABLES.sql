-- TEMPORARY TABLES

CREATE TEMPORARY TABLE temp_table
( first_name varchar(50),
  last_name varchar(50),
  favourite_movie varchar(100)
);

SELECT * 
FROM temp_table;

INSERT INTO temp_table
VALUES( 'Kunal', 'Kumar', 'Shutter Island');


CREATE TEMPORARY TABLE salary_over_50k
SELECT* 
FROM employee_salary
WHERE salary>=50000;

select * FROM salary_over_50k;
