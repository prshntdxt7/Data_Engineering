CREATE OR REPLACE STAGE DEV_SCHEMA.SNOWFLAKE_STAGE
	DIRECTORY = ( ENABLE = true ) 
	COMMENT = 'snowflake managed - data loading/unloading from loacal path';

LIST @DEV_SCHEMA.SNOWFLAKE_STAGE;
DESCRIBE STAGE DEV_SCHEMA.SNOWFLAKE_STAGE;

CREATE OR REPLACE TABLE DEV_SCHEMA.EMP_SNOWFLAKE
(id VARCHAR,
first_name VARCHAR,
last_name VARCHAR,
gender VARCHAR,	
salary VARCHAR);

SELECT * FROM DEV_SCHEMA.EMP_SNOWFLAKE;

COPY INTO DEV_SCHEMA.EMP_SNOWFLAKE
FROM @DEV_SCHEMA.SNOWFLAKE_STAGE/emp_snowflake.csv
FILE_FORMAT = (TYPE = CSV);


SHOW STAGES;

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.LOAD_HISTORY;
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY;
SELECT * FROM snowflake.organization_usage.usage_in_currency_daily;

SELECT account_name,
  ROUND(SUM(usage_in_currency), 2) as usage_in_currency
FROM snowflake.organization_usage.usage_in_currency_daily
WHERE usage_date > DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1
ORDER BY 2 desc;


select l.user_name,
       l.event_timestamp as login_time,
       l.client_ip,
       l.reported_client_type,
       l.first_authentication_factor,
       l.second_authentication_factor,
       count(q.query_id)
from snowflake.account_usage.login_history l
join snowflake.account_usage.sessions s on l.event_id = s.login_event_id
join snowflake.account_usage.query_history q on q.session_id = s.session_id
group by 1,2,3,4,5,6
order by l.user_name
;