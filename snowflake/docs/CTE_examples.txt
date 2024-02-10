CREATE OR REPLACE TABLE ORG.SALES.PRODUCTS (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  unit_price DECIMAL(10, 2));

CREATE OR REPLACE TABLE ORG.SALES.SALES (
  sale_id INT PRIMARY KEY,
  product_id INT,
  sale_date DATE,
  quantity_sold INT);

-- LOAD this using copy into command
INSERT INTO ORG.SALES.PRODUCTS (product_id, product_name, unit_price)
VALUES
  (1, 'Chips', 10.99),
  (2, 'Chocolate', 15.99),
  (3, 'Bread', 8.99),
  (4, 'Butter', 12.49),
  (5, 'Milk', 9.99),
  (6, 'Wafers', 7.99),
  (7, 'Mentos', 14.99),
  (8, 'Coffee', 11.99),
  (9, 'Tea', 6.99),
  (10, 'Whey', 13.49);

SELECT * FROM ORG.SALES.PRODUCTS;
SELECT * FROM ORG.SALES.SALES;

--1. Rank products by total quantity sold
------------------------------------------
WITH ranked_products AS (
  SELECT
    product_id,
    product_name,
    SUM(quantity_sold) AS total_quantity_sold,
    RANK() OVER (ORDER BY SUM(quantity_sold) DESC) AS rank
  FROM ORG.SALES.SALES
  JOIN ORG.SALES.PRODUCTS USING (product_id)
  GROUP BY product_id, product_name
)
SELECT
  rank,
  product_name,
  total_quantity_sold
FROM ranked_products;


--2  Calculate the running total of sales for each product
-- (a running total refers to the cumulative sum of a specific quantity over a specified order. The running total keeps accumulating as the order progresses)
----------------------------------------------------------
WITH product_sales AS (
  SELECT
    product_id,
    sale_date,
    quantity_sold,
    SUM(quantity_sold) OVER (PARTITION BY product_id ORDER BY sale_date) AS running_total
  FROM ORG.SALES.SALES
)
SELECT
  product_id,
  sale_date,
  quantity_sold,
  running_total
FROM product_sales;


--3 products with below-average sales quantity
-----------------------------------------------
WITH avg_sales AS (
  SELECT AVG(quantity_sold) AS average_quantity_sold
  FROM ORG.SALES.SALES
)
SELECT
  product_id,
  product_name,
  quantity_sold
FROM ORG.SALES.SALES
JOIN ORG.SALES.PRODUCTS USING (product_id)
WHERE quantity_sold < (SELECT average_quantity_sold FROM avg_sales);


--4 Identify the month with the highest sales for each product
--------------------------------------------------------------
WITH product_monthly_sales AS (
  SELECT
    product_id,
    EXTRACT(MONTH FROM sale_date) AS sale_month,
    SUM(quantity_sold) AS monthly_sales
  FROM ORG.SALES.SALES
  GROUP BY product_id, EXTRACT(MONTH FROM sale_date)
),

max_sales_per_product AS (
  SELECT
    product_id,
    sale_month,
    monthly_sales,
    RANK() OVER (PARTITION BY product_id ORDER BY monthly_sales DESC) AS rank
  FROM product_monthly_sales
)

SELECT
  product_id,
  sale_month,
  monthly_sales
FROM max_sales_per_product
WHERE rank = 1;



--5 Analyze the sales performance of each product and classify them 
--as "High (total_quantity_sold over 1k)," "Medium (total_quantity_sold 0.5k - 1k)," or "Low" sales categories based on total sales.
-------------------------------------------------------------
WITH product_sales AS (
  SELECT
    product_id,
    product_name,
    SUM(quantity_sold) AS total_quantity_sold
  FROM ORG.SALES.SALES
  JOIN ORG.SALES.PRODUCTS USING (product_id)
  GROUP BY product_id, product_name
)
SELECT
  product_id,
  product_name,
  total_quantity_sold,
  CASE
    WHEN total_quantity_sold >= 50 THEN 'High'
    WHEN total_quantity_sold >= 25 THEN 'Medium'
    ELSE 'Low'
  END AS sales_category
FROM product_sales
ORDER BY sales_category;









