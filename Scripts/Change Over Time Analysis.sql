/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATE_FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions

SELECT 
		 YEAR(order_date) AS order_year, 
         SUM(quantity*price) AS total_revenue,
         COUNT(DISTINCT(customer_key)) AS total_customer,
         SUM(quantity) AS total_quantity
FROM 	 sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- DATE_FORMAT()
SELECT 
		 DATE_FORMAT(order_date, '%Y-%m-01') AS order_date, 
         SUM(quantity*price) AS total_revenue,
         COUNT(DISTINCT(customer_key)) AS total_customer,
         SUM(quantity) AS total_quantity
FROM 	 sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY order_date;
