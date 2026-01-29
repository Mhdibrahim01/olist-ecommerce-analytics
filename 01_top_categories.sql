/*
================================================================================
Top 10 Product Categories by Revenue
================================================================================
Question: Which product categories generate the most revenue?

What this does:
- Ranks all product categories by total sales
- Calculates each category's share of total revenue
- Shows order volume and pricing metrics
- Handles missing category names

SQL techniques used:
- CTEs (WITH clauses)
- Window functions (SUM OVER)
- COALESCE for NULL handling
- Percentage calculations
================================================================================
*/

WITH top_categories AS (
    SELECT
        COALESCE(p.product_category_name, 'unknown/other') AS category,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        COUNT(oi.product_id) AS total_items_sold,
        SUM(oi.price) AS total_revenue,
        ROUND(AVG(oi.price)::numeric, 2) AS avg_item_price
    FROM order_items oi 
    JOIN products p ON oi.product_id = p.product_id 
    GROUP BY p.product_category_name
),
final_calculations AS (
    SELECT 
        *,
        SUM(total_revenue) OVER() AS grand_total_revenue
    FROM top_categories
)
SELECT 
    category,
    total_revenue,
    total_orders,
    total_items_sold,
    avg_item_price,
    ROUND((total_revenue * 100.0 / grand_total_revenue)::numeric, 2) AS revenue_percentage
FROM final_calculations
ORDER BY total_revenue DESC 
LIMIT 10;

/*
================================================================================
Findings:
- Health/beauty is #1 category by revenue
- Top 3 categories = ~23% of total sales
- Top 10 categories = ~60% of total sales
- Revenue is spread across categories (not concentrated)

Takeaway:
Focus marketing on top performers. Good category diversity reduces risk.

*/
