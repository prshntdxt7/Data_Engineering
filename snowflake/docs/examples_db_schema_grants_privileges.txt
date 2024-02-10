CREATE SCHEMA University;

CREATE OR REPLACE TABLE ORG.UNIVERSITY.STUDENTS(
  StudentID NUMBER(38,0),
  StudentName VARCHAR(50),
  Marks NUMBER(38,0));

SELECT * FROM ORG.UNIVERSITY.STUDENTS;

INSERT INTO ORG.UNIVERSITY.Students(StudentID, StudentName, Marks)
VALUES
  (1, 'John', 85),
  (2, 'Emily', 92),
  (3, 'Michael', 77),
  (4, 'Sophia', 92),
  (5, 'William', 88),
  (6, 'Olivia', 77),
  (7, 'James', 85),
  (8, 'Emma', 88),
  (9, 'Daniel', 95),
  (10, 'Ava', 95);

--DENSE_RANK():
SELECT StudentName, Marks,
DENSE_RANK() OVER (ORDER BY Marks DESC) AS DenseRank
FROM ORG.UNIVERSITY.Students;

--RANK():
SELECT StudentName, Marks, 
RANK() OVER (ORDER BY Marks DESC) AS Rank
FROM ORG.UNIVERSITY.Students;

--ROW_NUMBER():
SELECT StudentName, Marks, 
ROW_NUMBER() OVER (ORDER BY Marks DESC) AS RowNumber
FROM ORG.UNIVERSITY.Students;


/*RANK() Function:
Think of a rank as an athlete's position in a race. When you use the RANK() function, it assigns a rank to each row based on a specified column's value. 
If two or more rows have the same value, they will be assigned the same rank, and the subsequent rank will be incremented by the number of tied rows.
For example, if two participants finish with the same time in a race, they would both receive the same rank, and the next participant would be assigned a rank based on their finishing position.

DENSE_RANK() Function:
The DENSE_RANK() function is similar to RANK(), but it handles ties differently.
Imagine you have a group of people with the same test score. In this case, the DENSE_RANK() function would assign the same rank to all the individuals 
with the same score, without leaving any gaps. For example, if two students receive the highest score in a class, they would both be ranked 1, and the next student
would be ranked 2, even though there was a tie for the top score.

ROW_NUMBER() Function:
The ROW_NUMBER() function assigns a unique number to each row in the result set, regardless of the values in other rows.
Think of it as labeling each row with a sequential number. It doesn't consider ties or the values in other rows. 
This function is commonly used to add a unique identifier or create a simple counter for the rows.


Use RANK() when you want to assign ranks to rows based on a specific column's value and handle ties by leaving gaps between ranks.
Use DENSE_RANK() when you want to assign ranks to rows based on a specific column's value and handle ties by giving the same rank to tied rows, 
without leaving gaps. 
Use ROW_NUMBER() when you want to assign a unique number to each row, without considering ties or the values in other rows.
*/

CREATE OR REPLACE SCHEMA ORG.SALES;

CREATE OR REPLACE TABLE SALES.CUSTOMER_ORDERS (
  order_id NUMBER(38,0),
  customer_id NUMBER(38,0),
  order_date DATE,
  product_name VARCHAR,
  order_value DECIMAL(10, 2)
);
SELECT * FROM SALES.CUSTOMER_ORDERS;

INSERT INTO SALES.CUSTOMER_ORDERS (order_id, customer_id, order_date, product_name, order_value)
VALUES
  (1, 1001, '2023-06-15', 'Product A', 50.00),
  (2, 1001, '2023-06-30', 'Product B', 80.00),
  (3, 1002, '2023-06-25', 'Product A', 100.00),
  (4, 1002, '2023-07-05', 'Product B', 120.00),
  (5, 1002, '2023-07-15', 'Product C', 70.00),
  (6, 1003, '2023-06-10', 'Product A', 200.00),
  (7, 1004, '2023-06-12', 'Product B', 90.00),
  (8, 1004, '2023-06-29', 'Product C', 150.00),
  (9, 1004, '2023-07-02', 'Product A', 120.00),
  (10, 1005, '2023-06-20', 'Product B', 80.00),
  (11, 1005, '2023-07-05', 'Product C', 60.00),
  (12, 1005, '2023-07-15', 'Product A', 100.00),
  (13, 1006, '2023-06-08', 'Product A', 70.00),
  (14, 1006, '2023-06-20', 'Product B', 90.00),
  (15, 1006, '2023-07-01', 'Product C', 80.00),
  (16, 1006, '2023-07-10', 'Product A', 60.00),
  (17, 1007, '2023-06-05', 'Product B', 100.00),
  (18, 1007, '2023-06-25', 'Product C', 70.00),
  (19, 1008, '2023-06-18', 'Product A', 120.00),
  (20, 1008, '2023-07-03', 'Product B', 90.00);

