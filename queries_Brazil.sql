select * from logistic_fact;
select * from channel_dim;

-- What is the average order fulfillment time for each channel in each store segment?
select channel_dim.channel_name,store_dim.store_segment,city_dim.city_name,
avg(logistic_fact.order_fulfillment_time_in_minutes) as average_fulfillment_time
from logistic_fact
join channel_dim on channel_dim.channel_dim_id = logistic_fact.channel_dim_id
join store_dim on store_dim.store_dim_id = logistic_fact.store_dim_id
join city_dim on city_dim.city_id = logistic_fact.city_id
where logistic_fact.order_fulfillment_time_in_minutes <> 'NaN'
group by channel_dim.channel_name,store_dim.store_segment,city_dim.city_name
order by avg(logistic_fact.order_fulfillment_time_in_minutes) desc;


-- What is the revenue generated in store segments in each city?
select distinct city_dim.city_name,store_dim.store_segment,sum(payments_dim.payment_amount)
from revenue_fact
join city_dim on city_dim.city_id = revenue_fact.city_id
join store_dim on store_dim.store_dim_id = revenue_fact.store_dim_id
join payments_dim on payments_dim.payments_dim_id = revenue_fact.payments_dim_id
group by city_dim.city_name,store_dim.store_segment;


-- What is the revenue generated by each store branch in each city?
create extension if not exists tablefunc;
select * from crosstab(
'select distinct store_dim.store_name,city_dim.city_name,sum(revenue_fact.payment_amount)
from revenue_fact
join store_dim on store_dim.store_dim_id = revenue_fact.store_dim_id
join city_dim on city_dim.city_id = revenue_fact.city_id
join payments_dim on payments_dim.payments_dim_id = revenue_fact.payments_dim_id
group by store_dim.store_name,city_dim.city_name
--order by sum(revenue_fact.payment_amount) desc')
as
(store_name varchar(100),são_paulo numeric(12,4),rio_de_janeiro numeric(12,4),porto_alegre numeric(12,4),
curitiba numeric(12,4));


-- What is the order cancellation percentage for each store?
select distinct store_dim.store_name, 
(count(case when orders_dim.order_status ='CANCELED' then 1 else null end)::float/
count(orders_dim.order_status))*100 as cancellation_rate
from revenue_fact
join store_dim on store_dim.store_dim_id = revenue_fact.store_dim_id
join orders_dim on orders_dim.orders_dim_id = revenue_fact.orders_dim_id
group by store_dim.store_name
order by (count(case when orders_dim.order_status ='CANCELED' then 1 else null end)::float/
count(orders_dim.order_status))*100 desc;


-- What is the total order delivery fee charged by drivers in each city?
select driver_dim.current_driver_modal,city_dim.city_name,sum(revenue_fact.order_delivery_fee)
from revenue_fact
join delivery_dim on delivery_dim.delivery_dim_id = revenue_fact.delivery_dim_id
join driver_dim on driver_dim.driver_dim_id = delivery_dim.driver_dim_id
join city_dim on city_dim.city_id = revenue_fact.city_id
join payments_dim on payments_dim.payments_dim_id = revenue_fact.payments_dim_id
where payments_dim.payment_status = 'PAID'
group by driver_dim.current_driver_modal,city_dim.city_name;


-- What is the percentage of online transactions as compared to other payment methods?
select payments_dim.payment_method,
100 * sum(revenue_fact.orders_dim_id) / total_orders.total_count as percentage
from revenue_fact
join payments_dim on payments_dim.payments_dim_id = revenue_fact.payments_dim_id
cross join (select sum(orders_dim_id) as total_count from revenue_fact) total_orders
group by payments_dim.payment_method,total_orders.total_count
order by percentage desc;




