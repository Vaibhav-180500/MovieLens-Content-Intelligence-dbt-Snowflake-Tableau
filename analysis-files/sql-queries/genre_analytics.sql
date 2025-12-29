-- Create genre analytics table
CREATE OR REPLACE TABLE MOVIELENS.ANALYTICS.GENRE_ANALYTICS AS
WITH genre_split AS (
    SELECT
        m.MOVIEID,
        m.TITLE,
        TRIM(VALUE) AS genre,
        r.USERID,
        r.RATING
    FROM MOVIELENS.RAW.RAW_MOVIES m
    LEFT JOIN MOVIELENS.RAW.RAW_RATINGS r ON m.MOVIEID = r.MOVIEID,
    LATERAL SPLIT_TO_TABLE(m.GENRES, '|')
)
SELECT
    genre,
    COUNT(DISTINCT MOVIEID) AS total_movies_in_genre,
    COUNT(DISTINCT USERID) AS unique_users_rating_genre,
    COUNT(RATING) AS total_ratings,
    ROUND(AVG(RATING), 2) AS avg_rating,
    ROUND(STDDEV_POP(RATING), 2) AS rating_std_dev,
    ROUND(MIN(RATING), 1) AS min_rating,
    ROUND(MAX(RATING), 1) AS max_rating,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY RATING), 2) AS q1_rating,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY RATING), 2) AS median_rating,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY RATING), 2) AS q3_rating,
    ROUND(COUNT(RATING) / NULLIF(COUNT(DISTINCT MOVIEID), 0), 2) AS avg_ratings_per_movie,
    CASE 
        WHEN STDDEV_POP(RATING) >= 1.0 THEN 'Highly Divisive'
        WHEN STDDEV_POP(RATING) >= 0.7 THEN 'Divisive'
        WHEN STDDEV_POP(RATING) >= 0.5 THEN 'Mixed'
        ELSE 'Consensus'
    END AS genre_rating_profile
FROM genre_split
WHERE RATING IS NOT NULL  -- Filter out movies without ratings
GROUP BY genre
ORDER BY avg_rating DESC;
