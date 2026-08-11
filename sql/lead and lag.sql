CREATE TABLE Train_Schedule (
    Train_Number INT,
    Station VARCHAR(50),
    Arrival_Time TIME
);

INSERT INTO Train_Schedule (Train_Number, Station, Arrival_Time) VALUES
(22863, 'Howrah',      '10:50:00'),
(22863, 'Kharagpur',   '12:30:00'),
(22863, 'Balasore',    '13:52:00'),
(22863, 'Cuttack',     '15:47:00'),
(22863, 'Bhubaneswar', '16:25:00'),

(12262, 'Howrah',      '05:45:00'),
(12262, 'Tatanagar',   '09:00:00'),
(12262, 'Bilaspur',    '15:05:00'),
(12262, 'Raipur',      '16:37:00'),
(12262, 'Nagpur',      '20:55:00');

CREATE TABLE Player_Runs (
    Player VARCHAR(20),
    Year INT,
    Runs INT
);

INSERT INTO Player_Runs (Player, Year, Runs) VALUES
('Virat', 2008, 159),
('Virat', 2009, 325),
('Virat', 2010, 995),
('Virat', 2011, 1381),
('Virat', 2012, 1026),
('Virat', 2013, 1268),
('Virat', 2014, 1054),
('Virat', 2015, 623),
('Virat', 2016, 739),
('Virat', 2017, 1460),
('Virat', 2018, 1202),
('Virat', 2019, 1377),
('Virat', 2020, 431),
('Virat', 2021, 129),
('Virat', 2022, 142),

('Rohit', 2008, 532),
('Rohit', 2009, 102),
('Rohit', 2010, 504),
('Rohit', 2011, 611),
('Rohit', 2012, 168),
('Rohit', 2013, 1196),
('Rohit', 2014, 578),
('Rohit', 2015, 815),
('Rohit', 2016, 564),
('Rohit', 2017, 1293),
('Rohit', 2018, 1030),
('Rohit', 2019, 1490),
('Rohit', 2020, 171),
('Rohit', 2021, 90),
('Rohit', 2022, 78);

SELECT Train_Number,Station,Arrival_Time,
       CONCAT(
           FLOOR(sc / 3600), ' Hours ',
           FLOOR((sc % 3600) / 60), ' Min'
       ) AS time_difference
FROM (
    SELECT *,
           TIMESTAMPDIFF(
               SECOND,
               Arrival_Time,
               LEAD(Arrival_Time) OVER (
                   PARTITION BY Train_Number
                   ORDER BY Arrival_Time
               )
           ) AS sc
    FROM Train_Schedule
) a;

SELECT Train_Number,Station,Arrival_Time,
       CONCAT(
           FLOOR(sc / 3600), ' Hours ',
           FLOOR((sc % 3600) / 60), ' Min'
       ) AS time_elapsed
FROM (
    SELECT *,
           TIMESTAMPDIFF(
               SECOND,
               min(Arrival_Time) OVER (
                   PARTITION BY Train_Number
                   ORDER BY Arrival_Time
               ),`Arrival_time`
           ) AS sc
    FROM Train_Schedule
) a;

select player,sum(runs) runs
 from player_runs
 group by Player;
 
 select player,`year`,runs, 
 (runs/sum(runs) over(partition by player order by `year` rows between unbounded preceding and unbounded following)*100) total_runs_percentage
 from player_runs;
 
 
 select player,count(player)
 from(
  select player,`year`,runs, lag(runs) over(partition by player order by year) prev_year_runs
  from player_runs) pvr
  where runs<  prev_year_runs
  group by player
  ;
  
  select player, sum(more_or_less_runs) from
  (select *, case when prev_year_runs>0  then 1 else 0 end as more_or_less_runs from
   (select player,`year`,runs, lag(runs) over(partition by player order by year) - runs prev_year_runs
  from player_runs) pvr) b
  group by player;
  
  
  -- number of year rohit has scored more than virat 
  select player, count(player) from
 ( select *, case when diff<0 then 1 else 0 end as diff_runs from
 (select *,runs_scored_by_virat - runs diff from(
 select player,year,runs,lead(runs) over(partition by year order by player) runs_scored_by_virat
 from player_runs) a
 where runs_scored_by_virat is not null)b) c
 where diff_runs = 1
 group by player;
 
 -- player runs scored in prev year, next year, count no. of times in which score is increasing for continuously 3 years
 
 select player, sum(inc_runs) cont_inc_runs from
(select *, case when prev_year_runs< runs and runs< next_year_runs then 1 else 0 end as inc_runs from
 (select player, year,runs, 
 lag(runs) over(partition by player order by year) prev_year_runs,
 lead(runs) over(partition by player order by year) next_year_runs
 from player_runs) a)b 
 group by player
 ;
 
 