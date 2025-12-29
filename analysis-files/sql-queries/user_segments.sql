
CREATE OR REPLACE TABLE MOVIELENS.ANALYTICS.USER_SEGMENTS AS
WITH user_rating_stats AS (
    -- Aggregate ratings separately (no join to tags)
    SELECT
        USERID,
        COUNT(DISTINCT MOVIEID) AS movies_rated,
        COUNT(*) AS total_ratings,  -- Now correct!
        ROUND(AVG(RATING), 2) AS avg_rating_given,
        ROUND(STDDEV_POP(RATING), 2) AS rating_variance
    FROM MOVIELENS.RAW.RAW_RATINGS
    GROUP BY USERID
),
user_tag_stats AS (
    -- Aggregate tags separately
    SELECT
        USERID,
        COUNT(DISTINCT TAG) AS total_tags_applied,
        COUNT(DISTINCT MOVIEID) AS movies_tagged
    FROM MOVIELENS.RAW.RAW_TAGS
    GROUP BY USERID
),
user_stats AS (
    -- Combine both aggregations
    SELECT
        ur.USERID,
        ur.movies_rated,
        ur.total_ratings,
        ur.avg_rating_given,
        ur.rating_variance,
        COALESCE(ut.total_tags_applied, 0) AS total_tags_applied,
        ROUND(
            COALESCE(ut.total_tags_applied, 0) 
            / NULLIF(ur.movies_rated, 0), 
            2
        ) AS tags_per_movie_ratio
    FROM user_rating_stats ur
    LEFT JOIN user_tag_stats ut ON ur.USERID = ut.USERID
)
SELECT
    USERID,
    movies_rated,
    total_ratings,
    avg_rating_given,
    rating_variance,
    total_tags_applied,
    tags_per_movie_ratio,
    CASE 
        WHEN total_ratings >= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ratings) FROM user_stats) 
            THEN 'Power User'
        WHEN total_ratings >= (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_ratings) FROM user_stats)
            THEN 'Regular User'
        WHEN total_ratings >= (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ratings) FROM user_stats)
            THEN 'Casual User'
        ELSE 'Light User'
    END AS user_engagement_tier,
    CASE 
        WHEN avg_rating_given >= 4.0 THEN 'Generous Rater'
        WHEN avg_rating_given >= 3.5 THEN 'Balanced Rater'
        WHEN avg_rating_given >= 3.0 THEN 'Critical Rater'
        ELSE 'Very Critical Rater'
    END AS rating_style,
    CASE 
        WHEN rating_variance >= 1.2 THEN 'Discriminating (High Variance)'
        WHEN rating_variance >= 0.8 THEN 'Moderate Variance'
        ELSE 'Consistent (Low Variance)'
    END AS rating_pattern,
    CASE 
        WHEN tags_per_movie_ratio >= 0.5 THEN 'High Tagger'
        WHEN tags_per_movie_ratio >= 0.2 THEN 'Moderate Tagger'
        ELSE 'Light Tagger'
    END AS tagging_behavior
FROM user_stats
ORDER BY total_ratings DESC;
