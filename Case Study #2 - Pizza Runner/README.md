# **Case Study #2 - Pizza Runner**

## 🍕 **Business Case**
Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

Danny has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.
<br>

---

## 🍕 **Dataset**
Datasets for this case study:
- `runners`
- `runner_orders`
- `customer_orders`
- `pizza_names`
- `pizza_recipes`
- `pizza_toppings`

### **ERD**

<details>
  <summary>Click to view ERD</summary>

<p align="center">
  <kbd> <img width="800" alt="Pizza Runner" src="https://user-images.githubusercontent.com/115857221/217608267-3308f1c6-ba94-497d-84b7-78797e1c7807.png"> </kbd> <br>
</p>

</details>

### **Table Example**

<details>
  <summary>Click to view table</summary>
<br>
    
**Table 1: `runners`** <br>
The runners table shows the registration_date for each new runner

 **runner_id** | **registration_date** 
:-------------:|:----------------------:
 1             | 2021-01-01             
 2             | 2021-01-03             
 3             | 2021-01-08             
 4             | 2021-01-15             
               
<br>

**Table 2: `customer_orders`** <br>
Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order.

The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.

Note that customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!

The exclusions and extras columns will need to be cleaned up before using them in your queries.

 **order_id** | **customer_id** | **pizza_id** | **exclusions** | **extras** | **order_time**      
:------------:|:---------------:|:------------:|:--------------:|:----------:|:--------------------:
 1            | 101             | 1            |                |            | 2021-01-01 18:05:02  
 2            | 101             | 1            |                |            | 2021-01-01 19:00:52  
 3            | 102             | 1            |                |            | 2021-01-02 23:51:23  
 3            | 102             | 2            |                | NaN        | 2021-01-02 23:51:23  
 4            | 103             | 1            | 4              |            | 2021-01-04 13:23:46  
 4            | 103             | 1            | 4              |            | 2021-01-04 13:23:46  
 4            | 103             | 2            | 4              |            | 2021-01-04 13:23:46  
 5            | 104             | 1            | null           | 1          | 2021-01-08 21:00:29  
 6            | 101             | 2            | null           | null       | 2021-01-08 21:03:13  
 7            | 105             | 2            | null           | 1          | 2021-01-08 21:20:29  
 8            | 102             | 1            | null           | null       | 2021-01-09 23:54:33  
 9            | 103             | 1            | 4              | 1, 5       | 2021-01-10 11:22:59  
 10           | 104             | 1            | null           | null       | 2021-01-11 18:34:49  
 10           | 104             | 1            | 2, 6           | 1, 4       | 2021-01-11 18:34:49  


<br>

**Table 3: `runner_orders`** <br>
After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

There are some known data issues with this table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL! 

 **order_id** | **runner_id** | **pickup_time**     | **distance** | **duration** | **cancellation**        
:------------:|:-------------:|:-------------------:|:------------:|:------------:|:------------------------:
 1            | 1             | 2021-01-01 18:15:34 | 20km         | 32 minutes   |                          
 2            | 1             | 2021-01-01 19:10:54 | 20km         | 27 minutes   |                          
 3            | 1             | 2021-01-03 00:12:37 | 13.4km       | 20 mins      | NaN                      
 4            | 2             | 2021-01-04 13:53:03 | 23.4         | 40           | NaN                      
 5            | 3             | 2021-01-08 21:10:57 | 10           | 15           | NaN                      
 6            | 3             | null                | null         | null         | Restaurant Cancellation  
 7            | 2             | 2020-01-08 21:30:45 | 25km         | 25mins       | null                     
 8            | 2             | 2020-01-10 00:15:02 | 23.4 km      | 15 minute    | null                     
 9            | 2             | null                | null         | null         | Customer Cancellation    
 10           | 1             | 2020-01-11 18:50:20 | 10km         | 10minutes    | null                     
           
<br>
  
**Table 4: `pizza_names`** <br>
At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!

 **pizza_id**| **pizza_name**     
:--------:|:------------:
 1        | Meat Lovers   
 2        | Vegetarian 

<br>

**Table 5: `pizza_recipes`** <br>
Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.

 **pizza_id** | **toppings**            
:------------:|:------------------------:
 1            | 1, 2, 3, 4, 5, 6, 8, 10  
 2            | 4, 6, 7, 9, 11, 12       
           
<br>

**Table 6: `pizza_toppings`** <br>
This table contains all of the topping_name values with their corresponding topping_id value

 **topping_id** | **topping_name** 
:--------------:|:-----------------:
 1              | Bacon             
 2              | BBQ Sauce         
 3              | Beef              
 4              | Cheese            
 5              | Chicken           
 6              | Mushrooms         
 7              | Onions            
 8              | Pepperoni         
 9              | Peppers           
 10             | Salami            
 11             | Tomatoes          
 12             | Tomato Sauce      

<br>
  
</details>

### **Case Study Questions**

<details>
  <summary>Click to view questions</summary>
<br>

**A. Pizza Metrics**
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10 What was the volume of orders for each day of the week?<br>
<br>

**B. Runner and Customer Experience**
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?<br>
<br>

**C. Ingredient Optimisation**
1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
    - Meat Lovers
    - Meat Lovers - Exclude Beef
    - Meat Lovers - Extra Bacon
    - Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
    - For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?<br>
<br>

**D. Pricing and Ratings**
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
    - Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
    - customer_id
    - order_id
    - runner_id
    - rating
    - order_time
    - pickup_time
    - Time between order and pickup
    - Delivery duration
    - Average speed
    - Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?<br>
<br>

