/*
==============================================================================
RFM Customer Segmentation (Loyalty Analysis)
==============================================================================
Question: Who are our most valuable customers and how should we treat them?

What this does:
 - Calculates Recency (days since last order relative to dataset end)
 - Calculates Frequency (total orders per customer)
 - Calculates Monetary (total spend per customer)
 - Groups customers into segments (Champions, Loyal, At Risk, etc.)

SQL techniques used:
 - CTEs (Common Table Expressions)
 - Window Functions (NTILE for Recency/Monetary)
 - Manual Scoring (For Frequency to handle high one-time buyer volume)
 - Date Arithmetic
==============================================================================
*/
with customer_cte as (
	select 
		c.customer_unique_id ,
		(select max(order_purchase_timestamp::date )from orders ) - max(o.order_purchase_timestamp::date) as last_order,
		count(distinct o.order_id) as total_orders,
		sum(oi.price) as total_spent
		from orders o
		join order_items oi on o.order_id=oi.order_id
		join customers c on o.customer_id=c.customer_id
		where o.order_status='delivered' 
		and o.order_purchase_timestamp is not null
		group by c.customer_unique_id


),
customer_rfm as (
select *,
ntile(5) over(order by last_order desc ) as recency,
-- Frequency: Manual Score to avoid NTILE distortion (97% of users have 1 order)
        CASE 
            WHEN total_orders >= 3 THEN 5
            WHEN total_orders = 2 THEN 3
            ELSE 1 
        END AS frequency,
        ntile(5) over(order by total_spent asc) as monetary
from customer_cte 

)
select *,
(recency + frequency + monetary) as total_score,
 case
	when (recency + frequency + monetary) >=14  then 'Champions'
	when (recency + frequency + monetary) >=12 then 'Loyal Customers'
	when (recency + frequency + monetary) >=9  then 'Potential Loyalists'
	when (recency + frequency + monetary) >=6  then 'Customers Needing Attention'
	when (recency + frequency + monetary) >=4  then 'Hibernating'
    when (recency + frequency + monetary) <= 3 then 'Lost'
 end
from customer_rfm 
order by total_score  desc

/*
==============================================================================
What I found:
- Most customers fall into the “One-time” or “Hibernating” segments
- Champions represent a small fraction of customers
- Champions and Loyal Customers generate significantly higher total spending
- Higher frequency strongly correlates with higher monetary value

Takeaway:
Customer revenue is highly concentrated among a small group of loyal customers.
Retention-focused strategies (loyalty programs, targeted promotions) could
significantly increase revenue by converting repeat buyers into Champions,
rather than relying primarily on new customer acquisition.

==============================================================================
*/


