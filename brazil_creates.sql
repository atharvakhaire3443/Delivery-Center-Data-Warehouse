create table channel_dim(
channel_dim_id numeric(12) primary key,
channel_name varchar(30),
channel_type varchar(30)
);
create table city_dim(
city_id numeric(12) primary key,
city_name varchar(100),
state varchar(30),
capital integer
);
create table driver_dim(
driver_dim_id numeric(12) primary key,
driver_id numeric(12) not null,
driver_modal varchar(100),
driver_type varchar(100)
);
create table hub_dim(
hub_dim_id numeric(12) primary key,
hub_name varchar(100) not null,
city_id numeric(12),
hub_state varchar(100),
hub_latitude numeric(12,7),
hub_longitude numeric(12,7),
constraint city_id_fk_hub foreign key(city_id) references city_dim(city_id)
);
create table store_dim(
store_dim_id numeric(12) primary key,
store_name varchar(100) not null,
store_segment varchar(30),
store_plan_price numeric(12,4),
store_latitude numeric(12,7),
store_longitude numeric(12,7),
hub_dim_id numeric(12),
constraint hub_id_fk_store foreign key(hub_dim_id) references hub_dim(hub_dim_id)
);
create table orders_dim(
orders_dim_id numeric(12) primary key,
order_id numeric(12) not null,
order_status varchar(100) not null,
channel_dim_id numeric(12),
row_effective_date varchar(100) not null,
row_expiration_date varchar(100) not null,
flag varchar(30) not null,
constraint channel_id_fk_orders foreign key(channel_dim_id) references channel_dim(channel_dim_id)
);
create table payments_dim(
payments_dim_id numeric(12) primary key,
payment_id numeric(12) not null,
orders_dim_id numeric(12) not null,
payment_amount numeric(12,4),
payment_fee numeric(12,4),
payment_method varchar(30),
payment_status varchar(30),
row_effective_date varchar(100) not null,
row_expiration_date varchar(100) not null,
flag varchar(30) not null,
constraint orders_id_fk_payments foreign key(orders_dim_id) references orders_dim(orders_dim_id)
);
create table delivery_dim(
delivery_dim_id numeric(12) primary key,
orders_dim_id numeric(12) not null,
driver_dim_id numeric(12) not null,
order_delivery_fee numeric(12,4),
delivery_distance_meters numeric(12,4),
delivery_status varchar(30),
row_effective_date varchar(100) not null,
row_expiration_date varchar(100) not null,
flag varchar(30) not null,
constraint orders_id_fk_delivery foreign key(orders_dim_id) references orders_dim(orders_dim_id),
constraint driver_id_fk_delivery foreign key(driver_dim_id) references driver_dim(driver_dim_id)
);
create table revenue_fact(
orders_dim_id numeric(12),
delivery_dim_id numeric(12),
payments_dim_id numeric(12),
payment_amount numeric(12,4),
payment_fee numeric(12,4),
order_delivery_fee numeric(12,4),
store_dim_id numeric(12),
city_id numeric(12)
);

create table logistic_fact(
orders_dim_id numeric(12),
delivery_dim_id numeric(12),
store_dim_id numeric(12),
hub_dim_id numeric(12),
channel_dim_id numeric(12),
driver_dim_id numeric(12),
city_id numeric(12),
order_moment_created varchar(100),
order_moment_accepted varchar(100),
order_moment_ready varchar(100),
order_moment_collected varchar(100),
order_moment_in_expedition varchar(100),
order_moment_delivering varchar(100),
order_moment_delivered varchar(100),
order_moment_finished varchar(100),
order_metric_collected_time numeric(12,3),
order_metric_paused_time numeric(12,3),
order_metric_production_time numeric(12,3),
order_metric_walking_time numeric(12,3),
order_metric_expediton_speed_time numeric(12,3),
order_metric_transit_time numeric(12,3),
order_metric_cycle_time numeric(12,3),
delivery_distance_meters numeric(12,2),
order_fulfillment_time varchar(100),
order_fulfillment_time_days numeric(12,2),
order_fulfillment_time_hours numeric(12,2),
order_fulfillment_time_minutes numeric(12,2),
order_fulfillment_time_in_minutes numeric(12,2)
);
drop table logistic_fact;

select * from logistic_fact;

create table order_accepted_dim(
order_accepted_dim_id numeric(12) primary key,
orders_dim_id numeric(12),
order_moment_accepted_month varchar(10),
order_moment_accepted_day varchar(10),
order_moment_accepted_year varchar(10),
order_moment_accepted_hour varchar(10),
order_moment_accepted_minute varchar(10),
constraint orders_id_fk_oad foreign key(orders_dim_id) references orders_dim(orders_dim_id)
);
drop table order_accepted_dim;

create table order_collected_dim(
order_collected_dim_id numeric(12) primary key,
orders_dim_id numeric(12),
order_moment_collected_month varchar(10),
order_moment_collected_day varchar(10),
order_moment_collected_year varchar(10),
order_moment_collected_hour varchar(10),
order_moment_collected_minute varchar(10),
constraint orders_id_fk_ocd foreign key(orders_dim_id) references orders_dim(orders_dim_id)
);

create table order_in_expedition_dim(
order_in_expedition_dim_id numeric(12) primary key,
orders_dim_id numeric(12),
order_moment_in_expedition_month varchar(10),
order_moment_in_expedition_day varchar(10),
order_moment_in_expedition_year varchar(10),
order_moment_in_expedition_hour varchar(10),
order_moment_in_expedition_minute varchar(10),
constraint orders_id_fk_oed foreign key(orders_dim_id) references orders_dim(orders_dim_id)
);

create table order_delivering_dim(
order_delivering_dim_id numeric(12) primary key,
orders_dim_id numeric(12),
order_moment_delivering_month varchar(10),
order_moment_delivering_day varchar(10),
order_moment_delivering_year varchar(10),
order_moment_delivering_hour varchar(10),
order_moment_delivering_minute varchar(10),
constraint orders_id_fk_odd foreign key(orders_dim_id) references orders_dim(orders_dim_id)
);

create table order_delivered_dim(
order_delivered_dim_id numeric(12) primary key,
orders_dim_id numeric(12),
order_moment_delivered_month varchar(10),
order_moment_delivered_day varchar(10),
order_moment_delivered_year varchar(10),
order_moment_delivered_hour varchar(10),
order_moment_delivered_minute varchar(10),
constraint orders_id_fk_oddd foreign key(orders_dim_id) references orders_dim(orders_dim_id)
);

create table order_finished_dim(
order_finished_dim_id numeric(12) primary key,
orders_dim_id numeric(12),
order_moment_finished_month varchar(10),
order_moment_finished_day varchar(10),
order_moment_finished_year varchar(10),
order_moment_finished_hour varchar(10),
order_moment_finished_minute varchar(10),
constraint orders_id_fk_ofd foreign key(orders_dim_id) references orders_dim(orders_dim_id)
);