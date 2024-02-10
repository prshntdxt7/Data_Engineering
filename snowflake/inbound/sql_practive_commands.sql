-- Create time table with date_of_joining column
----------------------------------------------------------------------
CREATE OR REPLACE TABLE ORG.EMPLOYEE.TIME (
  id NUMBER,
  first_name VARCHAR,
  last_name VARCHAR,
  gender VARCHAR,
  date_of_joining DATE);


  SELECT * FROM TIME;
-- Insert data into this new time table
-----------------------------------------------------------------------------------  
INSERT INTO ORG.EMPLOYEE.TIME (id, first_name, last_name, gender, date_of_joining)
VALUES
  (1, 'John', 'Doe', 'Male', '1997-01-15'),
  (2, 'Jane', 'Smith', 'Female', '2003-02-20'),
  (3, 'Michael', 'Johnson', 'Male', '1998-03-10'),
  (4, 'Emily', 'Williams', 'Female', '1996-04-05'),
  (5, 'Matthew', 'Brown', 'Male', '2012-05-12'),
  (6, 'Sophia', 'Jones', 'Female', '2014-06-08'),
  (7, 'Christopher', 'Taylor', 'Male', '2014-07-01'),
  (8, 'Olivia', 'Davis', 'Female', '2015-08-18'),
  (9, 'William', 'Anderson', 'Male', '2007-09-22'),
  (10, 'Ava', 'Thomas', 'Female', '2021-10-14'),
  (11, 'Alexander', 'Lee', 'Male', '2022-11-26'),
  (12, 'Charlotte', 'Wilson', 'Female', '2022-12-19'),
  (13, 'Daniel', 'Miller', 'Male', '2023-01-07'),
  (14, 'Mia', 'Martin', 'Female', '2023-02-11'),
  (15, 'David', 'Clark', 'Male', '2023-03-03'),
  (16, 'Emma', 'Hall', 'Female', '2001-04-25'),
  (17, 'James', 'Wright', 'Male', '2003-05-18'),
  (18, 'Grace', 'Lewis', 'Female', '2007-06-09'),
  (19, 'Benjamin', 'Young', 'Male', '2011-07-22'),
  (20, 'Abigail', 'Turner', 'Female', '2017-08-31');


  
-- Find oldest employee for each departemnt with total work experience
----------------------------------------------------------------------
SELECT dept, oldest_employee_name, total_years_of_experience
FROM (
    SELECT s.dept,
           CONCAT(s.first_name, ' ', s.last_name) AS oldest_employee_name,
           DATEDIFF('YEAR', t.date_of_joining, CURRENT_DATE()) AS total_years_of_experience,
           ROW_NUMBER() OVER (PARTITION BY s.dept ORDER BY t.date_of_joining ASC) AS row_num
    FROM ORG.EMPLOYEE.SALARY s
    JOIN ORG.EMPLOYEE.TIME t ON s.id = t.id
    WHERE t.date_of_joining = (SELECT MIN(date_of_joining) FROM time WHERE id = s.id)
) AS temp
WHERE row_num = 1;


-- identify employees who are eligible for an extended vacation based on their gender and years of service, assume that: 
--    female employees with more than 5 years of service
--    and male employees with more than 10 years of service
-- qualify for an extended vacation.
---------------------------------------------------------------------------------------------------------------------------
SELECT s.id,
       CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       s.gender,
       t.date_of_joining,
       DATEDIFF('YEAR', t.date_of_joining, CURRENT_DATE()) AS years_of_service,
       CASE
           WHEN s.gender = 'Female' AND DATEDIFF('YEAR', t.date_of_joining, CURRENT_DATE()) > 5 THEN 'Eligible for Extended Vacation'
           WHEN s.gender = 'Male' AND DATEDIFF('YEAR', t.date_of_joining, CURRENT_DATE()) > 10 THEN 'Eligible for Extended Vacation'
           ELSE 'Not Eligible for Extended Vacation'
       END AS eligibility_status
FROM ORG.EMPLOYEE.SALARY s
JOIN ORG.EMPLOYEE.TIME t ON s.id = t.id
WHERE t.date_of_joining = (SELECT MIN(date_of_joining) FROM time WHERE id = s.id);



-- elaborate joins, end show scenarios
-- mostly used functions here in daily scenario