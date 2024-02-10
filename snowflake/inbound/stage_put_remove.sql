Microsoft Windows [Version 10.0.19044.3086]
(c) Microsoft Corporation. All rights reserved.

C:\Users\prdixit>snowsql
* SnowSQL * v1.2.27
Type SQL statements or !help
prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>select * from salary;
+----+-------------+-----------+--------+----------+-------------+
| ID | FIRST_NAME  | LAST_NAME | GENDER |   SALARY | DEPT        |
|----+-------------+-----------+--------+----------+-------------|
|  2 | Jane        | Smith     | Female | 60000.00 | Sales       |
|  3 | Michael     | Johnson   | Male   | 55000.00 | Marketing   |
|  4 | Emily       | Williams  | Female | 65000.00 | Marketing   |
|  5 | Matthew     | Brown     | Male   | 70000.00 | Finance     |
|  6 | Sophia      | Jones     | Female | 52000.00 | Finance     |
|  7 | Christopher | Taylor    | Male   | 48000.00 | Engineering |
|  8 | Olivia      | Davis     | Female | 58000.00 | Engineering |
|  9 | William     | Anderson  | Male   | 63000.00 | Engineering |
| 10 | Ava         | Thomas    | Female | 54000.00 | Engineering |
| 11 | Alexander   | Lee       | Male   | 62000.00 | HR          |
| 12 | Charlotte   | Wilson    | Female | 68000.00 | HR          |
| 13 | Daniel      | Miller    | Male   | 59000.00 | HR          |
| 14 | Mia         | Martin    | Female | 51000.00 | Operations  |
| 15 | David       | Clark     | Male   | 57000.00 | Operations  |
| 16 | Emma        | Hall      | Female | 66000.00 | Operations  |
| 17 | James       | Wright    | Male   | 54000.00 | Operations  |
| 18 | Grace       | Lewis     | Female | 59000.00 | Operations  |
| 19 | Benjamin    | Young     | Male   | 63000.00 | Operations  |
| 20 | Abigail     | Turner    | Female | 57000.00 | Operations  |
+----+-------------+-----------+--------+----------+-------------+
19 Row(s) produced. Time Elapsed: 1.380s
prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>
prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>CREATE OR REPLACE FILE FORMAT CSV_FORMAT
                                   TYPE = 'CSV'
                                   FIELD_DELIMITER = ','
                                   RECORD_DELIMITER = '\n'
                                   SKIP_HEADER = 1
                                   FIELD_OPTIONALLY_ENCLOSED_BY = '"'
                                   TRIM_SPACE = TRUE;
+----------------------------------------------+
| status                                       |
|----------------------------------------------|
| File format CSV_FORMAT successfully created. |
+----------------------------------------------+
1 Row(s) produced. Time Elapsed: 3.510s




prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>CREATE OR REPLACE STAGE LOCAL_STAGE
                                   FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT');
+----------------------------------------------+
| status                                       |
|----------------------------------------------|
| Stage area LOCAL_STAGE successfully created. |
+----------------------------------------------+
1 Row(s) produced. Time Elapsed: 3.283s


prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>put file://C:\Users\prdixit\Desktop\emp.csv @LOCAL_STAGE
                                   AUTO_COMPRESS=FALSE
                                   OVERWRITE=TRUE;
+---------+---------+-------------+-------------+--------------------+--------------------+----------+---------+
| source  | target  | source_size | target_size | source_compression | target_compression | status   | message |
|---------+---------+-------------+-------------+--------------------+--------------------+----------+---------|
| emp.csv | emp.csv |         619 |         624 | NONE               | NONE               | UPLOADED |         |
+---------+---------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 4.686s



prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>
prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>
prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>List @LOCAL_STAGE;
+---------------------+------+----------------------------------+-------------------------------+
| name                | size | md5                              | last_modified                 |
|---------------------+------+----------------------------------+-------------------------------|
| local_stage/emp.csv |  624 | 7988223de8954c5ee91cea86997c23fa | Mon, 17 Jul 2023 15:20:59 GMT |
+---------------------+------+----------------------------------+-------------------------------+


1 Row(s) produced. Time Elapsed: 0.620s
prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>SELECT $1, $2 FROM @LOCAL_STAGE;
+----+-------------+
| $1 | $2          |
|----+-------------|
| 1  | John        |
| 2  | Jane        |
| 3  | Michael     |
| 4  | Emily       |
| 5  | Matthew     |
| 6  | Sophia      |
| 7  | Christopher |
| 8  | Olivia      |
| 9  | William     |
| 10 | Ava         |
| 11 | Alexander   |
| 12 | Charlotte   |
| 13 | Daniel      |
| 14 | Mia         |
| 15 | David       |
| 16 | Emma        |
| 17 | James       |
| 18 | Grace       |
| 19 | Benjamin    |
| 20 | Abigail     |
+----+-------------+
20 Row(s) produced. Time Elapsed: 4.234s
prshntdxt1#COMPUTE_WH@ORG.EMPLOYEE>
