DROP TABLE jversfeld.partner_clicks_daily;

CREATE EXTERNAL TABLE jversfeld.partner_clicks_daily (
   sum_clicks        int
  ,partner           string
  ,locale            string
)

PARTITIONED BY (ymd int)
STORED AS PARQUET