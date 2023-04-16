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

--q6 All Goals made without an assist in 2020 by players having height greater than 180cm
select Goals.GOAL_ID, Players.LAST_NAME
from goals
join Players on goals.PID = players.PLAYER_ID 
join Matches on Goals.MATCH_ID = Matches.MATCH_ID
where GOALs.ASSIST is null
and Matches.DATE_TIME like '_______20%'
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