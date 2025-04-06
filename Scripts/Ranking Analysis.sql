/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
SELECT * from sales;
-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT 
		 p.product_id,
         p.product_name,
         SUM(s.price*s.quantity) AS total_revenue 
FROM 	 sales s LEFT JOIN products p 
ON 		 s.product_key=p.product_key
GROUP BY p.product_id,p.product_name
ORDER BY total_revenue DESC
LIMIT 	 5;

-- Complex but Flexibly Ranking Using Window Functions
WITH ranking AS(
SELECT 	 
		 p.product_id,
         p.product_name,
         SUM(s.price*s.quantity) AS total_revenue 
FROM 	 sales s LEFT JOIN products p 
ON 		 s.product_key=p.product_key
GROUP BY p.product_id,p.product_name)

SELECT  product_id,product_name,total_revenue,
		DENSE_RANK() OVER(ORDER BY total_revenue DESC) AS product_rank
FROM ranking;

-- What are the 5 worst-performing products in terms of sales?
SELECT 
		 p.product_id,
         p.product_name,
         SUM(s.price*s.quantity) AS total_revenue 
FROM 	 sales s LEFT JOIN products p 
ON 		 s.product_key=p.product_key
GROUP BY p.product_id,p.product_name
ORDER BY total_revenue
LIMIT 	 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT 
		 c.customer_key, 
         CONCAT(c.first_name," ",c.last_name) AS customer_name,
		 SUM(s.price*s.quantity) AS total_revenue
FROM 	 customers c LEFT JOIN sales s 
ON 		 c.customer_key=s.customer_key
GROUP BY c.customer_key,customer_name
ORDER BY total_revenue DESC
LIMIT 10;


-- The 3 customers with the fewest orders placed
WITH lrc AS
(SELECT 
		 c.customer_key, 
         CONCAT(c.first_name," ",c.last_name) AS customer_name,
		 SUM(s.price*s.quantity) AS total_revenue
FROM 	 customers c LEFT JOIN sales s 
ON 		 c.customer_key=s.customer_key
GROUP BY c.customer_key,customer_name),

low_ranking AS
(SELECT *,
       DENSE_RANK() OVER(ORDER BY total_revenue) AS low_rev_rank
FROM   lrc)

SELECT * FROM low_ranking WHERE low_rev_rank <=3