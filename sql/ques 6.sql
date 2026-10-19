/* Write a query to find PersonID, Name, number of friends,
   and sum of marks of persons who have friends with total score greater than 100. */


with friend_score as (
select f.personid,count(1) number_of_friends,sum(p.score) as total_friend_score from `friend.xls - friend` f
inner join `person.xls - person` p 
on f.friendid=p.personid
group by f.personid)

select pp.personid,name,number_of_friends,score, total_friend_score  from `person.xls - person` pp inner join friend_score ff on pp.PersonID = ff.personid
where ff.total_friend_score>100;