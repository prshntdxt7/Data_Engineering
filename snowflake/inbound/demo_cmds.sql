--Create a Database, and list all databases
--------------------------------------------
CREATE DATABASE ORG;
SHOW DATABASES;

--Create a Schema and list all schema
--------------------------------------------
CREATE SCHEMA EMPLOYEE;
SHOW SCHEMAS;

-- Create a table and list all tables
--------------------------------------
CREATE OR REPLACE TABLE ORG.EMPLOYEE.SALARY (
    id INT PRIMARY KEY NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(50),
    salary DECIMAL(10, 2) NOT NULL
);

--List tables and get ddl
-------------------------------------------
SHOW TABLES;
SELECT GET_DDL('TABLE', 'ORG.EMPLOYEE.SALARY');

--Insert Data into SALARY table
--------------------------------
--COPY INTO ORG.EMPLOYEE.SALARY (id, first_name, last_name, gender, salary)
--FROM '@azure_stage/emp.csv'
--CREDENTIALS = (AZURE_SAS_TOKEN = '<your_azure_sas_token>')
--FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = ',');

INSERT INTO ORG.EMPLOYEE.SALARY (id, first_name, last_name, gender, salary)
VALUES
    (1, 'John', 'Doe', 'Male', 50000),
    (2, 'Jane', 'Smith', 'Female', 60000),
    (3, 'Michael', 'Johnson', 'Male', 55000),
    (4, 'Emily', 'Williams', 'Female', 65000),
    (5, 'Matthew', 'Brown', 'Male', 70000),
    (6, 'Sophia', 'Jones', 'Female', 52000),
    (7, 'Christopher', 'Taylor', 'Male', 48000),
    (8, 'Olivia', 'Davis', 'Female', 58000),
    (9, 'William', 'Anderson', 'Male', 63000),
    (10, 'Ava', 'Thomas', 'Female', 54000),
    (11, 'Alexander', 'Lee', 'Male', 62000),
    (12, 'Charlotte', 'Wilson', 'Female', 68000),
    (13, 'Daniel', 'Miller', 'Male', 59000),
    (14, 'Mia', 'Martin', 'Female', 51000),
    (15, 'David', 'Clark', 'Male', 57000),
    (16, 'Emma', 'Hall', 'Female', 66000),
    (17, 'James', 'Wright', 'Male', 54000),
    (18, 'Grace', 'Lewis', 'Female', 59000),
    (19, 'Benjamin', 'Young', 'Male', 63000),
    (20, 'Abigail', 'Turner', 'Female', 57000);

-- Show all Data from table
-----------------------------------
SELECT * FROM  ORG.EMPLOYEE.SALARY;


-- Find top 5 earners
-----------------------------------
SELECT first_name, last_name, salary
FROM SALARY
ORDER BY salary DESC
LIMIT 5;

--Find employee with maximum salary
------------------------------------
SELECT * 
FROM ORG.EMPLOYEE.SALARY 
WHERE SALARY=(SELECT MAX(SALARY) FROM ORG.EMPLOYEE.SALARY);



--Average Salary by Gender:
------------------------------------
SELECT gender, ROUND(AVG(salary), 2) AS average_salary
FROM ORG.EMPLOYEE.SALARY
GROUP BY gender;

-- range distribution example
------------------------------
-- get range and count of emp in that range
SELECT CONCAT('$', FLOOR(salary/10000)*10000, '-', FLOOR(salary/10000 + 1)*10000) AS salary_range,
       COUNT(*) AS count
FROM ORG.EMPLOYEE.SALARY
GROUP BY salary_range;

-- get range and all emp within that range
SELECT 
  CONCAT('$', FLOOR(salary/10000)*10000, '-', FLOOR(salary/10000+1)*10000) AS salary_range,
  ARRAY_AGG(CONCAT(first_name, ' ', last_name)) AS employees
FROM ORG.EMPLOYEE.SALARY
GROUP BY salary_range;

-- get range and all emp within that range, and lenght of total emp in that list
SELECT 
  CONCAT('$', FLOOR(salary/10000)*10000, '-', FLOOR(salary/10000+1)*10000) AS salary_range,
  ARRAY_AGG(CONCAT(first_name, ' ', last_name)) AS employees,
  COUNT(*) AS employee_count
