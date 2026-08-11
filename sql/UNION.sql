SELECT first_name, last_name, 'Old Man' as Label
FROM `employee_demographics`
WHERE age>40 and gender= 'MALE'
UNION
SELECT first_name, last_name, 'Old Lady' as Label
FROM `employee_demographics`
WHERE age>40 and gender= 'FEMALE'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' as Label
FROM `employee_salary`
WHERE salary>70000
ORDER BY first_name, last_name;
