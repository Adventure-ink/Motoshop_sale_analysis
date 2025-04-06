/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	ROUND(AVG(avg_price) OVER (ORDER BY order_date),2) AS moving_average_price
FROM
(
    SELECT 
        DATE_FORMAT(order_date,'%Y-%m-01') AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date,'%Y-%m-01')
) t;

-- calculating running total and resetting every year 

WITH rt AS(
SELECT 
        DATE_FORMAT(order_date,'%Y-%m-01') AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date,'%Y-%m-01'))
    
    SELECT 
			order_date,total_sales,
            SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales,
            ROUND(AVG(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date),2) AS moving_avg_price
	FROM rt
    ORDER BY order_date;