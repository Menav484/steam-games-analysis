
-- GAME ANALYSIS
-- Trends in game releases over time. Are certain genres becoming more popular?
-- Investigate the average price of games in different genres or from different developers.
-- Compare user ratings and reviews across different games and genres.
-- Are there any patterns in highly-rated games?


-- WHICH GENRE GAME MOST POPULAR BETWEEN 2000-2010
SELECT avgowners , genres,release_date
FROM steam 
WHERE release_date BETWEEN '2000-12-31' AND '2010-01-01'
ORDER BY avgowners DESC;



-- WHICH GENRE GAME MOST POPULAR BETWEEN 2010-2019

SELECT avgowners , genres,release_date
FROM steam 
WHERE release_date BETWEEN '2009-12-31' AND '2019-01-01'
ORDER BY avgowners DESC; 




-- AVERAGE PRICE OF EACH GAME GENRE FROM HIGHEST TO LOWEST 
SELECT ROUND(AVG(price),2) AS Average_price ,genres FROM steam
group by genres
ORDER BY ROUND(AVG(price),2) DESC;





-- Explore whether the release date affects  positive ratings.

SELECT ROUND(AVG(positive_ratings),2) as positive_ratings ,EXTRACT(YEAR FROM release_date) 
FROM steam
GROUP BY EXTRACT(YEAR FROM release_date) 
ORDER BY positive_ratings DESC
;


SELECT CORR(EXTRACT(YEAR FROM release_date),positive_ratings) AS correlation FROM steam;

-- since the owners column in the table gives owners in range which will be difficult 
-- for our analysis we add new column avgowners by calculating avg of the column owners


-- Add a new column for average owners

-- ALTER TABLE steam ADD COLUMN avgowners numeric;

-- Calculate and update the average owners for each row

-- UPDATE steam
-- SET avgowners = ROUND(((CAST(SPLIT_PART(owners, '-', 1) AS numeric) + CAST(SPLIT_PART(owners, '-', 2) AS numeric)) / 2));


-- Explore whether the release date affects the number of owners.
SELECT ROUND(AVG(avgowners),2) as AVG_OWNERS , EXTRACT(YEAR FROM release_date) FROM steam 
GROUP BY EXTRACT(YEAR FROM release_date) 
ORDER BY ROUND(AVG(avgowners),2) DESC;

SELECT CORR(EXTRACT(YEAR FROM release_date),avgowners) AS correlation FROM steam;


-- Explore whether the release date affects the playtime.
SELECT ROUND(AVG(average_playtime),2) as AVG_PLAYTIME , EXTRACT(YEAR FROM release_date) FROM steam 
GROUP  BY  EXTRACT(YEAR FROM release_date)
ORDER BY  AVG_PLAYTIME DESC;


SELECT CORR(EXTRACT(YEAR FROM release_date),average_playtime) AS correlation FROM steam;

-- Examine the proportion of games available in English compared to other languages.
-- Investigate whether language availability affects playtime.


-- checking average playtime individually for english  
SELECT AVG(average_playtime) FROM steam
WHERE english=1;

-- -- checking average playtime individually for other languages
SELECT AVG(average_playtime) FROM steam
WHERE english=0;

-- -- checking average playtime english and other languages at the same time 
select case
			when english = 1 then 'english'
			when english=0 then 'other'
		    end as language,
		round(avg(average_playtime)) as avg_playtime
from steam
group by language;



-- Identify the top developers and publishers based on the number of games, positive ratings, or owners.
-- Analyze the relationship between developers and publishers.
-- Do certain publishers tend to work with specific developers?


-- MOST GAMES DEVELOPED AND PUBLISHED TOGETHER 
SELECT developer,publisher,COUNT(name) FROM steam
GROUP BY developer,publisher
ORDER BY COUNT(name) DESC;


--  BEST DEVELOPER AND PUBLISHER IN TERMS OF POSITIVE RATINGS (ATLEAST 5 GAMES MADE TOGETHER )  
SELECT developer,publisher,COUNT(name),ROUND(AVG(positive_ratings),2) as Pos_rating FROM steam
GROUP BY developer,publisher
HAVING COUNT(name) >= 5
ORDER BY Pos_rating DESC;


SELECT publisher , developer ,COUNT(name) FROM steam
GROUP BY developer,publisher
ORDER BY publisher;




--  Platform Analysis:

-- Determine which platforms (Windows, Mac, Linux) are most commonly supported by games on Steam.
-- Explore whether platform availability correlates with user ratings or playtime.

