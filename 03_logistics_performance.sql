/*
==============================================================================
Average delivery time by state and rank states from fastest to slowest
==============================================================================
Question: What the average delivery time per state?
   

What this does:
 - Shows average delivery time for each state
 - Ranking Stats by avg delivery days from fastest to slowest
 - Identify which state need imporvement for delivery

SQL techniques used:
 - CTEs
 - Window functions 
 - Date Calaculation
 - Aggregation 
 - NULLIF for data quality handling
==============================================================================
*/

with delivery_times as (
	select 
	c.customer_state as state,
	o.order_id,
	NULLIF(o.order_delivered_customer_date, '')::date - NULLIF(o.order_purchase_timestamp, '')::date as delivery_days
	from orders o
	join customers c on o.customer_id =c.customer_id 
	where o.order_status='delivered'

),
state_avg_delivery as (
	select	
		state,
		count(order_id) as total_orders,
		round(avg(delivery_days)::numeric,2) as avg_delivery_days,
		max(delivery_days) as max_delivery_day,
		min(delivery_days) as min_delivery_day
	from delivery_times 
	group by state 
	having count(order_id) >100
	



)
select *,
dense_rank() over(order by avg_delivery_days) as rnk
from state_avg_delivery
order by rnk  , total_orders desc ;
/*
==============================================================================
What I found:
- SP (São Paulo) has fastest delivery: 8.7 days average with 40,501 orders
- High-volume states consistently have faster delivery (SP, RJ, MG)
- Low-volume states have slower delivery (often 20+ days average)
- Clear correlation: More orders = Better delivery infrastructure


Takeaway:
states with more orders have better delivery times
because carriers optimize routes for high-traffic areas. Remote states suffer
from infrequent deliveries and longer distances.
 

==============================================================================
*/





