drop table if exists cab;
CREATE TABLE cab(id integer,state VARCHAR(200),city varchar(200),seater integer,charge integer); 

INSERT INTO cab(id,state,city,seater,charge) 
 VALUES(1,'Jharkhand','Jamshedpur',4,3000),
(2,'Bihar','Purnea',3,2250),
(3,'Jharkhand','Jamshedpur',4,3000),
(4,'West Bengal','Kolkata',2,1750),
(5,'West Bengal','Siliguri',4,3500),
(6,'Jharkhand','Ranchi',4,3000),
(7,'Bihar','Sasaram',3,2100);

drop table if exists customers;
CREATE TABLE customers(id integer,namee VARCHAR(200),from_state VARCHAR(200),min_seater integer,min_rent integer,max_rent integer); 

INSERT INTO customers(id,namee,from_State,min_seater,min_rent,max_rent) 
VALUES(1,'Ram','Jharkhand',3,2500,3200),
(2,'Shyam','West Bengal',2,1500,2500),
(3,'Suresh','West Bengal',4,2500,4000),
(4,'Mahesh','Bihar',3,2200,2500),
(5,'Raj','Bihar',3,1800,2300);

drop table if exists order_details;
CREATE TABLE order_details(id integer,date date,cust_id integer,cab_id integer); 

INSERT INTO order_details(id,date,cust_id,cab_id) 
 VALUES (1,'2022-07-05',1,1),
(2,'2022-07-04',2,4),
(3,'2022-07-03',3,5),
(4,'2022-07-02',4,2);

select * from cab;
select * from customers;
select * from order_details;

-- cab service details, no two cab have same price from same city, customers from same state can travel together
-- Destination: Bhubhaneswas

-- 1. Possible customers pairs who can travel together irrespective of rent 
select a.namee, a.id, b.namee, b.id
 from customers a 
 join
	  customers b 
	on a.from_state = b.from_state
 and a.id < b.id;
 
-- 2. Remove duplicated (diff id , same address and same charge)

delete from cab where id in ( select id from (
select b.id
from cab a
 join 
     cab b
 on a.city = b.city and a.charge=b.charge and a.id<b.id) c );
 
 -- 3. List other cabs that can be suggested to customers as alternative (customers from same state can travel together) The cabs should be
 
-- a) in their preferred state
-- b) withing their price range
-- c) with their required no. of seats
-- d) not occupied ( not in order table)

select a.id cust_id , a.namee cust_name, b.id cab_id, b.state, b.city, b.seater, b.charge
from customers a 
join
cab b
on a.from_state=b.state
and b.charge between a.min_rent and a.max_rent
and b.seater >= a.min_seater
and b.id not in (
select distinct cab_id from order_details);

-- 4. Running sum

select c.date, c.charge, sum(d.charge) running_sum from
(select a.date,b.charge from order_details a inner join cab b on a.cab_id=b.id) c
join 
(select a.date,b.charge from order_details a inner join cab b on a.cab_id=b.id) d
on c.date>=d.date
group by c.date,c.charge
order by c.date;
 
SELECT c.id,
       c.date,
       c.charge,
       SUM(d.charge) AS running_sum
FROM
(
    SELECT od.id,
           od.date,
           c.charge
    FROM order_details od
    JOIN cab c
      ON od.cab_id = c.id
) c
JOIN
(
    SELECT od.id,
           od.date,
           c.charge
    FROM order_details od
    JOIN cab c
      ON od.cab_id = c.id
) d
ON c.date > d.date
   OR (c.date = d.date AND c.id >= d.id)
GROUP BY c.id, c.date, c.charge
ORDER BY c.date, c.id;
 
-- 4. We want to list all cabs from our database together with the date of the corresponsding deal if it happened. we also want to consider only those deals that took place on or after 03-07-2022

select a.id cab_id, a.city, b.date 
from cab a 
left join
order_details b
on a.id=b.cab_id
and b.date in ('2022-07-05','2022-07-03','2022-07-04');