SELECT COUNT(*),platforms FROM steam
GROUP BY platforms
;


-- WHICH PLATFORM HAS THE BEST AVG POSITIVE RATINGS
SELECT ROUND(AVG(positive_ratings),2),platforms FROM steam
GROUP BY platforms;

-- WHICH PLATFORM HAS THE BEST AVG PLAYTIME

SELECT platforms ,ROUND(SUM(average_playtime)) FROM steam
GROUP BY platforms;



-- Category and Genre Analysis:

-- Analyze the distribution of games across different categories and genres.
-- Identify the most popular categories and genres based on positive ratings or playtime.


SELECT categories,genres ,COUNT(*) AS Total_games FROM steam
GROUP BY genres,categories
ORDER BY Total_games DESC;

-- MOST  POPULAR CATEGORY AND GENRE BASED ON POSTIVE RATINGS
SELECT categories , genres, ROUND(AVG(positive_ratings)) as avg_pos_rating
FROM steam
GROUP BY categories,genres
ORDER BY avg_pos_rating DESC;


-- MOST  POPULAR CATEGORY AND GENRE BASED ON PLAYTIME

SELECT categories , genres, ROUND(AVG(average_playtime)) as avg_palytime
FROM steam
GROUP BY categories,genres
ORDER BY avg_palytime DESC;



-- Tag Analysis:


-- Explore the most commonly used tags by developers to describe their games.
SELECT steamspy_tags,COUNT(*) AS Times_used
FROM steam
GROUP BY steamspy_tags
ORDER BY Times_used DESC;


-- Achievement Analysis:

-- Analyze the distribution of achievements in games. Are there any patterns or trends?
-- Explore whether the number of achievements correlates with positive ratings or playtime.


SELECT COUNT(achievements),genres FROM steam 
GROUP BY genres
ORDER BY COUNT(achievements) DESC;

SELECT achievements , round(AVG(positive_ratings),2)
FROM steam 
GROUP BY achievements 
ORDER BY AVG(positive_ratings)
DESC;


SELECT achievements , round(AVG(average_playtime),2)
FROM steam 
GROUP BY achievements 
ORDER BY AVG(average_playtime)
DESC;


-- Rating Analysis:

-- Calculate the overall rating for each game based on positive and negative ratings.
-- Identify games with the highest and lowest overall ratings.

SELECT name , positive_ratings , negative_ratings, 
(positive_ratings - negative_ratings) AS overall_rating 
FROM steam ;


SELECT name , positive_ratings , negative_ratings, 
(positive_ratings - negative_ratings) AS overall_rating 
from steam 
ORDER BY overall_rating DESC
;

--                           OR
						  
						  
-- alter table steam 
-- add column overall_rating bigint;


-- update  steam
-- set overall_rating=positive_ratings - negative_ratings  


SELECT name ,overall_rating  FROM steam 
ORDER BY overall_rating DESC
;


-- Price Analysis:


-- Analyze the distribution of game prices. Are most games priced similarly, or is there a wide range?
SELECT MAX(price),MIN(price),AVG(price)
FROM steam;

SELECT
    CASE
        WHEN price < 5 THEN '0-4.99'
        WHEN price >= 5 AND price < 10 THEN '5-9.99'
        WHEN price >= 10 AND price < 20 THEN '10-19.99'
        WHEN price >= 20 AND price < 30 THEN '20-29.99'
        WHEN price >= 30 AND price < 40 THEN '30-39.99'
        WHEN price >= 40 AND price < 50 THEN '40-49.99'
        ELSE '50+'
    END AS PriceRange,
    COUNT(*) AS NumberOfGames
FROM steam
GROUP BY PriceRange
ORDER BY PriceRange;



-- Investigate whether price affects the number of owners, positive ratings, or playtime.

-- for positive ratings
SELECT price,round(AVG(positive_ratings)) AS Avg_posratings
FROM steam 
GROUP BY price
ORDER BY Avg_posratings DESC;


SELECT CORR(price,positive_ratings) FROM steam;


--  for average owners of the game
SELECT price,round(AVG(avgowners)) AS Avg_owners
FROM steam 
GROUP BY price
ORDER BY Avg_owners DESC;

SELECT CORR(price,avgowners) FROM steam;


--  for average playtime of the game 
SELECT price,round(AVG(average_playtime)) AS Avg_playtm
FROM steam 
GROUP BY price
ORDER BY avg_playtm DESC;


SELECT CORR(price,average_playtime) FROM steam;
