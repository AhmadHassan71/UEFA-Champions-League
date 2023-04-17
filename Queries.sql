-- q1 All players that have played under Julian Nagelsman

select Players.LAST_NAME as Players_Nagelsmann
from Teams
inner join Players on Teams.ID=Players.TEAM_ID
inner join Managers on Managers.TEAM_ID =Teams.ID
where Managers.FIRST_NAME='Julian' and Managers.LAST_NAME='Nagelsmann'

--q2 All mathches that have been played in Spain
select Matches.MATCH_ID as Matches_IN_SPAIN,Teams.TEAM_NAME as AWAY_TEAM,Location.CITY
from Matches
inner join Stadiums on Stadiums.ID=Matches.STADIUM_ID
inner join Teams on  Teams.ID =Matches.AWAY_TEAM_ID
inner join Location on Stadiums.CITY =location.CITY
where Location.COUNTRY='Spain'

--q3 All teams that have won more than 3 games
select Teams.TEAM_NAME as Wins_Greaterthan_3
from Matches
inner join Teams on  Teams.ID =Matches.HOME_TEAM_ID
where HOME_TEAM_SCORE>AWAY_TEAM_SCORE
group by HOME_TEAM_ID,Teams.TEAM_NAME
having count(*)>3

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


--q6 All Goals made without an assist in 2020 by players having height greater than 180cm
select Goals.GOAL_ID, Players.LAST_NAME
from goals
join Players on goals.PID = players.PLAYER_ID 
join Matches on Goals.MATCH_ID = Matches.MATCH_ID
where GOALs.ASSIST is null
and Matches.DATE_TIME like '_______20%'
--and YEAR(Matches.DATE_TIME) = 2020
and players.HEIGHT>180

--q7
select home.TEAM_NAME as Teams_l50, count(*) as total_matches,SUM(CASE WHEN homeL.COUNTRY = 'Russia' 
AND Matches.HOME_TEAM_SCORE > Matches.AWAY_TEAM_SCORE THEN 1 WHEN awayL.COUNTRY = 'Russia' AND
AWAY_TEAM_SCORE > HOME_TEAM_SCORE THEN 1 ELSE 0 END) as total_wins
from Matches
inner join Teams as home on  home.ID =Matches.HOME_TEAM_ID
inner join Teams as away on away.ID =Matches.AWAY_TEAM_SCORE
inner join Stadiums as homeS on home.HOME_STADIUM_ID=homeS.ID
inner join Stadiums as awayS on away.HOME_STADIUM_ID=awayS.ID
inner join Location as homeL on homeS.CITY = homeL.CITY
inner join Location as awayL on awayS.CITY = awayL.CITY
where homeL.COUNTRY='Russia'
group by HOME_TEAM_ID,home.TEAM_NAME
HAVING (ROUND((SUM(CASE WHEN homeL.COUNTRY = 'Russia' AND Matches.HOME_TEAM_SCORE > Matches.AWAY_TEAM_SCORE THEN 1 
	WHEN awayL.COUNTRY = 'Russia' AND AWAY_TEAM_SCORE > HOME_TEAM_SCORE THEN 1 
    ELSE 0 END) / CAST(COUNT(*) AS FLOAT)) * 100, 2) < 50);

--q8

select s.NAME as stadium_wrl50, SUM(case when home.ID =Matches.HOME_TEAM_ID and HOME_TEAM_SCORE>AWAY_TEAM_SCORE then 1
	when AWAY_TEAM_ID=Matches.AWAY_TEAM_ID and AWAY_TEAM_SCORE>HOME_TEAM_SCORE then 1
	else 0 END) as total_matches_won
from Matches
join Teams as home on home.ID =HOME_TEAM_ID
join Teams as away on away.ID = AWAY_TEAM_ID
join Stadiums as s on s.ID = home.ID
where s.ID in (select STADIUM_ID from Matches group by STADIUM_ID having count(*)>6)
group by STADIUM_ID,s.NAME
having (round((SUM(case when home.ID =Matches.HOME_TEAM_ID and HOME_TEAM_SCORE>AWAY_TEAM_SCORE then 1
	when AWAY_TEAM_ID=Matches.AWAY_TEAM_ID and AWAY_TEAM_SCORE>HOME_TEAM_SCORE then 1
	else 0 END)/count(*))*100,2)<50);

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