**E. Bonus Questions**<br>
If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

<br>
</details>

<br>

---

##  🍕 **Solution**

### 🧼 **Data Cleaning**

#### 🗒 ***Table: customer_orders***

<p align="center">
<kbd><img width="850" alt="unclean order" src="https://user-images.githubusercontent.com/115857221/218916667-5d77908b-e272-4f22-bcd9-fcd5bd44d0dc.png"> </kbd> <br>
</p>
<br>

Looking at the customer_orders table, in the **`exclusions`** and **`extras`** columns there are missing/ blank spaces ' ' and null values, and have two valaues in one rows. <br>
<br>

**Steps :**
- Create new table :
    - Use conditional statement **CASE WHEN** to remove NULL/NaN and 'null' values in `exlusions` and `extras` columns, **replace with 0**
    - Add numbering for each row using **ROW_NUMBER**
    - Use **REGEXP_SPLIT_TO_TABLE** to split the `exclusions` and `extras`, than change datatype to integer <br>
<br>

**Query :**
```sql
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

```
<br>

**Result :**
<p align="center">
<kbd> <img width="850" alt="order_cleaned" src="https://user-images.githubusercontent.com/115857221/218916998-e5992873-5ac3-429a-818d-e6a56ff68dee.png"></kbd> <br>
</p>
<br>

<br>

#### 🗒 ***Table: runner_orders***

<p align="center">
<kbd> <img width="850" alt="runner unclean" src="https://user-images.githubusercontent.com/115857221/218917174-5a5f877e-5380-4ece-ae1c-315084dd42c1.png"></kbd> <br>
</p>
<br>

- In `pickup_time`: remove nulls and replace with NULL
- In `distance`: remove "km" and nulls and replace 0
- In `duration` column: remove "minutes", "minute" and nulls and replace with 0
- In `cancellation` column, remove NULL and null and and replace with blank space ' '.<br>
<br>

**Steps :**
- Create new table
    - Use conditional statement **CASE WHEN** to remove NULL/NaN and 'null' values
    - Use **TRIM** to remove strings in columns `distance` and `duration`
    - Change datatype `pickup_time` to timestamp, `distance` to float, and `duration` to integer <br>
<br>

**Query :**
```sql
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
```
<br>

**Result :**
<p align="center">
<kbd><img width="850" alt="runner clean" src="https://user-images.githubusercontent.com/115857221/218917804-f7a356b5-5374-4346-8e6c-78dbccd1a920.png"></kbd> <br>
</p>
<br>

<br>

#### 🗒 ***Table: pizza_names***

In `pizza_name`, change datatype from **text to varchar**.<br>
<br>                                                         

**Steps :**
- Create new table, change datatype `pizza_name` to varchar
<br>

**Query :**
```sql
CREATE TABLE cleaned_pizza_names AS
SELECT 
    pizza_id,
    CAST(pizza_name AS varchar) AS pizza_name
FROM pizza_names
```
<br>

**Result :**
<p align="center">
<kbd> <img width="300" alt="pizzaname" src="https://user-images.githubusercontent.com/115857221/218918076-524c560e-98e4-4965-9885-bcaebd045ed5.png"> </kbd> <br>
</p>
<br>

<br>

#### 🗒 ***Table: pizza_recipes***
<p align="center">
<kbd> <img width="300" alt="pizza_recipes_un" src="https://user-images.githubusercontent.com/115857221/218918369-81ab7c02-f305-4c53-9f29-fbf8dbf1dc3c.png"></kbd> <br>
</p>
<br>

In `toppings`, split the toppings and change datatype from **to integer**. <br>
<br>

**Steps :**
- Create new table 
    - Use **REGEXP_SPLIT_TO_TABLE** in column `toppings`
    - Change datatype to integer
<br>

**Query :**
```sql
CREATE TABLE cleaned_pizza_recipes AS
SELECT
    pizza_id,
    REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER toppings
FROM pizza_recipes 
ORDER BY 1
```
<br>

**Result :**
<p align="center">
<kbd> <img width="300" alt="recipes_clean" src="https://user-images.githubusercontent.com/115857221/218918539-4727771b-ad87-4334-8820-cf092d1974d8.png"</kbd> <br>
</p>
<br>

<br>

#### 🗒 ***Table: pizza_toppings***

In `topping_names`, change datatype from **text to varchar**. <br>
<br>

**Steps :**
- Create new table, change datatype `topping_names` to varchar

**Query :**
```sql
CREATE TABLE cleaned_pizza_toppings AS
SELECT 
    topping_id,
    CAST(topping_name AS varchar) AS topping_name
FROM pizza_toppings
```
<br>

**Result :**
<p align="center">
<kbd> <img width="300" alt="toping c" src="https://user-images.githubusercontent.com/115857221/218918746-84125820-ebcd-4669-beca-a341b53e1d08.png"> </kbd> <br>
</p>
<br>

<br>

---

### 📈 **A. Pizza Metrics**

#### ***A.1. How many pizzas were ordered?***
#### ***A.2. How many unique customer orders were made?***
#### ***A.3. How many successful orders were delivered by each runner?***
#### ***A.4. How many of each type of pizza was delivered?***
#### ***A.5. How many Vegetarian and Meatlovers were ordered by each customer?***
#### ***A.6. What was the maximum number of pizzas delivered in a single order?***
#### ***A.7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?***
#### ***A.8. How many pizzas were delivered that had both exclusions and extras?***
#### ***A.9. What was the total volume of pizzas ordered for each hour of the day? 10 What was the volume of orders for each day of the week?***
