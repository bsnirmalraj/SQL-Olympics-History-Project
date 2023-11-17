--120 Years of Olympics History- BY B.S.NIRMAL_RAJ-----


--1) How many Olympics games have been held?

SELECT 
COUNT(DISTINCT games) AS Total_Olympic_Games
FROM Olympic_History;

--2) List down all Olympics game held so far.

SELECT 
DISTINCT games,
season,
city
FROM olympic_history;

--3) Mention the total no of nations who participated in each Olympics game?

SELECT 
year, 
season,
COUNT (DISTINCT noc) AS Total_no_of_nations
FROM olympic_history
GROUP BY 1,2;

--4) Which year saw the highest no of countries participating in Olympics?

SELECT 
year,
season,
COUNT (DISTINCT noc) AS Countries_List_Highest
FROM olympic_history
GROUP BY 1,2
ORDER BY 3 DESC;

--5) Which year saw the lowest no of countries participating in Olympics?

SELECT 
year,
season,
COUNT (DISTINCT noc) AS Countries_List_Lowest
FROM olympic_history
GROUP BY 1,2
ORDER BY 3 ASC;

--6) Which nation has participated in all of the Olympic game?

WITH tot_games AS
    (SELECT COUNT(DISTINCT games) AS total_games
     FROM olympic_history),
 
countries AS
    (SELECT 
        games, 
        nr.region AS country
     FROM olympic_history oh
     JOIN olympic_history_noc_regions nr 
	 ON nr.noc = oh.noc
     GROUP BY games, nr.region),

countries_participated AS
    (SELECT 
        country, 
        COUNT(1) AS total_participated_games
     FROM countries
     GROUP BY country)
     
SELECT cp.*
FROM countries_participated cp
JOIN tot_games tg 
ON tg.total_games = cp.total_participated_games
ORDER BY 1;

--7) Identify the sport which was played in all summer Olympics? 

SELECT sport 
FROM olympic_history
WHERE season = 'Summer'
GROUP BY sport
HAVING COUNT(DISTINCT year) = (SELECT COUNT(DISTINCT year) 
FROM olympic_history 
WHERE season = 'Summer');

--8) Fetch the total no of sports played in each Olympic game.

SELECT
DISTINCT games,
COUNT(DISTINCT sport) AS Total_Sport
FROM olympic_history
GROUP BY 1
ORDER BY 2 DESC;

--9) Fetch details of the oldest athletes to win a gold medal.

WITH Athletes AS (
SELECT 
*,
DENSE_RANK()OVER (ORDER BY age DESC) AS Oldest_Athletes
FROM olympic_history
WHERE medal = 'Gold' AND age <> 'NA')

SELECT *
FROM Athletes
WHERE Oldest_Athletes = 1

--10) Fetch details of the youngest athletes to win a gold medal.

WITH Athletes AS (
SELECT 
*,
DENSE_RANK()OVER (ORDER BY age ASC) AS Youngest_Athletes
FROM olympic_history
WHERE medal = 'Gold' AND age <> 'NA')

SELECT *
FROM Athletes
WHERE Youngest_Athletes = 1

--11) Find how many male and female athletes participated in all Olympic game.

SELECT
SUM(CASE WHEN sex = 'M' THEN 1 ELSE 0 END) AS total_male_participants,
SUM(CASE WHEN sex = 'F' THEN 1 ELSE 0 END) AS total_Female_participants
FROM 
olympic_history;

--12) Fetch the top 5 athletes who have won the most gold medals.

SELECT 
name,
COUNT (medal) AS Total_Gold_Medals
FROM olympic_history
WHERE medal ='Gold'
GROUP BY 1
ORDER BY 2 DESC;

--13) Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

SELECT 
name,
COUNT (medal) AS Total_Gold_Medals
FROM olympic_history
WHERE medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY 1
ORDER BY 2 DESC;

--14) Fetch the top 5 most successful countries in Olympics. Success is defined by no of medals won.

SELECT 
DISTINCT oh.team,
SUM (CASE WHEN oh.medal IN ('Gold','Silver','Bronze') THEN 1 ELSE 0 END) AS Number_of_medals
FROM olympic_history oh 
JOIN olympic_history_noc_regions nr 
ON oh.noc = nr.noc 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--15) List down total gold, silver and broze medals won by each country.

SELECT 
ohnr.region AS country,
SUM(CASE WHEN oh.medal = 'Gold' THEN 1 ELSE 0 END) AS gold_medals,
SUM(CASE WHEN oh.medal = 'Silver' THEN 1 ELSE 0 END) AS silver_medals,
SUM(CASE WHEN oh.medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_medals
FROM 
olympic_history oh
JOIN 
olympic_history_noc_regions ohnr 
ON oh.noc = ohnr.noc
GROUP BY 1
ORDER BY 2 DESC;

--16) Which countries have never won gold medal but have won silver/bronze medals?

SELECT 
DISTINCT ohnr.region AS country,
oh.medal
FROM 
olympic_history oh
JOIN 
olympic_history_noc_regions ohnr 
ON 
oh.noc = ohnr.noc
WHERE 
ohnr.region NOT IN 
   (SELECT 
        ohnr.region
    FROM 
        olympic_history oh
    JOIN 
        olympic_history_noc_regions ohnr 
    ON 
        oh.noc = ohnr.noc 
WHERE 
        oh.medal = 'Gold' ) AND oh.medal <> 'NA';

--17) In which Sport/event, India has won highest medals.

SELECT
DISTINCT oh.sport,
oh.event,
COUNT (oh.medal) AS Medals
FROM olympic_history oh 
JOIN olympic_history_noc_regions ohnr 
ON oh.noc = ohnr.noc 
WHERE ohnr.region = 'India' 
GROUP BY 1,2
ORDER BY 3 DESC;




--------------BY B.S. Nirmal Raj-----------------THANKS-----------------


