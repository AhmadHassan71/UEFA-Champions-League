
--query 4


select Teams.TEAM_NAME
from Teams
inner join Stadiums on Teams.HOME_STADIUM_ID=Stadiums.ID
inner join Location on Location.CITY=Stadiums.CITY
inner join Managers on Managers.TEAM_ID=TEAM_ID
where Managers.NATIONALITY=Location.COUNTRY;


--query 5
select Matches.MATCH_ID, Stadiums.NAME,Stadiums.CAPACITY from
Matches
join Stadiums on Matches.STADIUM_ID=Stadiums.ID
where Stadiums.CAPACITY>60000
 order by stadiums.CAPACITY asc;

 --query 

