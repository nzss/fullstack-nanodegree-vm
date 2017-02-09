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
drop view if exists winner_matches cascade;
drop view if exists loser_matches cascade;
drop view if exists match_agg cascade;
drop view if exists standings cascade;


-- create tables:
create table players (id serial primary key, name text);
create table matches (id serial, winner int references players(id), loser int references players(id));

-- create views:
create view players_score as 
	select players.id, count(winner) as score
	from players left join matches as sub 
	on players.id = sub.winner 
	group by players.id
	order by score desc;

create view winner_matches as 
	select players.id, count(winner) as count1 
	from (players left join matches 
	on players.id = matches.winner) 
	group by players.id;

create view loser_matches as 
	select players.id, count(loser) as count2 
	from (players left join matches 
	on players.id = matches.loser) 
	group by players.id;

create view match_agg as 
	select winner_matches.id, count1 + count2 as num_matches 
	from (winner_matches full outer join loser_matches 
	on winner_matches.id = loser_matches.id);

create view standings as 
	select players_name_score.id, players_name_score.name, players_name_score.score, match_agg.num_matches
	from (select players_score.id, players.name, players_score.score 
		from players_score left join players  
		on players_score.id = players.id) as players_name_score
	left join match_agg on players_name_score.id = match_agg.id
	order by score desc;



