/* Final Project Internshala training : Sport Analysis */

select * from matches;
select * from deliveries;


/* Q.1 Create a table named ‘matches’ with appropriate data types for columns */

create table matches
	( id int,
	  city varchar,
	  date date,
	  player_of_match varchar,
	 venue varchar,
	 neutral_venue int,
	 team1 varchar,
	 team2 varchar,
	 toss_winnner varchar,
	 toss_decision varchar,
	 winner varchar,
	 result varchar,
	 result_margin int,
	 eliminator varchar,
	 method varchar,
	 umpire1 varchar,
	 umpire2 varchar
	  
	);


/* Q.2 Create a table named ‘deliveries’ with appropriate data types for columns */

create table deliveries
	( id int,
	  inning int,
	  over int,
	  ball int,
	 batsman varchar,
	 non_striker varchar,
	 bowler varchar,
	 batsman_runs int,
	 extra_runs int,
	 total_run int,
	 is_wicket int,
	 dismissal_kind varchar,
	 player_dismissed varchar,
	 fielder varchar,
	 extras_type varchar,
	 batting_team varchar,
	 bowling_team varchar
	);




/* Q.3 Import data from csv file ’IPL_matches.csv’ attached in resources to the table ‘matches’ which was created in Q1 */

copy matches
	( id,
	  city ,
	  date ,
	  player_of_match,
	 venue,
	 neutral_venue,
	 team1,
	 team2,
	 toss_winnner,
	 toss_decision,
	 winner,
	 result,
	 result_margin,
	 eliminator,
	 method,
	 umpire1,
	 umpire2)

from 'E:\pgAdmin_SQL\data\Data_Copy\Data\Final_project\IPL_matches.csv' delimiter ',' csv header ;



/* Q.4 Import data from csv file ’IPL_Ball.csv’ attached in resources to the table ‘deliveries’ which was created in Q2 */

copy deliveries
	( id,
	  inning,
	  over,
	  ball,
	 batsman,
	 non_striker,
	 bowler,
	 batsman_runs,
	 extra_runs,
	 total_run,
	 is_wicket,
	 dismissal_kind,
	 player_dismissed,
	 fielder,
	 extras_type,
	 batting_team,
	 bowling_team
	)

from 'E:\pgAdmin_SQL\data\Data_Copy\Data\Final_project\IPL_Ball.csv' delimiter ',' csv header ;


/* Q.5 Select the top 20 rows of the deliveries table after ordering them by id, inning, over, ball in ascending order.*/

select * from deliveries 
order by id asc, inning asc, over asc, ball asc
limit 20;


/* Q.6 Select the top 20 rows of the matches table.*/

select * from matches
order by date asc
limit 20;


/* Q.7 Fetch data of all the matches played on 2nd May 2013 from the matches table..*/

select * from matches
where date='2013-05-02';

/* Q.8 Fetch data of all the matches where the result mode is ‘runs’ and
margin of victory is more than 100 runs.*/

select * from matches
where result='runs' and result_margin >100;


/* Q.9 Fetch data of all the matches where the final scores of both teams tied and order it in descending order of the date.*/

select * from matches
where result='tie'
order by date desc;

select * from matches
where result='tie' and date = '2020-10-18'
order by date desc;

/* Q.10 Get the count of cities that have hosted an IPL match.*/

select count(distinct city) from matches;
select distinct city from matches;


/* Q.11 Create table deliveries_v02 with all the columns of the table ‘deliveries’ and 
an additional column ball_result containing values boundary, 
dot or other depending on the total_run (boundary for >= 4, dot for 0 and other for any other number)
(Hint 1 : CASE WHEN statement is used to get condition based results)
(Hint 2: To convert the output data of select statement into a table, you can use a subquery.
Create table table_name as [entire select statement]. */


select * from deliveries_v02;

create table deliveries_v02 
as (select * from deliveries) ;

alter table deliveries_v02
add ball_result varchar;
		
			
/*
-- exctracting data as ball_result, but dont know how to add in column!!

select case when total_run>=4 then 'boundary'
		when total_run=0 then 'dot'
		else 'other'
		end as ball_result 
		from deliveries_v02;
*/

--used update and set method to add values in column ball_result

update deliveries_v02 
set ball_result='boundary'
where total_run between 4 and 6;

update deliveries_v02 
set ball_result='dot'
where total_run=0;

update deliveries_v02 
set ball_result='other'
where total_run between 1 and 3;



/* Q.12 Write a query to fetch the total number of boundaries and
dot balls from the deliveries_v02 table. */


select ball_result, count(ball_result) from deliveries_v02
group by ball_result;



