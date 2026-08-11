CREATE TABLE Player_Stats (
    Player_Name VARCHAR(10),
    Stadium_Name VARCHAR(30),
    Year INT,
    Runs INT,
    Country VARCHAR(20)
);

INSERT INTO Player_Stats (Player_Name, Stadium_Name, Year, Runs, Country) VALUES
('P1','Eden Gardens',2018,421,'India'),
('P1','Wankhede',2018,450,'India'),
('P2','Eden Gardens',2018,360,'India'),
('P3','Eden Gardens',2018,393,'Eng'),
('P3','Wankhede',2018,324,'Eng'),
('P5','Wankhede',2018,311,'India'),
('P5','Eden Gardens',2018,349,'NZ'),
('P9','Wankhede',2018,229,'NZ'),

('P1','Eden Gardens',2019,469,'India'),
('P4','Wankhede',2019,412,'India'),
('P2','Eden Gardens',2019,89,'India'),
('P3','Eden Gardens',2019,471,'Eng'),
('P7','Wankhede',2019,128,'Eng'),
('P5','Wankhede',2019,234,'India'),
('P9','Eden Gardens',2019,471,'NZ'),
('P9','Wankhede',2019,464,'NZ'),

('P7','Eden Gardens',2021,356,'India'),
('P2','Wankhede',2021,98,'India'),
('P2','Eden Gardens',2021,463,'India'),
('P3','Eden Gardens',2021,273,'Eng'),
('P7','Wankhede',2021,112,'Eng'),
('P5','Wankhede',2021,292,'India'),
('P8','Eden Gardens',2021,154,'NZ'),
('P8','Wankhede',2021,389,'NZ');


select *,
rank() over(partition by `Stadium_name` order by `runs` desc) rnk
 from player_stats where country="india"; 
 
 select *
 from (
 select *,
rank() over(partition by `Stadium_name` order by `runs` desc) rnk
 from player_stats where country="india"
 ) as a
 where a.rnk=1;
 
 with cte as(
 select *,
rank() over(partition by `Stadium_name` order by `runs` desc) rnk
 from player_stats where country="india") 
 select * from cte where rnk=1;
 
  select * from (select *,
rank() over(partition by `Stadium_name`,`year` order by `runs` desc) rnk
 from player_stats where country="india") a
 where a.rnk=1;
 
 select * ,first_value(`player_name`) over(partition by `stadium_name` order by `runs` desc) highest_runs_scored,
 last_value(`player_name`) over(partition by `stadium_name` order by `runs` desc rows between unbounded preceding and unbounded following) lowest_runs_scored
 from player_stats where country="india";
 
 select * ,first_value(`runs`) over(partition by `stadium_name` order by `runs` desc) - `runs` diff_runs
 from player_stats where country="india";
 
 select * ,first_value(`runs`) over(partition by `stadium_name`,`year` order by `runs` desc) - `runs` diff_runs
 from player_stats where country="india";