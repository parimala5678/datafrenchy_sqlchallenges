select * from customers;
select * from products;
select * from orders;
-- 1) How many customers does NorthWind Traders have in each country?
select count(customer_id) as num_of_customers, country
from customers
group by country
order by num_of_customers desc;

-- 2) List the top 5 cities with the most orders.
select ship_city, count(order_id) as num_of_orders
from orders
group by ship_city
order by num_of_orders desc
limit 5;

-- 3) Find the average freight cost for orders shipped to each country of the customers, and list the top 10 countries by average freight cost.	
-- since the freight col is orginally in text format, it need to be first changed to decimal type.					
select ship_country,round(avg(CAST(REPLACE(freight, '$', '') AS DECIMAL)),2)AS avg_freight_cost
from orders
group by ship_country
order by avg_freight_cost desc
limit 10; 

-- 4) Which products have a unit price higher than the average unit price of all products?
SELECT product_name, unit_price
FROM Products
WHERE unit_price > (SELECT AVG(unit_price) from products);

-- 5) Identify the top 3 customers by total order value (considering freight costs).
SELECT C.customer_id ,C.company_name, SUM(CAST(REPLACE(o.freight, '$', '') AS DECIMAL)) AS TOTAL_VALUE 
FROM customers C
JOIN ORDERS O ON C.customer_id = O.customer_id
GROUP BY C.customer_id,C.company_name
ORDER BY TOTAL_VALUE DESC 
LIMIT 3 ;