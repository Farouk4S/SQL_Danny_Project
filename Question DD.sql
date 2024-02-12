/* This is my Danny Restaurant Analsis Project code answered.

# File:         01_01_Danny_Diner_Analysis
# Project:      Danny Diner Restaurant Analysis Project
# Title:        How users 
# Subtitle:     Dail   */



--- 1.0 What is the total amount each customer spent at the restaurant?
/*
SELECT customer_id, SUM (price)
FROM sales as s
JOIN menu as mn
ON s.product_id = mn.product_id
Group by customer_id; */

--- 2.0 How many days has each customer visited the restaurant?
/*
SELECT customer_id, Count (DISTINCT order_date) as Visit_days
FROM Sales as s
Group by s.customer_id; */

--- 3.0 What was the first item from the menu purchased by each customer?

 /* SELECT S.customer_id, MIN(mn.product_name) AS first_item
 FROM sales as s
 JOIN menu as mn ON s.product_id = mn.product_id
 Group BY customer_id;    */

 --- 4.0 What is the most purchased item on the menu and how many times was it purchased by all customers?
  
SELECT TOP 1 mn.product_name, COUNT (Order_date) as Freq
FROM menu as mn
JOIN sales as s ON mn.product_id = s.product_id
Group BY mn.product_name
ORDER BY Freq DESC;			*/

--- 5.0 Which item was the most popular for each customer?
/*
SELECT TOP 3 s.customer_id, mn.product_name, COUNT (mn.product_name) as pop
FROM menu as mn
JOIN sales as s ON mn.product_id = s.product_id
Group BY s.customer_id, mn.product_name
ORDER BY pop DESC;	

--- OR AS 

SELECT s.customer_id, m.product_name AS most_popular_item, COUNT(*) AS purchase_count
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name
HAVING COUNT(*) = (
    SELECT MAX(sub.purchase_count)
    FROM (
        SELECT s.customer_id, COUNT(*) AS purchase_count
        FROM sales s
        JOIN menu m ON s.product_id = m.product_id
        GROUP BY s.customer_id, m.product_name
    ) AS sub
    WHERE sub.customer_id = s.customer_id	)
															*/

--- 6.0 Which item was purchased first by the customer after they became a member?
/*
---TRIAL
SELECT s.customer_id, m.product_name, MIN (s.order_date)
FROM sales as s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name
HAVING customer_id =  1  ; 

---ACTUAL ANSWER

SELECT m.customer_id, m.product_name AS first_purchase_after_membership
FROM (
    SELECT s.customer_id, s.order_date, m.product_name,
           ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS row_num
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    JOIN members mem ON s.customer_id = mem.customer_id
    WHERE s.order_date >= mem.join_date
) AS m
WHERE m.row_num = 1;
*/

--- 7.0 Which item was purchased just before the customer became a member?

/*
SELECT m.customer_id, m.product_name AS last_purchase_before_membership
FROM (
    SELECT s.customer_id, s.order_date, m.product_name,
           ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS row_num
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    JOIN members mem ON s.customer_id = mem.customer_id
    WHERE s.order_date < mem.join_date
) AS m
WHERE m.row_num = 1;
						*/

--- 8.0 What is the total items and amount spent for each member before they became a member?
/*
SELECT u.customer_id, COUNT(*) AS total_items, SUM (u.price)
FROM
(	SELECT s.customer_id, s.order_date, m.product_name, join_date, m.price
	FROM sales s
		JOIN menu m ON s.product_id = m.product_id
		JOIN members mem ON s.customer_id = mem.customer_id
	WHERE s.order_date < mem.join_date ) as u
GROUP BY u.customer_idL	; */

-- 9.0 If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

/*	TRIAL
SELECT u.customer_id, u.product_name, 10(u.price)
	FROM
	(SELECT s.customer_id, m.product_name, m.price
	FROM sales s
    JOIN menu m ON s.product_id = m.product_id
	WHERE m.product_name != 'sushi') as u

	ACTUAL
	SELECT s.customer_id, 
       SUM(CASE WHEN m.product_name = 'sushi' THEN 2 * m.price ELSE m.price END) * 10 AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;
								*/

---In the first week after a customer joins the program (including their join date) 
---they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

/*
SELECT s.customer_id, order_date, 
SUM(CASE WHEN s.order_date > mn.join_date THEN 2 * m.price ELSE m.price END) * 10 as customer_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mn ON s.customer_id = mn.customer_id 
WHERE s.order_date < 2021-01-31
GROUP BY s.customer_id, order_date	;	*/

