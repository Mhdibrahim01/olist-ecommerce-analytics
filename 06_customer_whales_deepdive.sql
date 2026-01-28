/*
==============================================================================
Customer Ranking- Showing top 20 customer
==============================================================================
Question: Who are the top customer?
   

What this does:
 - Ranking customers by total spending
 - Shows Top Customers
 - 

SQL techniques used:
 - CTEs
 - Window functions
 - Aggregation 
 
==============================================================================
*/

with customers_spending as (
	select 
		c.customer_unique_id as cust_id,
		STRING_AGG(DISTINCT pct.product_category_name_english, ', ') AS categories_bought,
		count(distinct o.order_id) as order_count,
		round(sum(oi.price)::numeric,2) as total_spending,
        ROUND((SUM(oi.price) / COUNT(DISTINCT o.order_id))::numeric, 2) AS avg_order_value
	from order_items oi 
	join orders o on oi.order_id=o.order_id
	join customers c on o.customer_id=c.customer_id
	join products p on oi.product_id=p.product_id

	left join product_category_translation pct on p.product_category_name=pct.product_category_name
	where order_status='delivered'
	group by c.customer_unique_id
),
customers_ranking as (
	select
	    *,
		DENSE_RANK() OVER ( order by total_spending desc) as rnk
	from customers_spending

)


select * from customers_ranking
where rnk<=20

/*
==============================================================================
What I found:
- Top customer spent $13.440 (in just one order)
- 17 out of 20 top customers only bought once
- Only one customer made above 3 orders
- Average order values range from $1020 to $13440
- Big purchases are electronics: phones, computers, tech
- These are expensive items people don't buy repeatedly

Takeaway:
One-time buyers make sense for big electronics. Can't expect someone 
to buy another $10k phone. But we CAN sell them accessories, cases, 
and upgrades later.


==============================================================================
*/
