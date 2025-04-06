/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: 
CREATE VIEW product_report AS(
-- =============================================================================

WITH base_query AS(
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
    SELECT
	    s.order_number,
        s.order_date,
		s.customer_key,
        s.sales_amount,
        s.quantity,
        s.price,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM sales s
    LEFT JOIN products p
        ON s.product_key = p.product_key
    WHERE order_date IS NOT NULL),  -- only consider valid sales dates;
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
  product_segmentation AS(
  SELECT product_key,product_name,category,subcategory,cost,
		 MIN(order_date) AS initial_sale_date,
		 MAX(order_date) AS last_sale_date,
		 TIMESTAMPDIFF(MONTH,MIN(order_date),MAX(order_date)) AS active_period_months,
         COUNT(DISTINCT order_number) AS total_orders,
         COUNT(DISTINCT customer_key) AS total_customer,
         SUM(sales_amount) AS total_sales,
         SUM(quantity) AS total_quantity,
         ROUND(AVG(price),2) As avg_selling_price
  FROM base_query
  GROUP BY product_key,product_name,category,subcategory,cost)
  
  
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT product_key,product_name,category,subcategory,cost,

	   CASE WHEN total_sales >50000 THEN "High-performer"
			  WHEN total_sales >=10000 THEN "MID Range"
              ELSE "Low-performer"
		 END AS product_segment,
         
	   initial_sale_date,last_sale_date,active_period_months,
       TIMESTAMPDIFF(MONTH,last_sale_date,CURDATE()) AS recency_months,
       total_orders,total_customer,total_sales,total_quantity,avg_selling_price,
-- average order revenue (AOR)
		CASE WHEN total_orders = 0 THEN total_sales ELSE
        ROUND(CAST(total_sales AS FLOAT)/total_orders,2) END AS AOR,
-- average monthly revenue (AMR)
		CASE WHEN active_period_months= 0 THEN total_sales ELSE
        ROUND(CAST(total_sales AS FLOAT)/active_period_months,2) END AS AMR
        
FROM product_segmentation

);

SELECT * FROM product_report;