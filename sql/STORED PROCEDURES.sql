-- STORED PROCEDURES
DROP PROCEDURE  IF EXISTS large_salaries3;
DELIMiTER $$
CREATE PROCEDURE large_salaries3()
BEGIN
SELECT * 
FROM employee_salary
WHERE salary>=50000;
SELECT * 
FROM employee_salary
WHERE salary>=10000;
END $$
DELIMiTER ;

CALL large_salaries3();

DELIMiTER $$
CREATE PROCEDURE large_salaries4(p_employee_id INT)
BEGIN
SELECT salary
FROM employee_salary
WHERE employee_id= p_employee_id;
END $$
DELIMiTER ;

CALL large_salaries4(1);



