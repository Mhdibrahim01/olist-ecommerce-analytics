/*
==============================================================================
Analyze Sellers
==============================================================================
Question: Who Are Top 10 Sellers?
   

What this does:
 - Calculate total revenue for each seller
 - Calculate average user review for each seller
 - Identify who are top 10 seller by total revenue

SQL techniques used:
 - CTEs
 - Window functions (RANK)
 - Aggregation (SUM, AVG, COUNT)
 - LEFT JOIN (to handle orders without reviews)
==============================================================================
*/


with sellers_revenue as (
 	select  
 		s.seller_id,
		s.seller_state,
 		sum(oi.price) as total_revenue,
 		count(distinct oi.order_id) as total_orders,
 	    round((sum(oi.price) / count(distinct oi.order_id))::numeric, 2) as avg_order_value,
 		round(avg(r.review_score)::numeric,2) as avg_review_score,
 		count(distinct r.review_id) as total_reviews
 		from order_items oi
 		join sellers s on oi.seller_id =s.seller_id
 		left join order_reviews r on oi.order_id =r.order_id  
 		join orders o on oi.order_id = o.order_id 
 		where o.order_status ='delivered'
 		group by s.seller_id,s.seller_state 
),
sellers_ranking as (
	select *,
		rank() over(order by total_revenue desc) as rnk,
		round((total_revenue * 100.0 / sum(total_revenue) over())::numeric, 2) as pct_of_total_revenue

	from sellers_revenue


)
select  * from sellers_ranking 
where rnk<=10


/*
==============================================================================
What I found:

- Top 10 sellers generate 13% of total platform revenue
- Geographic concentration: 9 out of 10 are from São Paulo

Takeaway:
The platform depends heavily on a small group of "Super Sellers."
Even though there are thousands of sellers,the top 10 alone make 13% of all the money.
Because almost all of them are in São Paulo,
the business is very vulnerable to anything that happens in that one state

==============================================================================
*/

