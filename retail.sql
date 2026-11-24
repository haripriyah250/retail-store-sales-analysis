create table customers(
  customer_id varchar(10) primary key,
  customer_name varchar(100),
  city varchar(50),
  state varchar(50),
  phone_number varchar(15)
);

select * from customers;

INSERT INTO customers
(customer_id, customer_name, city, state, phone_number)
VALUES
('C001', 'Arun', 'Chennai', 'Tamil Nadu', '9876543210'),
('C002', 'Priya', 'Coimbatore', 'Tamil Nadu', '9876543211'),
('C003', 'Ravi', 'Bengaluru', 'Karnataka', '9876543212'),
('C004', 'Divya', 'Madurai', 'Tamil Nadu', '9876543213'),
('C005', 'Kumar', 'Salem', 'Tamil Nadu', '9876543214');

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO products
(product_id, product_name, category, price)
VALUES
('P001', 'Laptop', 'Electronics', 45000),
('P002', 'Mouse', 'Electronics', 500),
('P003', 'Chair', 'Furniture', 2500),
('P004', 'Notebook', 'Stationery', 100),
('P005', 'Headphones', 'Electronics', 1500);

select * from products

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

INSERT INTO orders
(order_id, customer_id, order_date, order_status)
VALUES
('O001', 'C001', '2026-11-01', 'Delivered'),
('O002', 'C002', '2026-11-02', 'Shipped'),
('O003', 'C003', '2026-11-03', 'Pending'),
('O004', 'C004', '2026-11-04', 'Delivered'),
('O005', 'C005', '2026-11-05', 'Processing');

select * from orders;

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id VARCHAR(10),
    product_id VARCHAR(10),
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items
(order_item_id, order_id, product_id, quantity, unit_price)
VALUES
(1, 'O001', 'P001', 1, 45000),
(2, 'O001', 'P002', 2, 500),
(3, 'O002', 'P003', 1, 2500),
(4, 'O003', 'P004', 5, 100),
(5, 'O004', 'P005', 1, 1500);

select * from order_items;

CREATE TABLE payments (
    payment_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10),
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(30),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO payments
(payment_id, order_id, payment_amount, payment_method, payment_date)
VALUES
('PAY001', 'O001', 46000, 'UPI', '2026-11-01'),
('PAY002', 'O002', 2500, 'Card', '2026-11-02'),
('PAY003', 'O003', 500, 'Cash', '2026-11-03'),
('PAY004', 'O004', 1500, 'UPI', '2026-11-04'),
('PAY005', 'O005', 1000, 'Card', '2026-11-05');

select * from payments;

select count(*) from customers;

select count(*) from products;

select count(*) from orders;

select count(*) from order_items;

select count(*) from payments;

SELECT 'Customers' AS table_name, COUNT(*) AS total 
FROM customers

UNION ALL

SELECT 'Products', COUNT(*) FROM products

UNION ALL

SELECT 'Orders', COUNT(*) FROM orders

UNION ALL

SELECT 'Order_Items', COUNT(*) FROM order_items

UNION ALL

SELECT 'Payments', COUNT(*) FROM payments;




select
  sum(quantity * unit_price) as total_sales from order_items;

SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name;

select
    p.product_name,
    sum(oi.quantity * oi.unit_price) as total_sales
from order_items oi
join products p
on oi.product_id = p.product_id 
group by p.product_name 
order by total_sales desc;

select 
  p.category,
  sum(oi.quantity * oi.unit_price) as total_sales
from order_items oi
join products p
on oi.product_id = p.product_id 
group by p.category 
order by total_sales desc;

select
  order_status,
  count(*) as total_orders
from orders
group by order_status 
order by total_orders desc;

select
  payment_method,
  sum(payment_amount) as total_payment
from payments
group by payment_method 
order by total_payment desc;

select * from payments
where payment_id = 'PAY005'

select * from order_items
where order_id = '0005';

select 
  o.order_id,
  oi.product_id,
  oi.quantity
from orders o
left join order_items oi
on o.order_id = oi.order_id;

select 
  o.order_id,
  oi.product_id
