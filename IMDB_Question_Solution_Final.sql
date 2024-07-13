/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:
use imdb;


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- using count of Primary key in each table to get the number of rows

SELECT Count(movie_id) AS number_of_rows_from_director_mapping
FROM   director_mapping;
-- 3867 rows


SELECT Count(movie_id) AS number_of_rows_from_genre
FROM   genre;
-- 14662 rows


SELECT Count(id) AS number_of_rows_from_movie
FROM   movie;
-- 7997 rows


SELECT Count(id) AS number_of_rows_from_names
FROM   names;
-- 25735 rows


SELECT Count(movie_id) AS number_of_rows_from_ratings
FROM   ratings;
-- 7997 rows


SELECT Count(movie_id) AS number_of_rows_from_role_mapping
FROM   role_mapping;
-- 15615 rows




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- using case combination of CTE and Case Statement to get the desired output
WITH null_column_data AS
(
       SELECT Sum(
              CASE
                     WHEN id IS NULL THEN 1
                     ELSE 0
              END) AS id_null_count,
              Sum(
              CASE
                     WHEN title IS NULL THEN 1
                     ELSE 0
              END) AS title_null_count,
              sum(
              CASE
                     WHEN year IS null THEN 1
                     ELSE 0
              END) AS year_null_count,
              sum(
              CASE
                     WHEN date_published IS NULL THEN 1
                     ELSE 0
              END) AS date_published_null_count,
              sum(
              CASE
                     WHEN duration IS NULL THEN 1
                     ELSE 0
              END) AS duration_null_count,
              sum(
              CASE
                     WHEN country IS NULL THEN 1
                     ELSE 0
              END) AS country_null_count,
              sum(
              CASE
                     WHEN worlwide_gross_income IS NULL THEN 1
                     ELSE 0
              END) AS worlwide_gross_income_null_count,
              sum(
              CASE
                     WHEN languages IS NULL THEN 1
                     ELSE 0
              END) AS languages_null_count,
              sum(
              CASE
                     WHEN production_company IS NULL THEN 1
                     ELSE 0
              END) AS production_company_null_count
       FROM   movie)
SELECT country_null_count,
       worlwide_gross_income_null_count,
       languages_null_count,
       production_company_null_count
FROM   null_column_data;




-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- count of movies by year
SELECT Year,
       Count(id)    AS number_of_movies
FROM   movie
GROUP  BY Year ;

-- count of movies by month
SELECT Month(date_published) AS month_num,
       Count(id)             AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num;




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- count of movies produced by INDIA or USA in 2019
SELECT Count(id) AS number_of_movies
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019;
       
-- total 1059 movies are produced by INDIA and USA in 2019       




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/




-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Count of unique number of genres, using group by for more effiency
SELECT genre
FROM   genre
GROUP  BY genre;

-- There are 13 different genres for movies




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


-- Count of movies for Last Year - 2019 
SELECT genre,
       Count(DISTINCT id) AS movie_count
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
WHERE  year = 2019
GROUP  BY genre
ORDER  BY Count(title) DESC
LIMIT  1;
-- 1078 Drama movies are produced in 2019


-- count of movies for all years 
SELECT genre,
       Count(movie_id) AS number_of_movies
FROM   genre
GROUP  BY genre
ORDER  BY number_of_movies DESC
LIMIT  1; 

-- 4285 Drama movies are produced overall across all years
-- genre Drama has highest number of moves -  for last Year - 2019 as well as Overall across all years 




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


-- getting count of movies which belong to only one genre
WITH movies_one_genre
     AS (SELECT movie_id,
                Count(DISTINCT genre) AS genre_count
         FROM   genre
         GROUP  BY movie_id)
SELECT Count(*) AS movies_one_genre
FROM   movies_one_genre
WHERE  genre_count = 1;




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- getting average duration of movies across each genre
SELECT genre,
       Round(Avg(duration),2) AS avg_duration
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY avg_duration DESC; 

-- top 3 genre by avg duration are Action, Romance and Crime