FROM ORG.EMPLOYEE.SALARY
GROUP BY salary_range;

SELECT * FROM ORG.EMPLOYEE.SALARY;
--DELETE FROM ORG.EMPLOYEE.SALARY;

--ALTER TABLE ORG.EMPLOYEE.SALARY ADD COLUMN dept VARCHAR;
INSERT INTO ORG.EMPLOYEE.SALARY (id, first_name, last_name, gender, salary, dept)
VALUES
  (1, 'John', 'Doe', 'Male', 50000, 'Sales'),
  (2, 'Jane', 'Smith', 'Female', 60000, 'Sales'),
  (3, 'Michael', 'Johnson', 'Male', 55000, 'Marketing'),
  (4, 'Emily', 'Williams', 'Female', 65000, 'Marketing'),
  (5, 'Matthew', 'Brown', 'Male', 70000, 'Finance'),
  (6, 'Sophia', 'Jones', 'Female', 52000, 'Finance'),
  (7, 'Christopher', 'Taylor', 'Male', 48000, 'Engineering'),
  (8, 'Olivia', 'Davis', 'Female', 58000, 'Engineering'),
  (9, 'William', 'Anderson', 'Male', 63000, 'Engineering'),
  (10, 'Ava', 'Thomas', 'Female', 54000, 'Engineering'),
  (11, 'Alexander', 'Lee', 'Male', 62000, 'HR'),
  (12, 'Charlotte', 'Wilson', 'Female', 68000, 'HR'),
  (13, 'Daniel', 'Miller', 'Male', 59000, 'HR'),
  (14, 'Mia', 'Martin', 'Female', 51000, 'Operations'),
  (15, 'David', 'Clark', 'Male', 57000, 'Operations'),
  (16, 'Emma', 'Hall', 'Female', 66000, 'Operations'),
  (17, 'James', 'Wright', 'Male', 54000, 'Operations'),
  (18, 'Grace', 'Lewis', 'Female', 59000, 'Operations'),
  (19, 'Benjamin', 'Young', 'Male', 63000, 'Operations'),
  (20, 'Abigail', 'Turner', 'Female', 57000, 'Operations');

  
--Employees with Maximum Salary for Each Department:
--------------------------------------------------------
SELECT id, first_name, last_name, gender, salary, dept
FROM (
  SELECT id, first_name, last_name, gender, salary, dept,
    ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) AS rn
  FROM ORG.EMPLOYEE.SALARY
) sub
WHERE rn = 1;


--highest and 2nd highest from each department
------------------------------------------------
SELECT dept, 
       MAX(CASE WHEN rank = 1 THEN CONCAT(first_name, ' ', last_name) END) AS highest_salary_employee,
       MAX(CASE WHEN rank = 1 THEN salary END) AS highest_salary,
       MAX(CASE WHEN rank = 2 THEN CONCAT(first_name, ' ', last_name) END) AS second_highest_salary_employee,
       MAX(CASE WHEN rank = 2 THEN salary END) AS second_highest_salary
FROM (
  SELECT dept, first_name, last_name, salary,
         ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) AS rank
  FROM ORG.EMPLOYEE.SALARY
) sub
WHERE rank <= 2
GROUP BY dept;



-- add some duplicate records to salary table
---------------------------------------------
DESC TABLE ORG.EMPLOYEE.SALARY;
SELECT * FROM ORG.EMPLOYEE.SALARY;

INSERT INTO ORG.EMPLOYEE.SALARY (id, first_name, last_name, gender, salary, dept)
VALUES 
(21, 'John', 'Doe', 'Male', 50000, 'Sales'),
(22, 'John', 'Doe', 'Male', 50000, 'Sales');


-- find duplicates
-------------------------------------------------
SELECT first_name, last_name, gender, salary, dept, COUNT(*) AS duplicate_count
FROM ORG.EMPLOYEE.SALARY
GROUP BY first_name, last_name, gender, salary, dept
HAVING COUNT(*) > 1;

