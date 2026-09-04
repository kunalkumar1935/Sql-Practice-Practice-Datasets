DROP TABLE IF EXISTS users;

CREATE TABLE users (
    users_id INT PRIMARY KEY,
    banned ENUM('Yes', 'No'),
    role ENUM('client', 'driver')
);

INSERT INTO users (users_id, banned, role)
VALUES
(1, 'No', 'client'),
(2, 'Yes', 'client'),
(3, 'No', 'client'),
(4, 'No', 'client'),
(10, 'No', 'driver'),
(11, 'No', 'driver'),
(12, 'No', 'driver'),
(13, 'No', 'driver');

DROP TABLE IF EXISTS trips;

CREATE TABLE trips (
    id INT PRIMARY KEY,
    client_id INT,
    driver_id INT,
    city_id INT,
    status ENUM(
        'completed',
        'cancelled_by_driver',
        'cancelled_by_client'
    ),
    request_at DATE
);

INSERT INTO trips
(id, client_id, driver_id, city_id, status, request_at)
VALUES
(1, 1, 10, 1, 'completed', '2013-10-01'),
(2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'),
(3, 3, 12, 6, 'completed', '2013-10-01'),
(4, 4, 13, 6, 'cancelled_by_client', '2013-10-01'),

(5, 1, 10, 1, 'completed', '2013-10-02'),
(6, 2, 11, 6, 'completed', '2013-10-02'),
(7, 3, 12, 6, 'completed', '2013-10-02'),

(8, 2, 12, 12, 'completed', '2013-10-03'),
(9, 3, 10, 12, 'completed', '2013-10-03'),
(10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03');

SELECT * FROM users;
SELECT * FROM trips;

select h.request_at Day, round(sum(case when h.status='completed' then 0 else 1 end)/count(*)*1.0,2) `Cancellation Rate` from 
(select d.*, c.banned driverban, c.role driverrole from
(select a.client_id,a.driver_id,a.status,a.request_at,b.banned clientban,
b.role clientrole from 
trips a inner join users b on a.client_id=b.users_id) d
inner join users c on c.users_id=d.driver_id
where c.banned='No' and d.clientban='No')h
group by request_at;