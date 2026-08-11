-- CASE STATEMENTS

SELECT first_name,last_name,age,
CASE 
	WHEN age <=30 THEN 'young'
    WHEN age BETWEEN 31 and 50 THEN 'old'
    WHEN age >= 50 THEN "One foot in grave"
END AS 'age group'
FROM `employee_demographics`;

-- PAY INCREASE AND BONUS
-- <50000 = 5%
-- >50000 = 7%
-- Finance = 10%

SELECT first_name, last_name, salary,
CASE
	WHEN salary<50000 THEN salary * 1.05
    WHEN salary>50000 THEN salary * 0.07
    
END AS "Raise",

CASE 
	WHEN dept_id=6 THEN salary *0.1
END AS "BONUS"
FROM `employee_salary`