from orders o
left join order_items oi
on o.order_id = oi.order_id 
where oi.product_id is null;


select * from products
where category = 'Electronics';

select product_name, price 
from products
where price > (
select avg(price) from products
);


select product_name, category
from products
where category in ('Electronics','Furniture');

select product_name, price from products
where category IN(
select category from products where price > 2000
);

select product_name, category from products
where category not in('Electronics');

select product_name, price from products
where price > any (
  select price 
  from products
  where category = 'Electronics');

select product_name, price from products
where price > All (
  select price 
  from products
  where category = 'Electronics');

select 
  product_name,
  price,
case 
	when price > 10000 then 'Expensive'
	else 'Affordable'
end as price_category
from products;

select 
  product_name,
  price,
  case 
  	when price >= 10000 then 'High'
  	when price >= 1000 then 'Medium'
  	else 'Low'
  end as price_range
  from products;

select 
  case 
  	when price >= 10000 then 'High'
  	when price >= 1000 then 'Medium'
  	else 'Low'
  end as price_range,
  count(*) as total_products
  from products
  group by price_range 
  order by total_products desc;

select 
  order_id,
  order_date,
  extract(year from order_date) as order_year from orders;

select 
  order_id,
  order_date,
  extract(month from order_date) as order_month from orders;

select 
  order_id,
  order_date,
  extract(day from order_date) as order_day from orders;

select 
  order_id,
  order_date,
  order_date + interval '7 days' as delivery_date
  from orders;


select 
  order_id,
  to_char(order_date, 'dd mon yyyy') as formatted_date
from orders;

select 
  date_trunc('month', order_date) as order_month,
  count(*) as total_orders from orders
group by order_month;


select 
  c.customer_name,
  sum(oi.quantity * oi.unit_price) as total_sales
  from customers c
  join orders o
  on c.customer_id = o.customer_id 
  join order_items oi
  on o.order_id = oi.order_id 
  group by c.customer_name 
  order by total_sales desc;


select
  p.category,
  sum(oi.quantity * oi.unit_price) as total_sales
from products p
join order_items oi
on p.product_id = oi.product_id 
group by p.category 
order by total_sales desc;

select 
  order_status,
  count(*) as total_orders from orders
  group by order_status 
  order by total_orders desc;

select 
  payment_method,
  sum(payment_amount) as total_payment
from payments
group by payment_method 
order by total_payment desc;

select 
  o.order_id,
  p.payment_amount,
  p.payment_method
from orders o
join payments p
on o.order_id = p.order_id 
left join order_items oi
on o.order_id = oi.order_id 
where oi.order_id is null;

select 
  date_trunc('month',o.order_date) as sales_month,
  sum(oi.quantity * oi.unit_price) as total_sales
  from orders o
  join order_items oi
  on o.order_id = oi.order_id 
  group by sales_month;

select 
  p.product_name,
  sum(oi.quantity) as total_quantity_sold
  from products p
  join order_items oi
  on p.product_id = oi.product_id 
group by p.product_name 
order by total_quantity_sold desc;

select 
  p.product_name,
  sum(oi.quantity * oi.unit_price) as total_revenue
  from products p
  join order_items oi
  on p.product_id = oi.product_id 
  group by p.product_name 
  order by total_revenue desc;

select
  sum(oi.quantity * oi.unit_price)
  / count(distinct oi.order_id) as average_order_value
from order_items oi;

select 
  c.customer_name,
  sum(oi.quantity * oi.unit_price) as total_sales,
  rank() over(
    order by sum(oi.quantity * oi.unit_price) desc
  ) as customer_rank
  from customers c
  join orders o
  on c.customer_id = o.customer_id 
  join order_items oi
  on o.order_id = oi.order_id 
  group by c.customer_name;

select 
  p.product_name,
  sum(oi.quantity * oi.unit_price) as total_sales,
  dense_rank() over(
    order by sum(oi.quantity * oi.unit_price) desc
  ) as sales_rank
  from products p
  join order_items oi
  on p.product_id = oi.product_id 
  group by p.product_name;

select 
  product_name,
  price,
  row_number() over(
    order by price desc
  ) as row_num
  from products;

