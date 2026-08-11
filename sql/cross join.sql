-- Joining without having any common columns

drop table if exists department;
CREATE TABLE department(Name VARCHAR(200)); 

 INSERT INTO department(Name) 
 VALUES('Engineering'),
('Marketing'),
('Legal'),
('Finance'),
('HR');

drop table if exists shift;
CREATE TABLE shift(Id VARCHAR(200)); 

 INSERT INTO shift(Id) 
 VALUES('Day'),
('AfterNoon'),
('Night');


drop table if exists country;
CREATE TABLE country(country_Name VARCHAR(200)); 

 INSERT INTO country(country_Name) 
 VALUES('India'),
('US');

select * from department;
select * from shift;
select * from country;

select d. * , case when d.id= "day" then "7:00 a.m. to 3:00 p.m." when d.id= "afternoon" then "3:00 p.m. to 11:00 p.m.
" else "11:00 p.m to 7:00 a.m." end as shift_time from
( select a. *, b. *, c. * from department a , shift b, country c) d;

drop table if exists employee;
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    managerId INT
);

INSERT INTO Employee (id, name, salary, managerId) VALUES
(1, 'Joe', 70000, 3),
(2, 'Henry', 80000, 4),
(3, 'Sam', 60000, NULL),
(4, 'Max', 90000, NULL);

-- Employee that earns more than their manager
select b.name as Employee from employee a, employee b where a.id=b.managerid and b.salary>a.salary;

