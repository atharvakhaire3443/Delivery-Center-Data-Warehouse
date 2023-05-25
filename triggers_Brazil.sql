create sequence s1
increment 1
start with 353130;

create sequence s2
increment 1
start with 344082;

create sequence s3
increment 1
start with 388973;

create sequence s4
increment 1
start with 4584;

-- Delivery Dim SCD Maintenance
create or replace function delivery_updates(
var_delivery_dim_ID numeric(12),var_orders_dim_id numeric(12),
var_driver_dim_id numeric(12),var_order_delivery_fee numeric(12,4),
var_delivery_distance_meters numeric(12,4),var_delivery_status varchar(100))
returns void as $$
begin
		update delivery_dim
		set row_expiration_date = current_date, flag = 'Expired'
		where delivery_dim_id = var_delivery_dim_id;
		
		insert into delivery_dim(delivery_dim_id,orders_dim_id,driver_dim_id,
		order_delivery_fee,delivery_distance_meters,delivery_status,
		row_effective_date,row_expiration_date,flag)
		values(nextval('s1'),var_orders_dim_id,var_driver_dim_id,
		var_order_delivery_fee,var_delivery_distance_meters,
		var_delivery_status,current_date,'9999-01-01','Active');
end;
$$ language plpgsql

-- Orders Dim SCD Maintenance
create or replace function orders_updates(
var_orders_dim_ID numeric(12),var_order_id numeric(12),
var_order_status varchar(100),var_channel_dim_id numeric(12))
returns void as $$
begin
		update orders_dim
		set row_expiration_date = current_date, flag = 'Expired'
		where orders_dim_id = var_orders_dim_id;
		
		insert into orders_dim(orders_dim_id,orders_id,order_status,
		channel_dim_id,row_effective_date,row_expiration_date,flag)
		values(nextval('s2'),var_order_id,var_order_status,var_channel_dim_id,
	    current_date,'9999-01-01','Active');
end;
$$ language plpgsql

-- Payments Dim SCD Maintenance
create or replace function payments_updates(
var_payments_dim_ID numeric(12),var_payment_id numeric(12),var_orders_dim_id numeric(12),
var_payment_amount numeric(12,4),var_payment_fee numeric(12,4),
var_payment_method varchar(30),var_payment_status varchar(30))
returns void as $$
begin
		update payments_dim
		set row_expiration_date = current_date, flag = 'Expired'
		where payments_dim_id = var_payments_dim_id;
		
		insert into payments_dim(payments_dim_id,payment_id,orders_dim_id,payment_amount,
		payment_fee,payment_method,payment_status,
		row_effective_date,row_expiration_date,flag)
		values(nextval('s3'),var_payment_id,var_orders_dim_id,var_payment_amount,
		var_payment_fee,var_payment_method,
		var_payment_status,current_date,'9999-01-01','Active');
end;
$$ language plpgsql

-- Drivers Dim SCD Maintenance
create or replace function driver_updates(
var_driver_dim_id numeric(12),var_driver_id numeric(12),
var_current_driver_modal varchar(100),var_current_driver_type varchar(100))
returns void as $$
declare
		temp_previous_driver_modal varchar(100);
		temp_previous_driver_type varchar(100);
begin
		select current_driver_modal,current_driver_type 
		into temp_previous_driver_modal,temp_previous_driver_type
		from driver_dim
		where driver_dim_id = var_driver_dim_id;
		
		update driver_dim set driver_id = var_driver_id, current_driver_modal = var_current_driver_modal,
		current_driver_type = var_current_driver_type, previous_driver_modal = temp_previous_driver_modal,
		previous_driver_type = temp_previous_driver_type
		where driver_dim_id = var_driver_dim_id;
end;
$$ language plpgsql

select delivery_updates(1,25951,687,9.99,3117,'DELIVERED');

select driver_updates(1,25951,'BIKER','FREELANCE');

select * from driver_dim where driver_dim_id = 1

select * from driver_dim where driver_id = 29877;
