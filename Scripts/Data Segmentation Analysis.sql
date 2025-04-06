/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;


/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

SELECT * FROM sales;

WITH t1 AS(
SELECT  
		c.customer_key,
        SUM(s.quantity*s.price) AS total_spending,
        MIN(s.order_date) AS first_order,
        MAX(s.order_date) AS last_order,
        TIMESTAMPDIFF(MONTH,MIN(s.order_date),MAX(s.order_date)) AS lifespan
        
FROM 	customers c LEFT JOIN sales s 
ON 		c.customer_key = s.customer_key
GROUP BY  c.customer_key),

customer AS(
SELECT customer_key,
	   CASE WHEN total_spending > 5000 AND lifespan >=12 THEN 'VIP' 
			WHEN total_spending <= 5000 AND lifespan >=12 THEN 'Regular'
			WHEN lifespan < 12 THEN 'New' END AS customer_segment
FROM   t1)

SELECT customer_segment, COUNT(customer_key) AS total_customer
FROM     customer
GROUP BY customer_segment;


