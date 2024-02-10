CREATE OR REPLACE TABLE EMP
(emp_id NUMBER, emp_name VARCHAR)
DATA_RETENTION_TIME_IN_DAYS=90;

SHOW TABLES;

CREATE OR REPLACE TABLE EMP_1
(emp_id NUMBER, emp_name VARCHAR)
DATA_RETENTION_TIME_IN_DAYS=91;

ALTER table EMP SET DATA_RETENTION_TIME_IN_DAYS=10;
SHOW TABLES;


------------------------------------------------------------
-- work with historical data in Snowflake
SELECT CURRENT_TIMESTAMP(); -- 2023-08-02 09:30:49.597 +0000
ALTER SESSION SET TIMEZONE='UTC';

-- BEFORE
----------
SELECT * FROM EMP BEFORE(timestamp => '2023-08-02 08:00:41.881 +0000'::timestamp);
INSERT INTO EMP(emp_id, emp_name)
VALUES(2, 'DEF');

--OFFSET (query table as of n-minutes ago)
-------------------------------------------
SELECT * FROM EMP AT(OFFSET => -60*2);


--Query selects historical data from a table up to this query, but not including any changes made by specified query_id
-----------------------------------------------------------------------------------------------------------------------
SELECT * FROM EMP BEFORE(statement => '01ae091b-0001-020d-0000-0001da4256f9');


CREATE OR REPLACE TABLE EMP_CLONE 
CLONE EMP
AT(TIMESTAMP => '2023-08-02 08:00:41.881 +0000'::timestamp);

SHOW TABLES;

---------------------------------
--Dropping and restoring objects:
---------------------------------
-- When a object is dropped, it is not immediately overwritten or removed from the system.
-- Rather it is retained for the data-retention period for the object, during this time the object can be restored.
-- Once dropped objects are moved to fail-safe, you cannot restore them.


--check history for objects
---------------------------
SHOW TABLES HISTORY LIKE 'EMP%' in DEVELOPMENT.DEV_SCHEMA;
SHOW SCHEMAS HISTORY IN DEVELOPMENT;
SHOW DATABASES HISTORY;

DROP TABLE DEVELOPMENT.DEV_SCHEMA.MY_TABLE;
SHOW TABLES;
UNDROP TABLE DEVELOPMENT.DEV_SCHEMA.MY_TABLE;
-- If an object with same name already exists, UNDROP fails.
-- We can rename the existing object, and then later restore the previous version of the object.
SHOW TABLES;













