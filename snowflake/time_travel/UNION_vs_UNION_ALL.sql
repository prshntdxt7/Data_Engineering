CREATE OR REPLACE TABLE EMPLOYEES (id INT, name VARCHAR(50), department VARCHAR(50));
INSERT INTO EMPLOYEES (id, name, department) VALUES (1, 'John', 'HR'), (2, 'Alice', 'Finance'), (3, 'Bob', 'IT'), (4, 'John', 'HR'), (5, 'Mary', 'IT');
SELECT * FROM EMPLOYEES;
'---------------------------------------------------------------------------------------------------------------------------------------------------------'
CREATE OR REPLACE TABLE contractors (id INT, name VARCHAR(50), department VARCHAR(50));
INSERT INTO CONTRACTORS (id, name, department) VALUES (1, 'Mike', 'HR'), (2, 'Alice', 'Finance'), (3, 'Bob', 'IT'), (4, 'Tom', 'IT'), (5, 'John', 'Finance');
SELECT * FROM CONTRACTORS;

    
'-- UNION removes duplicate rows from the combined result set.'
-------------------------------------------------------------
'-- It performs an implicit sorting operation to remove duplicates, which may add some additional overhead.'
----------------------------------------------------------------------------------------------------------
'-- The column names from the first SELECT statement are used in the final result set.'
-------------------------------------------------------------------------------------

'[implicit sorting]'
'------------------'
"""the term [implicit sorting] is used to describe a behavior that occurs when using certain operations,
such as UNION, INTERSECT, and EXCEPT. 
Unlike traditional relational databases, Snowflake does not guarantee a specific order of rows in the result set unless an explicit ORDER BY clause is used. 
However, Snowflake may internally perform a sorting operation to efficiently handle these set operations and eliminate duplicates.
It's important to note that this implicit sorting behavior is an internal optimization and not something that should be relied upon for obtaining sorted results.
In fact, depending on the size of the tables and the nature of the query, Snowflake's query execution engine might choose different strategies for handling set operations, 
and the order of results may vary if you don't specify an ORDER BY clause explicitly."""

SELECT id, name, department FROM employees
UNION
SELECT id, name, department FROM contractors;
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
'1. UNION ALL does not remove duplicate rows from the combined result set.
 2. It is faster than UNION because it does not need to perform a sorting operation to eliminate duplicates.
 3. The column names from the first SELECT statement are used in the final result set.
-----------------------------------------------------------------------------------------------------------'
SELECT id, name, department FROM employees
UNION ALL
SELECT id, name, department FROM contractors;


'INTERSECT Operator:
--------------------
1. The INTERSECT operator returns only the rows that appear in both result sets of two SELECT queries.
2. It implicitly removes duplicate rows.
3. The column names and data types of the corresponding columns in all SELECT queries must match.'

SELECT id, name, department FROM employees
INTERSECT
SELECT id, name, department FROM contractors;


--The MINUS and EXCEPT set operators 
--------------------------------------
--are used to perform comparisons between two result sets and
--retrieve the rows from the first result set that are not present in the second result set. 
--These operators are used to find the set difference between two sets of rows.
--While the functionality is the same, the operators are synonymous, and we can use either MINUS or EXCEPT in your queries.

SELECT id, name, department FROM employees
EXCEPT
SELECT id, name, department FROM contractors;

