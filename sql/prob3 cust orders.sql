DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    age INT,
    state VARCHAR(100)
);

INSERT INTO customers
(customer_id, customer_name, age, state)
VALUES
(1, 'Ram', 21, 'Jharkhand'),
(2, 'Shyam', 26, 'Bihar'),
(3, 'Raj', 38, 'Jharkhand'),
(4, 'Rahul', 29, 'Jharkhand'),
(5, 'Suresh', 40, 'Jharkhand'),
(6, 'Ramesh', 33, 'West Bengal');

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    customer_id INT,
    order_id INT PRIMARY KEY,
    order_date DATE,
    amount INT
);

INSERT INTO orders
(customer_id, order_id, order_date, amount)
VALUES
(1, 1, '2021-04-19', 569),
(1, 2, '2021-04-24', 3824),
(2, 3, '2021-05-01', 613),
(3, 4, '2021-05-03', 1399),
(3, 5, '2021-05-28', 4391),
(3, 6, '2021-06-04', 2877),
(5, 7, '2021-04-08', 4748),
(6, 8, '2021-03-16', 3352),
(6, 9, '2021-05-04', 2072);

select * from customers;
select * from orders;

-- Query to return customer name and count of orders purchased in april'2021 and may'2021
 
select c.customer_name,case when d.mnth = 4 then 'April' else 'May' end as mnth,d.cnt  from customers c inner join (
select customer_id,mnth,count(distinct order_id) cnt from
(select *, month(order_date) mnth from orders where month(order_date) in (4,5))a
group by customer_id,mnth) d on c.customer_id = d.customer_id;

-- query to return customer names who bought in may'2021 and are from jharkhand

select customer_name from customers where state= 'Jharkhand' and customer_id in (select customer_id from orders where month(order_date)=5);

-- query to get customer name and their latest order info

select customer_name,customer_id,order_id,order_date,amount from(
select b.customer_name,b.customer_id,a.order_id,a.order_date,amount, rank() over(partition by b.customer_id order by a.order_date desc) rnk from orders a inner join customers b on a.customer_id=b.customer_id
)c  where rnk=1;


-- query to get top 2 customer name,id based on transactional value of each month

select customer_name,customer_id,mnth,monthly_spent from (
select b.customer_name,b.customer_id,month(order_date) mnth,sum(amount) monthly_spent,rank() over(partition by month(order_date) order by sum(amount) desc) rnk
 from orders  a inner join customers b on a.customer_id=b.customer_id
 group by b.customer_name,b.customer_id,mnth)c where rnk<3