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