CREATE TABLE product_prices(
   id         INTEGER  NOT NULL PRIMARY KEY 
  ,product_id VARCHAR(6) NOT NULL
  ,price      INTEGER  NOT NULL
);
INSERT INTO product_prices(id,product_id,price) VALUES (7,'c4a632',13);
INSERT INTO product_prices(id,product_id,price) VALUES (8,'e83aa3',32);
INSERT INTO product_prices(id,product_id,price) VALUES (9,'e31d39',10);
INSERT INTO product_prices(id,product_id,price) VALUES (10,'d5e9a6',23);
INSERT INTO product_prices(id,product_id,price) VALUES (11,'72f5d4',19);
INSERT INTO product_prices(id,product_id,price) VALUES (12,'9ec847',54);
INSERT INTO product_prices(id,product_id,price) VALUES (13,'5d267b',40);
INSERT INTO product_prices(id,product_id,price) VALUES (14,'c8d436',10);
INSERT INTO product_prices(id,product_id,price) VALUES (15,'2a2353',57);
INSERT INTO product_prices(id,product_id,price) VALUES (16,'f084eb',36);
INSERT INTO product_prices(id,product_id,price) VALUES (17,'b9a74d',17);
INSERT INTO product_prices(id,product_id,price) VALUES (18,'2feb6b',29);

#Q1.	What was the total quantity sold for all products?

select details.product_name,
sum(sales.qty) as sales_count
from sales inner join product_details as details 
on sales.prod_id=details.product_id
group by details.product_name
order by sales_count desc;

#2.	What is the total generated revenue for all products before discounts?
select sum(price*qty) as no_dis_revenue
from sales ;

#3.	What was the total discount amount for all products?
select sum(price*qty*discount)/100 as total_discount from sales;

#4.	How many unique transactions were there?
select count(distinct txn_id) as unique_txn from sales;
#5.	What are the average unique products purchased in each transaction?
#First we create CTE and find transaction for each product i mean count 
with cte_transaction_products as (
select txn_id,
count(distinct prod_id) as product_count 
from sales 
group by txn_id)
select round(avg(product_count)) as avg_unique_product 
from cte_transaction_products;

#6.	What is the average discount value per transaction?
with cte_transaction_discount as (
select txn_id,
sum(price*qty*discount)/100 as total_discount  
from sales 
group by txn_id)
select round(avg(total_discount)) as avg_discount 
from cte_transaction_discount;

#7.	What is the average revenue for member transactions and non-member transactions?
with cte_member_revenue as (
select member,txn_id,sum(price*qty) as revenue 
from sales 
group by member,txn_id)
select member,round(avg(revenue),2) as avg_revenue 
from cte_member_revenue
group by member;

#8.	What are the top 3 products by total revenue before discount?
select details.product_name,sum(qty*sales.price) as no_dis_revenue
from sales 
inner join product_details as details 
on sales.prod_id=details.product_id
group by details.product_name
order by no_dis_revenue desc
limit 3;

#9.	What are the total quantity, revenue and discount for each segment?
select details.segment_id,
details.segment_name,
sum(sales.qty) as total_quantity,
sum(sales.qty*sales.price) as total_revenue,
sum(sales.qty*sales.price*sales.discount)/100 as total_discount 
from sales inner join product_details as details 
on sales.prod_id=details.product_id
group by details.segment_id,details.segment_name;

#10.	What is the top selling product for each segment?

select details.segment_id,
details.segment_name,
details.product_id,details.product_name,
sum(sales.qty) as product_quantity 
from sales inner join 
product_details as details 
on sales.prod_id=details.product_id
group by details.segment_id,details.segment_name,
details.product_id,details.product_name
order by product_quantity desc
limit 5;

#11.	What are the total quantity, revenue and discount for each category?

select details.category_id,
details.category_name,
sum(sales.qty) as total_quantity,
sum(sales.qty*sales.price) as total_revenue,
sum(sales.qty*sales.price*sales.discount)/100 as total_discount 
from sales inner join product_details as details 
on sales.prod_id=details.product_id
group by details.category_id,details.category_name;


#12.	What is the top selling product for each category?
select details.category_id,
details.category_name,
details.product_id,details.product_name,
sum(sales.qty) as product_quantity 
from sales inner join 
product_details as details 
on sales.prod_id=details.product_id
group by details.category_id,details.category_name,
details.product_id,details.product_name
order by product_quantity desc
limit 5;