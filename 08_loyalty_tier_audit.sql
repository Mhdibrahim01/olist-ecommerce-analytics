/*
==============================================================================
Customers Loyalty
==============================================================================
Question: Who are most loyal customer?
   

What this does:
 - Calculate total orders fo each customer
 - Calculate lifetime interval fro each customer
 - Put each customer in customer segmentaion

SQL techniques used:
 - CTEs
 - Aggregation 
 - Date Calculation 
==============================================================================
*/


with customer_loyalty as ( 
	select 
		c.customer_unique_id as cust_id,
		count(distinct o.order_id) as total_orders,
		min(o.order_purchase_timestamp) as first_order,
		max(o.order_purchase_timestamp) as last_order,
		round(sum(oi.price)::numeric,2) as total_spent
	from orders o
	join customers c on o.customer_id = c.customer_id
	join order_items oi on o.order_id=oi.order_id 
	where o.order_status = 'delivered'
	and o.order_purchase_timestamp is not null
	group by c.customer_unique_id
)
select 
	*,
    DATE_PART('day', last_order::timestamp - first_order::timestamp) AS lifetime_days,
	round(total_spent/total_orders,2) as avg_order_value,
	case
		when total_orders>=5 then 'VIP'
		when total_orders>=3 then 'Loyal'
		when total_orders=2 then 'Repeat'
		else  'One time'
	end as customer_segment
	
from customer_loyalty
where total_orders >= 1
order by total_orders desc,total_spent desc;


/*
What I found:

- Majority of customers are one-time buyers
- VIP customers represent a small percentage but generate disproportionate revenue

Takeaway:

Customer revenue is highly concentrated among a small group of loyal customers. While most customers purchase only once,
VIP customers drive a disproportionate share of total revenue,
indicating that retention strategies could have a significant impact on overall business performance

*/