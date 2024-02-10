SELECT * FROM INFORMATION_SCHEMA.TABLE_STORAGE_METRICS;
-- Transient tables are a type of temporary table that is designed for short-term data storage and analysis.
-- They are ideal for use cases where you need to store intermediate results, temporary data, or perform one-time data transformations during complex data processing tasks. 
-- Transient tables are automatically dropped after a certain period of inactivity, making them a convenient and efficient way to manage temporary data in Snowflake.

-- Fail-Safe in Snowflake refers to a feature that allows you to preserve the data within a transient table even after it would have been automatically dropped due to inactivity. 
--This feature is useful when you want to retain the temporary data for a longer duration to perform further analysis or debugging.

/*
"Let's say you have a transient table named 'temp_aggregated_data' that contains partially aggregated data after the initial transformation step.
By using the Fail-Safe feature, you can instruct Snowflake to preserve 'temp_aggregated_data' for an additional 7 days, even if it would have been automatically dropped after 24 hours due to inactivity.
During these 7 days, you can run further analysis, perform optimizations, or debug your data processing pipeline without worrying about losing the intermediate results stored in the transient table." 
*/

-- QUERY_HISTORY 
-------------------
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY limit 10;

SELECT QUERY_TYPE, SUM(CREDITS_USED_CLOUD_SERVICES) AS cs_credits,
COUNT(1) AS num_queries
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
--WHERE START_TIME >= TIMESTAMPADD(day, -1, current_timestamp)
GROUP BY QUERY_TYPE
ORDER BY cs_credits DESC;




-- WAREHOUSE_METERING_HISTORY
-----------------------------

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY;

SELECT WAREHOUSE_NAME, 
SUM(CREDITS_USED_CLOUD_SERVICES) cs_credits,
SUM(CREDITS_USED_COMPUTE) compute_credits,
SUM(CREDITS_USED) total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
GROUP BY WAREHOUSE_NAME
ORDER BY total_credits;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Snowflake user wise pricing queries.
---------------------------------------------------------------------------------------------------------------------------------------------------
-- [#1]
---------
WITH user_wise_resource_usage AS (
  SELECT
    USER_NAME,
    SUM(BYTES_SCANNED) AS TOTAL_BYTES_SCANNED,
    SUM(ROWS_PRODUCED) AS TOTAL_ROWS_PRODUCED
  FROM
    SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE START_TIME BETWEEN TIMESTAMP '2023-01-01 00:00:00' AND TIMESTAMP '2023-07-01 00:00:00'
  GROUP BY USER_NAME)
  
SELECT
  USER_NAME,
  TOTAL_BYTES_SCANNED,
  TOTAL_ROWS_PRODUCED
FROM user_wise_resource_usage
ORDER BY TOTAL_BYTES_SCANNED DESC;

-- [#2]
---------
WITH
warehouse_sizes AS (
    SELECT 'X-Small' AS warehouse_size, 1 AS credits_per_hour UNION ALL
    SELECT 'Small' AS warehouse_size, 2 AS credits_per_hour UNION ALL
    SELECT 'Medium'  AS warehouse_size, 4 AS credits_per_hour UNION ALL
    SELECT 'Large' AS warehouse_size, 8 AS credits_per_hour UNION ALL
    SELECT 'X-Large' AS warehouse_size, 16 AS credits_per_hour UNION ALL
    SELECT '2X-Large' AS warehouse_size, 32 AS credits_per_hour UNION ALL
    SELECT '3X-Large' AS warehouse_size, 64 AS credits_per_hour UNION ALL
    SELECT '4X-Large' AS warehouse_size, 128 AS credits_per_hour)
SELECT
    qh.query_id,
    qh.query_text,
    qh.execution_time/(1000*60*60)*wh.credits_per_hour AS query_cost
FROM snowflake.account_usage.query_history AS qh
INNER JOIN warehouse_sizes AS wh
    ON qh.warehouse_size=wh.warehouse_size
WHERE
    start_time >= CURRENT_DATE - 30;



-- [#3]
--------
SELECT execution_time, * FROM snowflake.account_usage.query_history;

SELECT
    query_id,
    query_text,
    warehouse_id,
    TIMEADD(
        'millisecond',
        queued_overload_time + compilation_time +
        queued_provisioning_time + queued_repair_time +
        list_external_files_time,
        start_time
    ) AS execution_start_time,
    end_time
FROM snowflake.account_usage.query_history AS q
WHERE TRUE
    AND warehouse_size IS NOT NULL
    AND start_time >= CURRENT_DATE - 30;


