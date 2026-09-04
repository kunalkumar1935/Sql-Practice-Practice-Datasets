drop table if exists table1;
create table table1(id integer);

insert into table1(id)
values(1),(1),(2),(3),(4),(3),(null),(null);

drop table if exists table2;
create table table2(id integer);

insert into table2(id)
values(1),(2),(3),(2),(6),(null);

-- inner

select * from table1 inner join table2 on table1.id=table2.id;

-- left

select * from table1 left join table2 on table1.id=table2.id;

-- right

select * from table1 right join table2 on table1.id=table2.id;

-- full outer (simulate using union)

SELECT t1.id AS id1, t2.id AS id2
FROM table1 t1
LEFT JOIN table2 t2
    ON t1.id = t2.id

UNION ALL

SELECT t1.id AS id1, t2.id AS id2
FROM table1 t1
RIGHT JOIN table2 t2
    ON t1.id = t2.id
WHERE t1.id IS NULL;

-- bonus


select * from table1 inner join table2 on table1.id=1;