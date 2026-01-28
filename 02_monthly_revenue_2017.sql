/*
==============================================================================
Monthly Running Total - 2017 Revenue Analysis
==============================================================================
Question: How did our monthly revenue accumulate throughout 2017?
   

What this does:
 - Calculates total revenue per month
 - Shows cumulative revenue
 - Helps track progress toward annual goals

SQL techniques used:
 - CTEs
 - Window functions
 - Date filtering and formatting
 
==============================================================================
*/

with monthly_revenue as (
	select
		TO_CHAR(o.order_purchase_timestamp::timestamp,'YYYY-MM') as order_month,
		round(sum(oi.price)::numeric) as total_price
		from orders o 
		join order_items oi on o.order_id=oi.order_id
		where o.order_status ='delivered'  and o.order_purchase_timestamp between '2017-01-01' and '2017-12-31'
		group by order_month

),
running_total as (
	select
		order_month,
		total_price,
		sum(total_price) over( order by order_month) as running_total
    from monthly_revenue

)
SELECT 
    order_month,
    total_price,
    running_total
FROM running_total;

/*
==============================================================================
What I found:
- Started at $112k in January, ended year at $6M cumulative
- November had biggest spike ($988k) - holiday shopping
- Revenue grew every single month (no declines)
- Q4 was strongest quarter by far

Takeaway:
The business grew steadily in 2017 with strong holiday performance. 
Could improve by boosting first-half revenue.
 

==============================================================================
*/
