 drop table if exists details;
 CREATE TABLE details(Timing1 TIME, Timing2 TIME); 

 INSERT INTO details(Timing1,Timing2) 
 VALUES('10:50:00','12:30:00'),
 ('12:30:00','13:52:00'),
('05:45:00','09:00:00');

select * from details;


select timing1,timing2, concat(hr, ' HOURS ', minutes, ' MINUTES ', sec, ' SECONDS ') as time_diff from (
select *, 
timestampdiff(second,timing1,timing2) time_diff_sec, 
timestampdiff(second,timing1,timing2) div 3600 hr ,
timestampdiff(second,timing1,timing2)%3600 remaining_sec_for_minutes,
(timestampdiff(second,timing1,timing2)%3600) div 60 minutes,
(timestampdiff(second,timing1,timing2)%3600) % 60 sec 
from details) a;



