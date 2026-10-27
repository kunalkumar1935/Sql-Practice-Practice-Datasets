-- recommendation system based on - product pairs most commonly purchased together

drop table if exists orders;
create table orders
(
order_id int,
customer_id int,
product_id int
);

insert into orders VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

drop table if exists products;
create table products (
id int,
name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

select concat(pr1.name,' ' ,pr2.name) as pair, count(1) as purchase_frequency from orders o1 
inner join orders o2 on o1.order_id=o2.order_id
inner join products pr1 on pr1.id= o1.product_id
inner join products pr2 on pr2.id=o2.product_id
where o1.product_id<o2.product_id
group by pr1.name,pr2.name;