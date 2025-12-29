-- Create movie performance metrics table
CREATE TABLE MOVIELENS.ANALYTICS.movie_performance_metrics AS
SELECT
    m.MOVIEID AS MOVIE_ID,
    m.TITLE,
    m.GENRES,
    COUNT(DISTINCT r.USERID) AS total_unique_users,
    COUNT(r.RATING) AS total_ratings,
    ROUND(AVG(r.RATING), 2) AS avg_rating,
    ROUND(STDDEV_POP(r.RATING), 2) AS rating_std_dev,
    ROUND(MIN(r.RATING), 1) AS min_rating,
    ROUND(MAX(r.RATING), 1) AS max_rating,
    ROUND(
        AVG(r.RATING) * COUNT(r.RATING) /
        (
          SELECT AVG(CNT_RATING)
          FROM (
            SELECT COUNT(RATING) AS CNT_RATING
            FROM MOVIELENS.RAW.RAW_RATINGS
            GROUP BY MOVIEID
          )
        ),
        2
    ) AS engagement_score,
    CASE 
        WHEN AVG(r.RATING) >= 4.0 THEN 'High Performer'
        WHEN AVG(r.RATING) >= 3.5 THEN 'Good Performer'
        WHEN AVG(r.RATING) >= 3.0 THEN 'Average'
        ELSE 'Underperformer'
    END AS performance_category,
    CASE 
        WHEN STDDEV_POP(r.RATING) >= 1.0 THEN 'Highly Polarizing'
        WHEN STDDEV_POP(r.RATING) >= 0.7 THEN 'Polarizing'
        ELSE 'Consensus Favorite'
    END AS rating_consistency
FROM MOVIELENS.RAW.RAW_MOVIES m
LEFT JOIN MOVIELENS.RAW.RAW_RATINGS r 
    ON m.MOVIEID = r.MOVIEID
GROUP BY m.MOVIEID, m.TITLE, m.GENRES
ORDER BY avg_rating DESC;
