

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


 --query 10 the country with max number of players with at least one goal

SELECT top 1 l.country, COUNT(DISTINCT p.PLAYER_ID) AS num_players
FROM players p
JOIN goals g ON p.PLAYER_ID = g.pid
JOIN teams t ON p.team_id = t.ID
JOIN stadiums s ON t.home_stadium_id = s.ID
JOIN location l ON s.city = l.city
GROUP BY l.country
ORDER BY num_players DESC;


--query 11  stadiums with greater left footed shots than right footed

SELECT s.name, s.city, COUNT(CASE WHEN p.foot = 'L' THEN 1 ELSE NULL END) AS num_left_shots,
       COUNT(CASE WHEN p.foot = 'R' THEN 1 ELSE NULL END) AS num_right_shots
FROM stadiums s
JOIN matches m ON s.id = m.stadium_id
JOIN goals g ON m.match_id = g.match_id
JOIN players p ON g.pid = p.PLAYER_ID
GROUP BY s.name, s.city
HAVING COUNT(CASE WHEN p.foot = 'L' THEN 1 ELSE NULL END) > COUNT(CASE WHEN p.foot = 'R' THEN 1 ELSE NULL END);

