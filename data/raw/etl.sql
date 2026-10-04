select *from customers;
select * from orders;

--- create bronze tables(for store dirty data as it is coming )
create or replace table bronze_customers as select * from customers;
create or replace table bronze_orders as select * from orders;

select * from bronze_customers;
select * from bronze_orders;

---- creating silver tables (for clean data and loaded in silver )
create or replace table silver_customers as 
select 
trim(id) as id,
trim(name) as name,
trim(segment) as segment,
trim(state) as state,
trim(city) as city
from bronze_customers
where id is not null;

select * from  silver_customers;


create or replace table silver_orders as 
select id,
customer_id,
order_date,
ship_mode
from bronze_orders
where customer_id is not null;


select * from silver_orders;
       
----- create gold table (for insights and analysis)

create or replace table gold_customers as 
select 
c.id as customer_id,
c.name,
c.segment,
c.state,
c.city,
o.id as order_id,
o.order_date,
o.ship_mode
from silver_customers c
inner join silver_orders o
on c.id=o.customer_id;

select * from gold_customers;
