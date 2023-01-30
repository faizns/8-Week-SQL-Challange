--------------------------------
--Case Study #1 - Danny's Diner
--------------------------------

CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');


------------------------
-- Case Study Questions
------------------------

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
	customer_id,
	SUM(price) AS total_amount
FROM sales AS s
JOIN menu AS m
	ON s.product_id = m.product_id
GROUP BY 1
ORDER BY 2 DESC


-- 2. How many days has each customer visited the restaurant?
SELECT 
	customer_id,
	COUNT(DISTINCT (order_date)) AS days_count
FROM sales
GROUP BY 1


-- 3. What was the first item from the menu purchased by each customer?
WITH item_order AS
(
	SELECT
		customer_id,
		order_date,
		product_name,
		DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
	FROM sales AS s
	JOIN menu AS m
		ON s.product_id = m.product_id
	)
SELECT
	customer_id,
	product_name
FROM item_order
WHERE rank = 1
GROUP BY 1, 2


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
	product_name,
	COUNT(product_name) AS total_sold
FROM sales AS s
JOIN menu AS m
	ON s.product_id = m.product_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1


-- 5. Which item was the most popular for each customer?
WITH popular_item AS
(
	SELECT
		customer_id,
		product_name,
		DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(m.product_name) DESC) AS rank
	FROM sales AS s
	JOIN menu AS m
		ON s.product_id = m.product_id
	GROUP BY 1, 2
	)
SELECT 
	customer_id,
	product_name
FROM popular_item
WHERE rank = 1


-- 6. Which item was purchased first by the customer after they became a member?
WITH item_after_member AS
(
	SELECT
		s.customer_id,
		order_date,
		join_date,
		product_id,
		DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
	FROM sales AS s
	JOIN members AS b
		ON s.customer_id = b.customer_id
	WHERE order_date > join_date
	)
SELECT 
	customer_id,
	order_date,
	join_date,
	product_name
FROM item_after_member AS i
JOIN menu as m
	ON i.product_id = m.product_id
WHERE rank = 1
ORDER BY 1


-- 7. Which item was purchased just before the customer became a member?
WITH item_before_member AS
(
	SELECT
		s.customer_id,
		order_date,
		join_date,
		product_id,
		DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rank
	FROM sales AS s
	JOIN members AS b
		ON s.customer_id = b.customer_id
	WHERE order_date < join_date
	)
SELECT 
	customer_id,
	order_date,
	join_date,
	product_name
FROM item_before_member AS i
JOIN menu as m
	ON i.product_id = m.product_id
WHERE rank = 1
ORDER BY 1


-- 8. What is the total items and amount spent for each member before they became a member?
SELECT
	s.customer_id,
	COUNT(DISTINCT (s.product_id)) AS total_item,
	SUM(price) AS total_amount
FROM sales AS s
JOIN menu AS m
	ON s.product_id = m.product_id
JOIN members AS b
	ON s.customer_id = b.customer_id
WHERE order_date < join_date
GROUP BY 1


-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
WITH menu_point AS 
(
	SELECT *,
		CASE 
			WHEN product_id = 1 THEN price * 20
			ELSE price * 10
		END AS points
	FROM menu
	)
SELECT 
	customer_id,
	SUM(points) AS total_point
FROM sales AS s
JOIN menu_point AS mp
	ON s.product_id = mp.product_id
GROUP BY 1
ORDER BY 1


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi — how many points do customer A and B have at the end of January?
SELECT 
	s.customer_id,
	SUM(
		CASE
			WHEN (order_date < join_date) OR (order_date > (join_date + 6)) THEN
				CASE 
					WHEN s.product_id = 1 THEN price * 20
					ELSE price * 10
				END
			ELSE price * 20
		END
	) AS member_points
FROM sales AS s
JOIN members AS b
	ON s.customer_id = b.customer_id
JOIN menu AS m
	ON s.product_id = m.product_id
WHERE s.order_date <= '2021-01-31'
GROUP BY 1


-- Bonus 1
SELECT 
	s.customer_id, 
	s.order_date, 
	m.product_name, 
	m.price,
	CASE
		WHEN mb.join_date > s.order_date THEN 'N'
		WHEN mb.join_date <= s.order_date THEN 'Y'
		ELSE 'N'
	END AS member
FROM sales AS s
LEFT JOIN menu AS m
	ON s.product_id = m.product_id
LEFT JOIN members AS mb
	ON s.customer_id = mb.customer_id


-- Bonus 2
WITH summary AS
(
	SELECT 
		s.customer_id, 
		s.order_date, 
		m.product_name, 
		m.price,
		CASE
			WHEN mb.join_date > s.order_date THEN 'N'
			WHEN mb.join_date <= s.order_date THEN 'Y'
			ELSE 'N'
		END AS member
	FROM sales AS s
	LEFT JOIN menu AS m
		ON s.product_id = m.product_id
	LEFT JOIN members AS mb
		ON s.customer_id = mb.customer_id
	)
SELECT *,
	CASE
		WHEN member = 'Y' THEN
			RANK () OVER(PARTITION BY customer_id, member ORDER BY order_date) 
		ELSE NULL
	END AS ranking
FROM summary