-- delete duplicates
---------------------
DELETE FROM ORG.EMPLOYEE.SALARY WHERE id IN 
(SELECT id FROM 
(SELECT id, 
        ROW_NUMBER() OVER (PARTITION BY first_name, last_name, gender, salary, dept ORDER BY id) AS rn
FROM ORG.EMPLOYEE.SALARY) sub
WHERE rn > 1);



-- create new employee benefits table
---------------------------------------
CREATE OR REPLACE TABLE ORG.EMPLOYEE.EMPLOYEE_BENEFITS (
  id NUMBER,
  first_name VARCHAR,
  last_name VARCHAR,
  health_insurance VARCHAR,
  retirement_plan VARCHAR,
  vacation_days INT,
  CONSTRAINT fk_employee FOREIGN KEY (id) REFERENCES SALARY (id)
);

DESC TABLE EMPLOYEE_BENEFITS;
SELECT * FROM EMPLOYEE_BENEFITS;

-- insert date into employee_benefits table
--------------------------------------------
INSERT INTO EMPLOYEE_BENEFITS (id, first_name, last_name, health_insurance, retirement_plan, vacation_days)
VALUES
  (1, 'John', 'Doe', 'Yes', '401(k)', 15),
  (2, 'Jane', 'Smith', 'No', 'None', 10),
  (3, 'Michael', 'Johnson', 'Yes', 'Pension', 20),
  (4, 'Emily', 'Williams', 'Yes', '401(k)', 12),
  (5, 'Matthew', 'Brown', 'No', 'None', 18),
  (6, 'Sophia', 'Jones', 'Yes', '401(k)', 14),
  (7, 'Christopher', 'Taylor', 'Yes', 'Pension', 16),
  (8, 'Olivia', 'Davis', 'Yes', '401(k)', 13),
  (9, 'William', 'Anderson', 'No', 'None', 11),
  (10, 'Ava', 'Thomas', 'Yes', '401(k)', 17),
  (11, 'Alexander', 'Lee', 'Yes', 'Pension', 15),
  (12, 'Charlotte', 'Wilson', 'Yes', '401(k)', 10),
  (13, 'Daniel', 'Miller', 'No', 'None', 12),
  (14, 'Mia', 'Martin', 'Yes', '401(k)', 15),
  (15, 'David', 'Clark', 'Yes', 'Pension', 14),
  (16, 'Emma', 'Hall', 'Yes', '401(k)', 12),
  (17, 'James', 'Wright', 'No', 'None', 18),
  (18, 'Grace', 'Lewis', 'Yes', '401(k)', 16),
  (19, 'Benjamin', 'Young', 'Yes', 'Pension', 13),
  (20, 'Abigail', 'Turner', 'Yes', '401(k)', 15);


-- total salary and avg vacation days by department
----------------------------------------------------
SELECT s.dept, SUM(s.salary) AS total_salary, AVG(eb.vacation_days) AS avg_vacation_days
FROM ORG.EMPLOYEE.SALARY s
JOIN ORG.EMPLOYEE.EMPLOYEE_BENEFITS eb ON s.id = eb.id
GROUP BY s.dept;

SELECT * FROM ORG.EMPLOYEE.EMPLOYEE_BENEFITS;

-- find employees with no retirement plan
------------------------------------------
SELECT s.dept, COUNT(*) AS employee_count,
       ARRAY_AGG(CONCAT(s.first_name, ' ', s.last_name)) AS employees_without_retirement
FROM ORG.EMPLOYEE.SALARY s
LEFT JOIN ORG.EMPLOYEE.EMPLOYEE_BENEFITS eb ON s.id = eb.id
WHERE eb.retirement_plan IS NULL OR eb.retirement_plan = 'None'
GROUP BY s.dept;


-- find employees with max salary from each department and their retirement plan
-------------------------------------------------------------------------------
SELECT s.dept, s.first_name, s.last_name, s.salary, eb.retirement_plan
FROM SALARY s
JOIN EMPLOYEE_BENEFITS eb ON s.id = eb.id
WHERE (s.dept, s.salary) IN (
  SELECT dept, MAX(salary)
  FROM SALARY
  GROUP BY dept)
ORDER BY s.dept;

