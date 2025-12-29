--DROP TABLE IF EXISTS MOVIELENS.ANALYTICS.GENOME_TAG_EFFECTIVENESS;

CREATE OR REPLACE TABLE MOVIELENS.ANALYTICS.GENOME_TAG_EFFECTIVENESS AS
WITH tag_genome_stats AS (
    -- Step 1: Get tag-level genome statistics
    SELECT 
        gt.TAGID,
        gt.TAG AS tagname,
        COUNT(DISTINCT gs.MOVIEID) AS movieswithtag,
        ROUND(AVG(gs.RELEVANCE), 3) AS avgtagrelevance
    FROM MOVIELENS.RAW.RAW_GENOME_TAGS gt
    LEFT JOIN MOVIELENS.RAW.RAW_GENOME_SCORES gs ON gt.TAGID = gs.TAGID
    GROUP BY gt.TAGID, gt.TAG
),
tag_rating_stats AS (
    -- Step 2: Get ratings ONLY for movies where tag is RELEVANT
    SELECT 
        gs.TAGID,
        COUNT(DISTINCT r.USERID) AS uniqueusersratingtaggedmovies,
        COUNT(*) AS totalratingsfortaggedmovies,
        ROUND(AVG(r.RATING), 2) AS avgratingfortaggedmovies,
        ROUND(STDDEV_POP(r.RATING), 2) AS ratingvariancefortaggedmovies
    FROM MOVIELENS.RAW.RAW_GENOME_SCORES gs
    INNER JOIN MOVIELENS.RAW.RAW_RATINGS r 
        ON gs.MOVIEID = r.MOVIEID
    WHERE gs.RELEVANCE > 0.15  -- Only include relevant tags!
    GROUP BY gs.TAGID
),
platform_stats AS (
    -- Step 3: Calculate overall platform average
    SELECT 
        AVG(RATING) AS platform_avg_rating
    FROM MOVIELENS.RAW.RAW_RATINGS
)
SELECT 
    tg.TAGID,
    tg.tagname,
    tg.movieswithtag,
    tg.avgtagrelevance,
    COALESCE(tr.avgratingfortaggedmovies, 0) AS avgratingfortaggedmovies,
    COALESCE(tr.uniqueusersratingtaggedmovies, 0) AS uniqueusersratingtaggedmovies,
    COALESCE(tr.totalratingsfortaggedmovies, 0) AS totalratingsfortaggedmovies,
    COALESCE(tr.ratingvariancefortaggedmovies, 0) AS ratingvariancefortaggedmovies,
    ROUND(
        ((COALESCE(tr.avgratingfortaggedmovies, 0) - ps.platform_avg_rating) 
        / ps.platform_avg_rating) * 100, 
        2
    ) AS ratingliftvsaverage,
    CASE 
        WHEN COALESCE(tr.avgratingfortaggedmovies, 0) >= 3.8 THEN 'Highly Effective'
        WHEN COALESCE(tr.avgratingfortaggedmovies, 0) >= 3.5 THEN 'Effective'
        WHEN COALESCE(tr.avgratingfortaggedmovies, 0) >= 3.0 THEN 'Moderate'
        ELSE 'Low Impact'
    END AS tageffectivenesslevel
FROM tag_genome_stats tg
LEFT JOIN tag_rating_stats tr ON tg.TAGID = tr.TAGID
CROSS JOIN platform_stats ps
ORDER BY avgratingfortaggedmovies DESC;
