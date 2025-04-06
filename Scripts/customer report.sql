/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: customers
CREATE VIEW customer_report AS(
-- =============================================================================




WITH base_query AS( 
-- =============================================================================
-- 1) Base Query View: Clean version
-- =============================================================================
SELECT  
    c.customer_key,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.country,
    c.gender,
    TIMESTAMPDIFF(YEAR, c.birthdate, CURDATE()) AS customer_age,
    s.order_number,
    s.order_date,
    s.product_key,
    s.quantity,
    (s.quantity * s.price) AS total_revenue
FROM customers c
LEFT JOIN sales s ON c.customer_key = s.customer_key
WHERE s.order_date IS NOT NULL),

-- =============================================================================
-- 2) Summary CTE
-- =============================================================================
summary AS (
    SELECT 
        customer_key,
        customer_id,
        customer_name,
        customer_age,
        COUNT(DISTINCT order_number) AS total_order,
        COUNT(DISTINCT product_key) AS total_product,
        MAX(order_date) AS last_order_date,
        SUM(IFNULL(quantity, 0)) AS total_quantity,
        SUM(IFNULL(total_revenue, 0)) AS revenue,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months
    FROM base_query
    GROUP BY customer_key, customer_id, customer_name, customer_age
)

-- =============================================================================
-- 3) Final Report View
-- =============================================================================
SELECT 
    customer_key,
    customer_id,
    customer_name,
    customer_age,
    -- Age Group
    CASE 
        WHEN customer_age < 20 THEN 'below 20'
        WHEN customer_age BETWEEN 20 AND 29 THEN '20-30'
        WHEN customer_age BETWEEN 30 AND 39 THEN '30-40'
        WHEN customer_age BETWEEN 40 AND 49 THEN '40-50'
        ELSE 'Above 50'
    END AS age_group,
    
    -- Customer Segment
    CASE 
        WHEN lifespan_months >= 12 AND revenue > 5000 THEN 'VIP'
        WHEN lifespan_months >= 12 AND revenue <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_group,

    total_order,
    total_quantity,
    total_product,
    revenue,
    last_order_date,
    lifespan_months,

    -- Recency
    TIMESTAMPDIFF(MONTH, last_order_date, CURDATE()) AS recency,

    -- Average Revenue
    CASE WHEN total_order = 0 THEN 0
         ELSE ROUND(revenue / total_order, 2)
    END AS avg_revenue,

    -- Monthly Spend
    CASE WHEN lifespan_months = 0 THEN revenue
         ELSE ROUND(revenue / lifespan_months, 2)
    END AS avg_monthly_revenue

FROM summary

);


SELECT * FROM customer_report;