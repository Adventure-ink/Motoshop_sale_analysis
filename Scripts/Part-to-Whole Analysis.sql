/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH categories AS(
SELECT 
		p.category,
        SUM(s.quantity*s.price) AS total_sale
FROM 	products p LEFT JOIN sales s 
ON 		p.product_key = s.product_key
GROUP BY p.category)

SELECT   category,total_sale,
	     ROUND(CAST(total_sale AS FLOAT)/(SUM(total_sale) OVER())*100,2)AS pct_of_sale
FROM     categories
ORDER BY total_sale DESC;






