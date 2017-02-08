-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- create database
drop database if exists tournament;
create database tournament;

-- connect to db:
\c tournament;

--drop tables/ views if exists: 
drop table if exists players cascade;
drop table if exists matches cascade;
drop view if exists players_score cascade;
drop view if exists player1_matches cascade;
drop view if exists player2_matches cascade;
drop view if exists match_agg cascade;
drop view if exists standings cascade;


-- create tables:
create table players (id serial, name text);
create table matches (id serial, player1 int, player2 int, winner int);

-- create views:
create view players_score as 
	select players.id, count(winner) as score
	from players left join matches as sub 
	on players.id = sub.winner 
	group by players.id
	order by score desc;

create view player1_matches as 
	select players.id, count(player1) as count1 
	from (players left join matches 
	on players.id = matches.player1) 
	group by players.id;

create view player2_matches as 
	select players.id, count(player2) as count2 
	from (players left join matches 
	on players.id = matches.player2) 
	group by players.id;

create view match_agg as 
	select player1_matches.id, count1 + count2 as num_matches 
	from (player1_matches full outer join player2_matches 
	on player1_matches.id = player2_matches.id);

create view standings as 
	select players_name_score.id, players_name_score.name, players_name_score.score, match_agg.num_matches
	from (select players_score.id, players.name, players_score.score 
		from players_score left join players  
		on players_score.id = players.id) as players_name_score
	left join match_agg on players_name_score.id = match_agg.id
	order by score desc;