--q11 stadium having more left footed shots than right footed shots
select Stadiums.NAME, COUNT(case when Goals.GOAL_DESC='left-footed shot' then 1 END) as left_footed_shots, COUNT(case when Goals.GOAL_DESC='right-footed shot' then 1 END) as right_footed_shots
from Stadiums
join Matches on Matches.STADIUM_ID=stadiums.ID
join Goals on Matches.MATCH_ID=Goals.MATCH_ID
Group by Stadiums.NAME
having   COUNT(case when Goals.GOAL_DESC='left-footed shot' then 1 END)>COUNT(case when Goals.GOAL_DESC='right-footed shot' then 1 END)



--q12 All matches that were played in country with maximum cumulative stadium seating capacity order by recent first.

select Matches.MATCH_ID, Matches.DATE_TIME,Stadiums.NAME,Location.COUNTRY,SUM(Stadiums.CAPACITY) as total_capacity
from Matches
join Stadiums on Matches.STADIUM_ID=Stadiums.ID
join Location on Stadiums.CITY = Location.CITY
group by Location.COUNTRY,Matches.MATCH_ID,Matches.DATE_TIME,Stadiums.NAME,Stadiums.CAPACITY
having SUM(Stadiums.CAPACITY) =(
	select top 1(Stadiums.CAPACITY)
	from (
		select SUM(Stadiums.CAPACITY) as total_capacity
		from Stadiums
		Join Location on STADIUMs.CITY=Location.CITY
		group by Location.COUNTRY
		) as commulative_capacity
		order by total_capacity desc
		)
order by Matches.DATE_TIME desc
--order by CONVERT(DATETIME, matches.DATE_TIME, 113) desc


--query 13 player duo with greatest number of goal assist combo

SELECT  p1.first_name, p1.last_name, p1.DOB,p1.NATIONALITY, p2.first_name, p2.last_name, p2.DOB, p2.NATIONALITY, COUNT(*) as num_combinations
FROM goals g1
JOIN players p1 ON g1.pid = p1.PLAYER_ID
JOIN goals g2 ON g1.match_id = g2.match_id AND g1.pid != g2.pid
JOIN players p2 ON g2.pid = p2.PLAYER_ID
WHERE g1.assist = p2.PLAYER_ID AND g2.assist = p1.PLAYER_ID
GROUP BY  p1.first_name, p1.last_name, p1.DOB,p1.NATIONALITY, p2.first_name, p2.last_name, p2.DOB, p2.NATIONALITY
ORDER BY num_combinations DESC

--query 14 team having more header percentage

SELECT t.ID,t.TEAM_NAME, AVG(CASE WHEN g.goal_desc = 'header' THEN 1 ELSE 0 END) AS header_goal_percentage
FROM teams t
INNER JOIN players p ON t.ID = p.team_id
INNER JOIN goals g ON p.PLAYER_ID = g.pid
INNER JOIN matches m ON g.match_id = m.match_id
WHERE m.season = '2020-2021'
GROUP BY t.ID, t.TEAM_NAME, g.GOAL_DESC
HAVING COUNT(CASE WHEN g.goal_desc = 'header' THEN 1 ELSE NULL END) > 5
ORDER BY header_goal_percentage asc;



--query 15 most successfull manager


SELECT top 1 m.first_name, m.last_name, ma.SEASON, COUNT(*) AS total_wins
FROM matches ma
JOIN managers m ON ma.home_team_id = m.team_id OR ma.away_team_id = m.team_id
WHERE ma.season BETWEEN '2016' AND '2022' AND ma.home_team_score != ma.away_team_score
GROUP BY m.first_name, m.last_name, ma.SEASON
ORDER BY total_wins DESC


--query 16 most successful teams per season
SELECT m.season, t.team_name AS winner, max_score
FROM matches m
JOIN (
    SELECT season, MAX(score) AS max_score
    FROM (
        SELECT season, home_team_score AS score
        FROM matches
        UNION ALL
        SELECT season, away_team_score AS score
        FROM matches
    ) AS scores
    GROUP BY season
) AS max_scores
ON m.season = max_scores.season AND (m.home_team_score = max_scores.max_score OR m.away_team_score = max_scores.max_score)
JOIN teams t ON (m.home_team_id = t.ID OR m.away_team_id = t.ID)
GROUP BY m.season, t.team_name, max_score
ORDER BY m.season;
