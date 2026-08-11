
drop table if exists details;
-- create a table
CREATE TABLE details (
  custid varchar(200),
  orderid integer,
  item varchar(200),
  quantity integer 
);
-- insert some values
INSERT INTO details(custid,orderid,item,quantity) 
values ('c1',1, 'mouse', 2),
('c1',1, 'keyboard', 3),
('c1',1, 'headphone', 5),
('c1',2, 'laptop',1 ),
('c1',2, 'pendrive', 3),
('c2',1, 'tv', 2),
('c2',1, 'washing machine', 2),
('c2',4, 'mobile', 1),
('c2',5, 'earphones',3 );

-- to generate a summary of orders like -> mouse-2,keyboard-3,headphones-5



SELECT custid,
       GROUP_CONCAT(
           CONCAT(item, '-', quantity)
           ORDER BY quantity
           SEPARATOR ','
       ) AS summary
FROM details
GROUP BY custid;

SELECT CONCAT( custid, '-', orderid) AS cust_order,
       GROUP_CONCAT(
           CONCAT(item, '-', quantity)
           ORDER BY quantity
           SEPARATOR ', '
       ) AS summary
FROM details
GROUP BY custid, orderid
ORDER BY custid, orderid;