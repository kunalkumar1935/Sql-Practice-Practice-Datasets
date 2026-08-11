drop table if exists ipls;

create table ipls 
(
id	float,
inning	float,
overr	float,
ball	float,
batsman	nvarchar(255),
non_striker	nvarchar(255),
bowler	nvarchar(255),
batsman_runs	float,
extra_runs	float,
total_runs	float,
non_boundary	float,
is_wicket	float,
dismissal_kind	nvarchar(255),
player_dismissed	nvarchar(255),
fielder	nvarchar(255),
extras_type	nvarchar(255),
batting_team	nvarchar(255),
bowling_team nvarchar(255)
);

select * from ipls;
select * from ipl_matches;

update ipl_matches
set `date` = str_to_date(`date`,'%d-%m-%Y');

-- no. of matches played per season (assuming only one season in a year)
select yr,count(id) number_of_matches from (
select year(`date`) yr, id from ipl_matches)a
group by yr
;

-- most player of match

select player_of_match,count(player_of_match) mom from ipl_matches group by player_of_match order by count(player_of_match) desc;

-- most player of match/season

select * from(
select player_of_match,yr,mom,rank() over(partition by yr order by mom desc) rnk from(
select player_of_match,year(date) yr,count(player_of_match) mom from ipl_matches group by player_of_match,yr order by count(player_of_match) desc) a) b
where rnk=1;

-- most wins by any team 

select winner, count(winner) from ipl_matches group by winner order by count(winner) desc;

-- top 5 venues

select * from (
select *, rank() over(order by cnt desc) rnk from (
select venue, count(venue) cnt from ipl_matches group by venue order by count(venue) desc ) a 
) b where rnk<=5
;

select venue, count(venue) cnt from ipl_matches group by venue order by count(venue) desc limit 5; 

-- most runs by any batsman

select batsman,sum(total_runs) from ipls group by batsman order by sum(total_runs) desc limit 1;

-- percentage of total runs scored by each batsman

select *, total_runs/sum(total_runs) over(order by total_runs desc rows between unbounded preceding and unbounded following ) * 100 as percentage_of_runs from(
select batsman,sum(total_runs) total_runs from ipls group by batsman  )a ;

-- most sixes by any batsman

select batsman, count(batsman) no_of_sixes from
(select * from ipls where batsman_runs=6)a
group by batsman
order by count(batsman) desc
limit 1;

-- most fours

select batsman, count(batsman) no_of_fours from
(select * from ipls where batsman_runs=4  and total_runs-batsman_runs=0)a
group by batsman
order by count(batsman) desc
limit 1;

-- 3000 runs club and highest strike rate

select batsman,batsman_runs, strike_rate from
(select batsman,batsman_runs,(batsman_runs/no_of_balls)*100 strike_rate from
(select batsman,sum(batsman_runs) batsman_runs,count(batsman) no_of_balls from ipls group by batsman  )a )b
where batsman_runs>=3000
order by strike_rate desc 
limit 1;

-- lowest economy rate for the bowler who has bowled for atleast 50 overs

select bowler, total_runs_conceded/(total_bowls/6) economy_rate from
(select bowler,count(bowler) total_bowls, sum(total_runs) total_runs_conceded
from ipls 
group by bowler)a
where total_bowls>300
order by economy_rate
limit 1;

-- total matches till 2020

select count(distinct id) from ipl_matches;

-- total number of matches win by each team

select winner,count(winner) matches_won from ipl_matches group by winner;