/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_thriller_data
     AS (SELECT genre,
                Count(movie_id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_thriller_data
WHERE  genre = "thriller"; 

-- thriller has genre rank 3 on basis of number of movies




	/*Thriller movies is in top 3 among all genres in terms of number of movies
	 In the previous segment, you analysed the movies and genres tables. 
	 In this segment, you will analyse the ratings table as well.
	To start with lets get the min and max values of different columns in the table*/



	-- Segment 2:




	-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
	/* Output format:
	+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
	| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
	+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
	|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
	+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
	-- Type your code below:

	SELECT MIN(avg_rating)    AS MIN_AVG_RATING,
		   MAX(avg_rating)    AS MAX_AVG_RATING,
		   MIN(total_votes)   AS MIN_TOTAL_VOTES,
		   MAX(total_votes)   AS MAX_TOTAL_VOTES,
		   MIN(median_rating) AS MIN_MEDIAN_RATING,
		   MAX(median_rating) AS MAX_MEDIAN_RATING
	FROM   ratings;
    
    
    
        
    /* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH mov_rank_summary
     AS (SELECT title,
                avg_rating,
                Rank()
                  OVER(
                    ORDER BY avg_rating DESC) AS movie_rank
         FROM   ratings AS r
                INNER JOIN movie AS m
                        ON m.id = r.movie_id)
SELECT *
FROM   mov_rank_summary
WHERE  movie_rank <= 10;




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

-- median rating 7 has hihgest movie count followed by median rating 6 and 8 respectively




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_comp_summary
     AS (SELECT production_company,
                Count(movie_id)  AS movie_count,
                Rank() OVER(ORDER BY Count(movie_id) DESC ) AS prod_company_rank
		FROM   ratings AS R
		INNER JOIN movie AS M
		ON M.id = R.movie_id
        WHERE  avg_rating > 8
		AND production_company IS NOT NULL
		GROUP  BY production_company)
SELECT *
FROM   production_comp_summary
WHERE  prod_company_rank = 1;




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- getting genre  with count of movie where votes are more than 1000 and year is 2017

SELECT genre,
       Count(M.id) AS movie_count
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

-- the top three genres by movie count which have votes greater than 1000 are - Drama, Comedy and Action




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
GROUP  BY title,
          avg_rating,
          genre
ORDER  BY avg_rating DESC; 

-- There are 15 movies which start with 'THE' and have average raring more than 8




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(movie_id) AS number_of_movies
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND r.median_rating = 8; 

-- there are 361 movies which were released between 1 April 2018 and 1 April 2019 and also had a median rating of 8




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Getting total number of votes for Germand and Italian moview by language of the movie - German and Italian

SELECT 'German'         AS lang_name,
       Sum(total_votes) AS total_votes
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.languages LIKE '%german%'
UNION
SELECT 'Italian'        AS lang_name,
       Sum(total_votes) AS total_votes
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.languages LIKE '%italian%'; 

-- by language of movie German movies have higher votes than Italian movies


-- Getting total number of votes for Germand and Italian moview by country of the movie - Germany and Italy
SELECT 'Germany'        AS country_name,
       Sum(total_votes) AS total_votes
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.country LIKE '%germany%'
UNION
SELECT 'Italy'        AS country_name,
       Sum(total_votes) AS total_votes
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.country LIKE '%italy%'; 

-- by country of movie German movies have higher votes than Italian movies




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

-- There are no name nulls
-- height Nulls are - 17335
-- date_of_birth Nulls are - 13431
-- known_for_movies Nulls are - 15226




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH genre_data AS
(
           SELECT     genre ,
                      Count(g.movie_id) AS number_of_movies
           FROM       ratings           AS r
           INNER JOIN genre             AS g
           ON         r.movie_id = g.movie_id
           WHERE      avg_rating > 8
           GROUP BY   genre
           ORDER BY   number_of_movies DESC limit 3)
-- get the top 3 director with rtaing > 8 and genre in above top 3 genre
SELECT     n.NAME             AS director_name,
           Count(dm.movie_id) AS movie_count
FROM       director_mapping   AS dm
INNER JOIN names              AS n
ON         dm.name_id = n.id
INNER JOIN movie AS m
ON         m.id = dm.movie_id
INNER JOIN genre AS g
ON         m.id =g.movie_id
INNER JOIN ratings AS r
ON         m.id=r.movie_id
WHERE      g.genre IN
           (
                  SELECT genre
                  FROM   genre_data)
AND        avg_rating>8
GROUP BY   director_name
ORDER BY   movie_count DESC;

-- The top 3 directors by movie count,  in top three genres whose movies have an average rating > 8 are - James Mangold, Anthony Russo and Joe Russo




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT DISTINCT name             AS actor_name,
                Count(rm.movie_id) AS movie_count
FROM   role_mapping AS rm
       INNER JOIN ratings AS r
               ON rm.movie_id = r.movie_id
       INNER JOIN names AS n
               ON n.id = rm.name_id
WHERE  category = "actor"
       AND r.median_rating >= 8
GROUP  BY n.name
ORDER  BY movie_count DESC
LIMIT  2;

-- the top two actors whose movies have a median rating >= 8 are : Mammootty and Mohanlal




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_comp_summ
     AS (SELECT production_company,
                Sum(total_votes)                    AS vote_count,
                Rank()
                  OVER(
                    ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON r.movie_id = m.id
         GROUP  BY production_company)
SELECT *
FROM   prod_comp_summ
WHERE  prod_comp_rank <= 3; 

-- the top three production houses based on the number of votes received by their movies are : Marvel Studios, Twentieth Century Fox and Warner Bros.




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_summary
     AS (SELECT N.NAME                                                     AS
                actor_name
                ,
                Sum(total_votes)
                AS
                   total_votes,
                Count(R.movie_id)                                          AS
                   movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
                   actor_avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON M.id = R.movie_id
                INNER JOIN role_mapping AS RM
                        ON M.id = RM.movie_id
                INNER JOIN names AS N
                        ON RM.name_id = N.id
         WHERE  category = 'ACTOR'
                AND country = "india"
         GROUP  BY actor_name
         HAVING movie_count >= 5)
SELECT *,
       Rank()
         OVER(
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_summary; 

-- The top 3 actors are - Vijay Sethupathi, Fahadh Faasil and Yogi Babu




-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_summary AS
(
           SELECT     n.NAME                                                     AS actor_name,
                      Sum(total_votes)                                           AS total_votes,
                      Count(r.movie_id)                                          AS movie_count,
                      Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
           FROM       movie                                                      AS m
           INNER JOIN ratings                                                    AS r
           ON         m.id = r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           WHERE      category = 'ACTRESS'
           AND        country LIKE "%india%"
           AND        languages LIKE '%HINDI%'
           GROUP BY   actor_name
           HAVING     movie_count >= 3 )
SELECT   *,
         Rank() OVER( ORDER BY actor_avg_rating DESC) AS actress_rank
FROM     actress_summary limit 5;

-- the top 5 actresses are - Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
WITH thriller_movies
     AS (SELECT DISTINCT title,
                         avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON R.movie_id = M.id
                INNER JOIN genre AS G using(movie_id)
         WHERE  genre = 'THRILLER')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies;




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
-- geting genre, average movie duration, total running duration and moving average duration - taking window = 10 for moving average
SELECT genre,
       Round(Avg(duration), 2)                      AS avg_duration,
       SUM(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS unbounded preceding) AS running_total_duration,
       Avg(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS 10 preceding)        AS moving_avg_duration
FROM   movie AS m
       inner join genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre;




-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- converting INR to $ and then ranking movies basis a common currently for worlwide_gross_income
-- Using rank with - partition by year and  order by worlwide_gross_income to get top 5 in each year

WITH genre_data AS
(
           SELECT     genre ,
                      Count(g.movie_id) AS number_of_movies
           FROM       ratings           AS r
           INNER JOIN genre             AS g
           ON         r.movie_id = g.movie_id
           GROUP BY   genre
           ORDER BY   number_of_movies DESC limit 3), converted_currency AS
(
       SELECT id,
              CASE
                     WHEN worlwide_gross_income LIKE "INR%" THEN Cast(Round(Replace(worlwide_gross_income,'INR','')*0.0122332973,2) AS DECIMAL(15))
                     WHEN worlwide_gross_income LIKE "$%" THEN Cast(Replace(worlwide_gross_income,'$','') AS                           DECIMAL(15))
              END AS worlwide_gross_income
       FROM   movie), top_movie_data AS
(
           SELECT     genre ,
                      year ,
                      title,
                      c.worlwide_gross_income,
                      Dense_rank() OVER(partition BY year ORDER BY c.worlwide_gross_income DESC) AS movie_rank
           FROM       movie                                                                        AS m
           INNER JOIN genre                                                                        AS g
           ON         m.id = g.movie_id
           INNER JOIN converted_currency AS c
           ON         m.id=c.id
           WHERE      g.genre IN
                      (
                             SELECT genre
                             FROM   genre_data))
SELECT *
FROM   top_movie_data
WHERE  movie_rank<=5;




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_summary AS
(
           SELECT     production_company,
                      Count(*) AS movie_count
           FROM       movie    AS m
           INNER JOIN ratings  AS r
           ON         r.movie_id = m.id
           WHERE      median_rating >= 8
           AND        production_company IS NOT NULL
           AND        position(',' IN languages) > 0
           GROUP BY   production_company
           ORDER BY   movie_count DESC)
SELECT   *,
         rank() OVER( ORDER BY movie_count DESC) AS prod_comp_rank
FROM     production_company_summary limit 2;

-- the top two Production Companies are - Star Cinema, Twentieth Century Fox




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Getting top three actresses - ranking based on average rating
WITH actress_summary AS
(
           SELECT     n.NAME                                                AS actress_name,
                      Sum(total_votes)                                      AS total_votes,
                      Count(m.id)                                           AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS m
           INNER JOIN ratings                                               AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           INNER JOIN genre AS g
           ON         g.movie_id = m.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND        genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_summary limit 3;

-- top 3 actresses bases on count of movies are - Sangeetha Bhat, Fatmire Sahiti, Adriana Matoshi


-- Getting top three actresses - ranking based on count of movies
WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(m.id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS m
           INNER JOIN ratings                                               AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary limit 3;

-- top 3 actresses bases on count of movies are - Parvathy Thiruvothu, Susan Brown, Amanda Lawrence




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                     AS director_id,
         NAME                        AS director_name,
         Count(movie_id)             AS number_of_movies,
         Round(Avg(date_difference)) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)    AS avg_rating,
         Sum(total_votes)            AS total_votes,
         Min(avg_rating)             AS min_rating,
         Max(avg_rating)             AS max_rating,
         Sum(duration)               AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;