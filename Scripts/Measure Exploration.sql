/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/
SELECT * from sales;
desc sales;
-- Find the Total Sales

SELECT 
		SUM(sales_amount) AS Total_sales 
FROM 	sales;

-- Find how many items are sold

SELECT 
		SUM(quantity) AS quantity_sold 
FROM 	sales;

-- Find the average selling price
SELECT 
		ROUND(AVG(price),2) AS avg_selling_price
FROM 	sales;


-- Find the Total number of Orders
SELECT 
		COUNT(DISTINCT(order_number)) AS total_order
FROM 	sales;
-- Find the total number of products

SELECT 
		COUNT(DISTINCT(product_name)) AS total_number_of_products
FROM 	products;

-- Find the total number of customers 

SELECT 
		COUNT(DISTINCT(customer_id)) AS total_customers 
FROM 	customers;

-- Find the total number of customers that has placed an order
SELECT 
		COUNT(DISTINCT(c.customer_id)) AS active_customer 
FROM 	customers c INNER JOIN sales s 
ON 		c.customer_key=s.customer_key;

-- Generate a Report that shows all key metrics of the business 

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM sales
UNION ALL
SELECT 'Average Price',ROUND(AVG(price),2) FROM sales
UNION ALL
SELECT 'Total Orders',COUNT(DISTINCT(order_number)) AS total_order FROM sales
UNION ALL
SELECT 'Total Products',COUNT(DISTINCT(product_name)) AS total_number_of_products FROM products
UNION ALL
SELECT  'Total Customer',COUNT(DISTINCT(customer_id)) AS total_customers FROM customers
UNION ALL
SELECT  'Active Customer',COUNT(DISTINCT(c.customer_id)) AS active_customer 
FROM 	customers c INNER JOIN sales s 
ON 		c.customer_key=s.customer_key;

