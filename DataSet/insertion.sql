alter table GOALS
ADD FOREIGN KEY (Match_ID)
References Matches(Match_ID)

alter table GOALS
ADD FOREIGN KEY (PID)
References Players(PLAYER_ID)

alter table GOALS
ADD FOREIGN KEY (ASSIST)
References Players(PLAYER_ID)

alter table Managers
add foreign key(TEAM_ID)
References Teams(ID)

alter table MATCHES
ADD FOREIGN KEY (HOME_TEAM_ID)
References TEAMS(ID)

alter table MATCHES
ADD FOREIGN KEY (AWAY_TEAM_ID)
References TEAMS(ID)

alter table MATCHES
ADD FOREIGN KEY (STADIUM_ID)
References STADIUMS(ID)

alter table PLAYERS
ADD FOREIGN KEY (TEAM_ID)
References TEAMS(ID)

alter table STADIUMS
ADD FOREIGN KEY (CITY)
References LOCATION(CITY)

alter table Teams
ADD FOREIGN KEY (HOME_STADIUM_ID)
References STADIUMS(ID)