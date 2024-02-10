Microsoft Windows [Version 10.0.19044.3208]
(c) Microsoft Corporation. All rights reserved.

C:\Users\prdixit>snowsql
* SnowSQL * v1.2.27
Type SQL statements or !help
prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>
prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>use schema sales;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.678s
prshntdxt1#COMPUTE_WH@ORG.SALES>show tables;
+-------------------------------+-----------------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+-----------------+
| created_on                    | name            | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner        | retention_time | automatic_clustering | change_tracking | search_optimization | search_optimization_progress | search_optimization_bytes | is_external | owner_role_type |
|-------------------------------+-----------------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+-----------------|
| 2023-07-19 01:08:14.856 -0700 | CUSTOMER_ORDERS | ORG           | SALES       | TABLE |         |            |   20 |  2048 | ACCOUNTADMIN | 1              | OFF                  | OFF             | OFF                 |                         NULL |                      NULL | N           | ROLE            |
| 2023-07-25 01:13:25.873 -0700 | PRODUCTS        | ORG           | SALES       | TABLE |         |            |   10 |  1536 | ACCOUNTADMIN | 1              | OFF                  | OFF             | OFF                 |                         NULL |                      NULL | N           | ROLE            |
| 2023-07-25 01:13:49.725 -0700 | SALES           | ORG           | SALES       | TABLE |         |            |    0 |     0 | ACCOUNTADMIN | 1              | OFF                  | OFF             | OFF                 |                         NULL |                      NULL | N           | ROLE            |
+-------------------------------+-----------------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+-----------------+
3 Row(s) produced. Time Elapsed: 0.697s


prshntdxt1#COMPUTE_WH@ORG.SALES>use schema employee;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.670s


prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>show stages;
+-------------------------------+-------------+---------------+-------------+-----+-----------------+--------------------+--------------+---------+--------+----------+-------+----------------------+---------------------+-----------------+
| created_on                    | name        | database_name | schema_name | url | has_credentials | has_encryption_key | owner        | comment | region | type     | cloud | notification_channel | storage_integration | owner_role_type |
|-------------------------------+-------------+---------------+-------------+-----+-----------------+--------------------+--------------+---------+--------+----------+-------+----------------------+---------------------+-----------------|
| 2023-07-19 02:35:34.446 -0700 | LOCAL_STAGE | ORG           | EMPLOYEE    |     | N               | N                  | ACCOUNTADMIN |         | NULL   | INTERNAL | NULL  | NULL                 | NULL                | ROLE            |
+-------------------------------+-------------+---------------+-------------+-----+-----------------+--------------------+--------------+---------+--------+----------+-------+----------------------+---------------------+-----------------+
1 Row(s) produced. Time Elapsed: 0.664s


prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>List @LOCAL_STAGE;
+---------------------+------+----------------------------------+-------------------------------+
| name                | size | md5                              | last_modified                 |
|---------------------+------+----------------------------------+-------------------------------|
| local_stage/emp.csv |  624 | 263178c4e7f3648b5d123c3305cb9118 | Wed, 19 Jul 2023 09:36:58 GMT |
+---------------------+------+----------------------------------+-------------------------------+
1 Row(s) produced. Time Elapsed: 0.675s


prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>use schema sales;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.697s



prshntdxt1#COMPUTE_WH@ORG.SALES>CREATE OR REPLACE STAGE LOCAL_STAGE
                                FILE_FORMAT = (TYPE = CSV);

+----------------------------------------------+
| status                                       |
|----------------------------------------------|
| Stage area LOCAL_STAGE successfully created. |
+----------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.724s



prshntdxt1#COMPUTE_WH@ORG.SALES>PUT file:///C:/Users/prdixit/Desktop/Snowflake/sales.txt @LOCAL_STAGE;
+-----------+--------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source    | target       | source_size | target_size | source_compression | target_compression | status   | message |
|-----------+--------------+-------------+-------------+--------------------+--------------------+----------+---------|
| sales.txt | sales.txt.gz |         624 |         256 | NONE               | GZIP               | UPLOADED |         |
+-----------+--------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 5.086s



prshntdxt1#COMPUTE_WH@ORG.SALES>COPY INTO ORG.SALES.SALES
                                FROM @LOCAL_STAGE/sales.txt
                                FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1);

+--------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                     | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|--------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| local_stage/sales.txt.gz | LOADED |          30 |          30 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+--------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 1.318s

