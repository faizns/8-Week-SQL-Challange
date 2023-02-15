/*
--------------
DATA CLEANING
--------------
*/

-- Column : customer_orders
-- Create table
CREATE TABLE cleaned_customer_order AS
WITH order_cte AS (
	SELECT
		order_id,
		customer_id,
		pizza_id,
		CASE 
			WHEN exclusions IN ('null', '') THEN '0'
			ELSE exclusions
			END AS exclusions,
		CASE 
			WHEN extras IS NULL OR extras IN ('null', '') THEN '0'
			ELSE extras
			END AS extras,
		order_time
	FROM customer_orders),
	
-- add number columns each order & pizza
order_number_cte AS (
	SELECT 
		ROW_NUMBER() OVER(order by order_id, pizza_id) AS numbers, * 
	FROM order_cte),

-- split exclusion and covert to integer
exclusion_cte AS (
	SELECT
		numbers, order_id, customer_id, pizza_id,
		REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+'):: INTEGER AS exclusions,
		extras,
		order_time
	FROM order_number_cte)

-- split extras and covert to integer
	SELECT
		numbers, order_id, customer_id, pizza_id, exclusions,
		REGEXP_SPLIT_TO_TABLE(extras, '[,\s]+'):: INTEGER AS extras,
		order_time
	FROM exclusion_cte
	
	
-- -----------------------------------------------------------------------------------	

-- Columns : runner_orders
-- Create temporary table
CREATE TABLE cleaned_runner_orders AS
SELECT 
	order_id,
	runner_id,
	CASE
		WHEN pickup_time LIKE 'null' THEN NULL
		ELSE pickup_time::timestamp
		END AS pickup_time,
	CASE
		WHEN distance LIKE 'null' THEN 0
		WHEN distance LIKE '%km' THEN TRIM('km' FROM distance):: FLOAT
		ELSE distance:: FLOAT
		END AS distance,
	CASE
		WHEN duration LIKE 'null' THEN 0
		WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration):: INTEGER
		WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration):: INTEGER
		WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration):: INTEGER
		ELSE duration:: INTEGER
		END AS duration,
	CASE 
		WHEN cancellation LIKE 'null' THEN ''
		WHEN cancellation IS NULL THEN ''
		ELSE cancellation
		END AS cancellation
FROM runner_orders


-- -----------------------------------------------------------------------------------	

-- Column : pizza_names
-- corvert datatype text to varchar
CREATE TABLE cleaned_pizza_names AS
	SELECT 
		pizza_id,
		CAST(pizza_name AS varchar) AS pizza_name
	FROM pizza_names
	
	
-- -----------------------------------------------------------------------------------	
    
-- Column : pizza_recipes
CREATE TABLE cleaned_pizza_recipes AS
	SELECT
		pizza_id,
		REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER toppings
FROM pizza_recipes 
ORDER BY 1


-- -----------------------------------------------------------------------------------	

-- Column : pizza_topping
CREATE TABLE cleaned_pizza_toppings AS
	SELECT 
		topping_id,
		CAST(topping_name AS varchar) AS topping_name
	FROM pizza_toppings
	
