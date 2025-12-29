-- DROP TABLE IF EXISTS MOVIELENS.ANALYTICS.CONTENT_OPPORTUNITIES;

CREATE TABLE MOVIELENS.ANALYTICS.CONTENT_OPPORTUNITIES AS
WITH rating_agg AS (
    -- Pre-aggregate ratings to avoid Cartesian product
    SELECT 
        MOVIEID,
        COUNT(DISTINCT USERID) AS totalraters,
        COUNT(*) AS totalratings,
        ROUND(AVG(RATING), 2) AS avgrating
    FROM MOVIELENS.RAW.RAW_RATINGS
    GROUP BY MOVIEID
),
genome_agg AS (
    -- Pre-aggregate genome scores separately
    SELECT 
        MOVIEID,
        ROUND(AVG(RELEVANCE), 3) AS avggenomerelevance,
        COUNT(DISTINCT TAGID) AS tagcount
    FROM MOVIELENS.RAW.RAW_GENOME_SCORES
    GROUP BY MOVIEID
),
moviemetrics AS (
    SELECT 
        m.MOVIEID,
        m.TITLE,
        m.GENRES,
        COALESCE(r.totalraters, 0) AS totalraters,
        COALESCE(r.totalratings, 0) AS totalratings,
        COALESCE(r.avgrating, 0) AS avgrating,
        COALESCE(g.avggenomerelevance, 0) AS avggenomerelevance,
        COALESCE(g.tagcount, 0) AS tagcount
    FROM MOVIELENS.RAW.RAW_MOVIES m
    LEFT JOIN rating_agg r ON m.MOVIEID = r.MOVIEID
    LEFT JOIN genome_agg g ON m.MOVIEID = g.MOVIEID
),
opportunityclassification AS (
    SELECT 
        *,
        CASE 
            WHEN avggenomerelevance > 0.20 AND avgrating < 3.2 THEN 'High Potential, Low Rating - REMARKET'
            WHEN avggenomerelevance > 0.20 AND avgrating > 3.8 AND totalraters < 50 THEN 'Hidden Gem - PROMOTE'
            WHEN tagcount > 8 AND avgrating < 3.0 AND totalraters > 100 THEN 'Quality Issue - INVESTIGATE'
            WHEN avggenomerelevance < 0.08 AND avgrating > 4.0 AND totalraters > 50 THEN 'Unexpected Hit - ANALYZE'
            WHEN totalraters < 5 AND avggenomerelevance > 0.15 THEN 'Needs More Ratings - PROMOTE'
            ELSE 'Standard'
        END AS opportunitytype,
        CASE 
            WHEN avggenomerelevance > 0.20 AND avgrating < 3.2 THEN 1
            WHEN avggenomerelevance > 0.20 AND avgrating > 3.8 AND totalraters < 50 THEN 2
            WHEN tagcount > 8 AND avgrating < 3.0 AND totalraters > 100 THEN 3
            WHEN avggenomerelevance < 0.08 AND avgrating > 4.0 AND totalraters > 50 THEN 4
            WHEN totalraters < 5 AND avggenomerelevance > 0.15 THEN 5
            ELSE 6
        END AS priorityscore
    FROM moviemetrics
)
SELECT 
    MOVIEID,
    TITLE,
    GENRES,
    totalraters,
    totalratings,
    avgrating,
    avggenomerelevance,
    tagcount,
    opportunitytype,
    priorityscore,
    CASE 
        WHEN priorityscore IN (1, 2, 5) THEN 'HIGH'
        WHEN priorityscore = 3 THEN 'MEDIUM'
        WHEN priorityscore = 4 THEN 'INSIGHT'
        ELSE 'STANDARD'
    END AS actionpriority,
    CASE 
        WHEN opportunitytype = 'High Potential, Low Rating - REMARKET' THEN 'This movie has strong attributes but underperforms. Consider re-promoting.'
        WHEN opportunitytype = 'Hidden Gem - PROMOTE' THEN 'Highly rated but undiscovered. Perfect candidate for recommendation boost.'
        WHEN opportunitytype = 'Quality Issue - INVESTIGATE' THEN 'Many tags but low rating. Review if dataset quality issue or genuine underperformance.'
        WHEN opportunitytype = 'Unexpected Hit - ANALYZE' THEN 'Minimal tag relevance but highly rated. What makes it work? Replicate success factors.'
        WHEN opportunitytype = 'Needs More Ratings - PROMOTE' THEN 'Promising attributes but needs more user engagement to validate.'
        ELSE 'Monitor standard performance metrics.'
    END AS recommendedaction
FROM opportunityclassification
ORDER BY priorityscore, avgrating DESC;
