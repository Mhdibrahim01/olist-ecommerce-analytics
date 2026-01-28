/*
==============================================================================
Month-over-Month Revenue Growth Analysis
==============================================================================
Question: How is our business growing each month?
   

What this does:
 - Calculate total revenue for each month
 - Calculate the growth for each month
 - Identify growth trends and seasonality patterns
 - Tracks revenue, order volume, and average order value trends

SQL techniques used:
 - CTEs
 - Window functions (LAG)
 - Aggregation 
 - Date formatting (TO_CHAR)
==============================================================================
*/

with monthly_revenue as (
	select
		TO_CHAR(o.order_purchase_timestamp::timestamp,'YYYY-MM') as order_month,
		count(distinct o.order_id) as total_orders,
	    round((sum(oi.price )/count(distinct o.order_id)):: numeric,2) as avg_order_value,
		sum(oi.price) as total_revenue
		from orders o 
		join order_items oi on o.order_id =oi.order_id 
        where o.order_status='delivered'
        group by order_month
        

),
monthly_growth as (
	select
		order_month,
		total_orders,
		avg_order_value,
		total_revenue,
		lag(total_revenue) over(order by order_month) as prev_month_revenue,
		lag(total_orders) over(order by order_month) as prev_month_orders,
		lag(avg_order_value) over(order by order_month) as prev_month_avg
		from monthly_revenue
)
select
	order_month ,
	total_revenue,
	total_orders,
	avg_order_value,
	round(((total_revenue-prev_month_revenue)/prev_month_revenue*100)::numeric,2) ||'%' as revenue_growth,
	round(((total_orders-prev_month_orders)/prev_month_orders*100)::numeric,2) || '%' as orders_growth,
	round(((avg_order_value-prev_month_avg)/prev_month_avg*100)::numeric,2) || '%' as avg_order_value_growth
	
from monthly_growth
order by order_month;

/*
What I found:

Business lifecycle:
- 2016: Launch phase (tiny revenue, testing)
- 2017: Rapid growth (50-100%+ monthly)
- 2018: Plateau (0-15% growth, slowing down)

Takeaway:
Need new growth strategies ASAP. Current market is tapped out.
Options: New geographies, new products, B2B channel, or subscriptions.

*/