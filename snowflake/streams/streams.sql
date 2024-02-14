CREATE DATABASE APP_DB;
CREATE SCHEMA APP_DB.APP_SCHEMA;
"Snowflake Streams:"
"-------------------"
'Snowflake Streams are an asynchronous messaging system within Snowflake, allowing you to capture and propagate changes that occur in a table, making it easier to integrate with external systems, perform data replication, and enable real-time data processing'

-- Creating source table for orders
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

-- Creating target table for aggregated orders
CREATE TABLE aggregated_orders (
    customer_id INT,
    total_orders INT,
    total_amount DECIMAL(10, 2)
);


insert into orders (order_id,customer_id,order_date,total_amount)
values
(6,104,'2024-02-13',100.50),
(7,105,'2024-02-13',200.25),
(8,107,'2024-02-13',50.75),
(9,101,'2024-02-13',150.00),
(10,105,'2024-02-13',75.25);

SELECT * FROM ORDERS;

-- Creating a stream to capture changes in the orders table
CREATE OR REPLACE STREAM orders_stream ON TABLE orders;


-- Creating a task to aggregate orders periodically
CREATE TASK aggregate_orders_task
WAREHOUSE = 'COMPUTE_WH'
SCHEDULE = '5 minute'
WHEN
  SYSTEM$STREAM_HAS_DATA('orders_stream')
AS
  INSERT INTO aggregated_orders
  SELECT customer_id, COUNT(order_id) as total_orders, SUM(total_amount) as total_amount
  FROM orders
  GROUP BY customer_id;

SHOW TASKS;

-- Starting the task
ALTER TASK aggregate_orders_task RESUME;
SELECT * FROM AGGREGATED_ORDERS;