select 
  product_name,
  category,
  price,
  rank() over(
    partition by category
    order by price desc
  ) as category_rank
  from products;

select 
  order_id,
  order_date,
  lag(order_date) over(
    order by order_date
  ) as previous_order_date
  from orders;
    

select 
  order_id,
  order_date,
  lead(order_date) over(
    order by order_date
  ) as next_order_date
  from orders;

select 'customers' as table_name,
count(*) as total_records from customers
union all 
select 'products',count(*) from products
union all 
select 'orders',count(*) from orders
union all
select 'order_items',count(*) from order_items
union all 
select 'payments',count(*) from payments;

select 
  customer_id,
  count(*)
from customers
group by customer_id 
having count(*) > 1;

select * from customers
where customer_id is null 
or customer_name is null 
or city is null 
or state is null 
or phone_number is null;

select 
  product_id,
  count(*)
from products
group by product_id 
having count(*) > 1;

select * from products
where product_id is null 
  or product_name is null 
  or category is null 
  or price is null;

select * from orders
where order_id is null 
  or customer_id is null 
  or order_date is null 
  or order_status is null;

select * from order_items
where order_item_id is null 
  or order_id is null 
  or product_id is null 
  or quantity is null
  or unit_price is null;

select * from payments
where payment_id is null
  or order_id is null 
  or payment_amount is null 
  or payment_method is null
  or payment_date is null;

select o.* from orders o
left join customers c
on o.customer_id = c.customer_id 
where c.customer_id is null;

select o.* from orders o
left join customers c
on o.customer_id = c.customer_id 
where c.customer_id is null;

select oi.* from order_items oi
left join products p
on oi.product_id = p.product_id 
where p.product_id is null;

select oi.* from order_items oi
left join orders o
on oi.order_id = o.order_id 
where o.order_id is null;

select p.* from payments p
left join orders o
on p.order_id = o.order_id 
where o.order_id is null;

SELECT
    p.order_id,
    p.payment_amount,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS order_sales
FROM payments p
LEFT JOIN order_items oi
ON p.order_id = oi.order_id
GROUP BY p.order_id, p.payment_amount
ORDER BY p.order_id;

select * from order_items
where quantity <= 0
or unit_price <=0;

select 
  payment_id,
  count(*)
from payments
group by payment_id
having count(*) > 1;

select 
  order_id,
  count(*)
from orders
group by order_id 
having count(*) > 1;

select * from payments
where payment_amount <= 0;

INSERT INTO customers
(customer_id, customer_name, city, state, phone_number)
SELECT
    'C' || LPAD(gs::TEXT, 3, '0'),
    'Customer ' || gs,
    (ARRAY['Chennai', 'Coimbatore', 'Bengaluru', 'Madurai', 'Salem'])[
        ((gs - 1) % 5) + 1
    ],
    (ARRAY['Tamil Nadu', 'Tamil Nadu', 'Karnataka', 'Tamil Nadu', 'Tamil Nadu'])[
        ((gs - 1) % 5) + 1
    ],
    '900000' || LPAD(gs::TEXT, 4, '0')
FROM generate_series(6, 100) AS gs; 

select count(*) as total_customers from customers;


INSERT INTO products
(product_id, product_name, category, price)
SELECT
    'P' || LPAD(gs::TEXT, 3, '0'),
    'Product ' || gs,
    (ARRAY['Electronics', 'Furniture', 'Stationery'])[
        ((gs - 1) % 3) + 1
    ],
    CASE
        WHEN gs % 3 = 0 THEN 45000
        WHEN gs % 3 = 1 THEN 2500
        ELSE 500
    END
FROM generate_series(6, 50) AS gs;

select count(*) from products;


INSERT INTO orders
(order_id, customer_id, order_date, order_status)
SELECT
    'O' || LPAD(gs::TEXT, 3, '0'),
    'C' || LPAD(((gs - 1) % 100 + 1)::TEXT, 3, '0'),
    DATE '2026-11-01' + (gs - 1),
    (ARRAY['Delivered', 'Shipped', 'Pending', 'Processing'])[
        ((gs - 1) % 4) + 1
    ]
