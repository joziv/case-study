WITH cte AS (
SELECT
     cl.partner_id AS partner_id     
    ,COUNT(1) AS click_count
    ,locale
    ,ymd
FROM trivago_analytic.session_stats_master
LATERAL VIEW EXPLODE (co_log_entries)ple AS cl
WHERE 
     ymd = ${crunchDate} 
     AND is_core
     AND cl.page_id = 8001
GROUP BY 
     ymd
    ,cl.partner_id
    ,locale
)

,cte_partner AS (
SELECT 
     click_count 
    ,CASE 
        WHEN partner_id = 626 THEN "BookingCom"
        WHEN partner_id = 406 THEN "Expedia"
        WHEN partner_id = 452 THEN "HotelsCom"
        WHEN partner_id = 395 THEN "Agoda"
            ELSE "Other"
     END AS partner
    ,locale
    ,ymd
FROM cte
)


INSERT OVERWRITE TABLE jversfeld.partner_clicks_daily
PARTITION (ymd)

SELECT
     SUM(click_count) AS sum_clicks
    ,partner 
    ,locale
    ,ymd
FROM cte_partner
GROUP BY
     partner
    ,locale
    ,ymd