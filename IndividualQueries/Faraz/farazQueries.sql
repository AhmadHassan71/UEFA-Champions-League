

--query 4 teams with foreign managers


select Teams.TEAM_NAME, teams.ID, concat(Managers.FIRST_NAME, ' ' ,Managers.LAST_NAME) AS ManagerName, Managers.NATIONALITY
from Teams
inner join Stadiums on Teams.HOME_STADIUM_ID=Stadiums.ID
inner join Location on Location.CITY=Stadiums.CITY
inner join Managers on Managers.TEAM_ID=TEAM_ID
where Managers.NATIONALITY!=Location.COUNTRY and Managers.TEAM_ID= teams.ID;

--query 5 stadiums having capacity greater than 60,000
 
select Matches.MATCH_ID, Stadiums.NAME,Stadiums.CAPACITY from
Matches
join Stadiums on Matches.STADIUM_ID=Stadiums.ID
where Stadiums.CAPACITY>60000
 order by stadiums.CAPACITY asc;

 --query 9 season with greatest number of left foot goals


 select top 1 Matches.SEASON, count ( goals.GOAL_ID) as leftFootedGoals  
 from Matches
 inner join Goals on Matches.MATCH_ID=Goals.MATCH_ID
 where GOAL_DESC='left-footed shot'
 group by Matches.SEASON 
 order by leftFootedGoals desc;


 --query 10