FROM generate_series(6, 500) AS gs;

select count(*) from orders;


INSERT INTO order_items
(order_item_id, order_id, product_id, quantity, unit_price)
SELECT
    gs * 2 + item_no,
    'O' || LPAD(gs::TEXT, 3, '0'),
    'P' || LPAD(((gs + item_no - 1) % 50 + 1)::TEXT, 3, '0'),
    ((gs + item_no) % 5) + 1,
    p.price
FROM generate_series(6, 500) AS gs
CROSS JOIN generate_series(1, 2) AS item(item_no)
JOIN products p
ON p.product_id = 'P' || LPAD(((gs + item_no - 1) % 50 + 1)::TEXT, 3, '0');



select count(*) as total_records,
max(order_item_id) as last_id from order_items;


select count(distinct order_id) as total_orders from order_items;


INSERT INTO payments
(payment_id, order_id, payment_amount, payment_method, payment_date)
SELECT
    'PAY' || LPAD(gs::TEXT, 3, '0'),
    'O' || LPAD(gs::TEXT, 3, '0'),
    CASE
        WHEN gs % 3 = 0 THEN 45000
        WHEN gs % 3 = 1 THEN 2500
        ELSE 500
    END,
    (ARRAY['UPI', 'Card', 'Cash'])[
        ((gs - 1) % 3) + 1
    ],
    DATE '2026-11-01' + (gs - 1)
FROM generate_series(6, 500) AS gs;


select count(*) as total_payments from payments;

SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items,
    (SELECT COUNT(*) FROM payments) AS payments;

SELECT COUNT(*) AS invalid_orders
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS invalid_order_items
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS invalid_products
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS invalid_payments
FROM payments p
LEFT JOIN orders o
ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT payment_id, COUNT(*)
FROM payments
GROUP BY payment_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT *
FROM customers
WHERE customer_id IS NULL
   OR customer_name IS NULL
   OR city IS NULL;

SELECT *
FROM products
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL
   OR price IS NULL;

SELECT *
FROM orders
WHERE order_id IS NULL
   OR customer_id IS NULL
   OR order_date IS NULL
   OR order_status IS NULL;

SELECT *
FROM order_items
WHERE order_id IS NULL
   OR product_id IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL;

SELECT *
FROM payments
WHERE payment_id IS NULL
   OR order_id IS NULL
   OR payment_amount IS NULL
   OR payment_method IS NULL;

SELECT *
FROM order_items
WHERE quantity <= 0
   OR unit_price <= 0;

SELECT
    p.order_id,
    p.payment_amount,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS sales_amount
FROM payments p
LEFT JOIN order_items oi
ON p.order_id = oi.order_id
GROUP BY p.order_id, p.payment_amount
HAVING p.payment_amount <> COALESCE(SUM(oi.quantity * oi.unit_price), 0)
ORDER BY p.order_id;

UPDATE payments p
SET payment_amount = sales.total_sales
FROM (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS total_sales
    FROM order_items
    GROUP BY order_id
) sales
WHERE p.order_id = sales.order_id
AND p.payment_id BETWEEN 'PAY006' AND 'PAY500';


select 
  c.customer_name,
  sum(oi.quantity * oi.unit_price) as total_sales
 from customers c
 join orders o
 on c.customer_id = o.customer_id 
 join order_items oi
 on o.order_id = oi.order_id 
 group by c.customer_name 
 order by total_sales desc;


SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

select 
  order_status,
  count(*) as total_orders
from orders
group by order_status 
order by total_orders desc;

select 
  payment_method,
  count(*) as total_payments,
  sum(payment_amount) as total_amount
from payments
group by payment_method 
order by total_amount desc;

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

select 
  avg(order_total) as average_order_value
from (
  select
    order_id,
    sum(quantity * unit_price) as order_total
    from order_items
    group by order_id
  ) as order_sales;


SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    ) AS customer_rank
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_rank;

SELECT
    DATE_TRUNC('month', o.order_date) AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY sales_month; 

alter user postgres with password
'hashmohan';









 













    
