/* Q.13 Write a query to fetch the total number of boundaries scored by each team from
the deliveries_v02 table and order it in descending order of the number of boundaries scored. */

select batting_team , count(ball_result) as no_of_boundaries from deliveries_v02 
where ball_result = 'boundary'
group by batting_team
order by count(ball_result) desc;

/* Q.14 Write a query to fetch the total number of dot balls bowled by each team and 
order it in descending order of the total number of dot balls bowled. */

select bowling_team , count(ball_result) as total_dot_ball from deliveries_v02 
where ball_result = 'dot'
group by bowling_team
order by count(ball_result) desc;

/* Q.15 Write a query to fetch the total number of dismissals by dismissal kinds 
where dismissal kind is not NA */

Select dismissal_kind , count(dismissal_kind) from deliveries_v02
group by dismissal_kind
order by count(dismissal_kind) desc;


/* Q.16 Write a query to get the top 5 bowlers who conceded maximum extra runs from the deliveries table */

select  * from deliveries;
select bowler , sum(extra_runs) as Extra_runs from deliveries
group by bowler
order by Extra_runs desc
limit 5;


/* Q.17 Write a query to create a table named deliveries_v03 with all the columns of deliveries_v02 table and 
two additional column (named venue and match_date) of venue and date from table matches */

select * from deliveries_v03;

create table deliveries_v03;

select a.* 
		a.id
		b.venue
		b.match_date
from deliveries_v02 as a
left join matches as b
on a.id = b.id
order by a.id desc;


/* Q.18 Write a query to fetch the total runs scored for each venue and
order it in the descending order of total runs scored. */

select * from deliveries_v03;


select venue, sum(total_run) from deliveries_v03
group by venue 
order by sum(total_run) desc;


/* Q.19 Write a query to fetch the year-wise total runs scored at Eden Gardens and 
order it in the descending order of total runs scored. */

select extract(year from match_date) as match_year, sum(total_run) from deliveries_v03
where venue = 'Eden Gardens'
group by match_year
order by sum(total_run) desc;




/* Q.20 Get unique team1 names from the matches table, you will notice that there are two 
entries for Rising Pune Supergiant one with Rising Pune Supergiant and another one with Rising Pune Supergiants. 
Your task is to create a matches_corrected table with two additional columns team1_corr and 
team2_corr containing team names with replacing Rising Pune Supergiants with Rising Pune Supergiant. Now analyse these newly created columns.*/

select distinct (team1) from matches_corrected;
select distinct (team2) from matches_corrected;
select distinct (team1_corr) from matches_corrected;
select distinct (team2_corr) from matches_corrected;



select * from matches_corrected;


update  matches_corrected
set team1_corr = 'Rising Pune Supergiant'
where team1 = 'Rising Pune Supergiants';



update  matches_corrected
set team2_corr = 'Rising Pune Supergiant'
where team2 = 'Rising Pune Supergiants';




/* Q.21 Create a new table deliveries_v04 with the first column as ball_id containing information 
of match_id, inning, over and ball separated by ‘-’ 
(For ex. 335982-1-0-1 match_id-inning-over-ball) and rest of the columns same as deliveries_v03) */


select * from deliveries_v03;


create table deliveries_v04 as (select * from deliveries_v03);

select * from deliveries_v04;

alter table deliveries_v04 
add ball_id varchar; 

update deliveries_v04 
set ball_id = id||'-'||inning||'-'||over||'-'||ball;


/* Q.22 Compare the total count of rows and total count of distinct ball_id in deliveries_v04; */

select  count(*) as total_rows,count(distinct (ball_id)) as total_distinct_ball_id from deliveries_v04;

/* Q.23 SQL Row_Number() function is used to sort and assign row numbers to data rows in the presence of 
multiple groups. For example, to identify the top 10 rows which have the highest order amount in each region,
we can use row_number to assign row numbers in each group (region) with any particular 
order (decreasing order of order amount) and then we can use this new column to apply filters. 
Using this knowledge, solve the following exercise. You can use hints to create an additional column of row number.
Create table deliveries_v05 with all columns of deliveries_v04 and an additional column for
row number partition over ball_id. (HINT : Syntax to add along with other columns,  row_number() over (partition by ball_id) as r_num) */

create table deliveries_v05 as 
(select *, row_number() over (partition by ball_id) as r_num from deliveries_v04);

select * from deliveries_v05;

/* Q.24 Use the r_num created in deliveries_v05 to identify instances where ball_id is repeating. 
(HINT : select * from deliveries_v05 WHERE r_num=2;) */ 


select * from deliveries_v05 WHERE r_num=2;


/* Q.25 Use subqueries to fetch data of all the ball_id which are repeating. 
(HINT: SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2); */



SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2);

