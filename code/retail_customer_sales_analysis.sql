--- ### RETAIL CUSTOMER AND SALES ANALYSIS ### ---

-- Questions --

-- 1. Which product categories drive the highest revenue among high-loyalty customers?
SELECT 
    product_category,
    loyalty_status,
    ROUND(SUM(price * quantity * (1 - discount_pct / 100.00)), 2) AS total_revenue
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN products ON orders.product_id = products.product_id
WHERE order_status != 'Returned' AND loyalty_status IS NOT NULL
GROUP BY product_category, loyalty_status
ORDER BY total_revenue DESC;

-- 2. Do high-return-rate customers gravitate toward specific products or brands?
SELECT 
    product_name,
    brand,
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS total_returns,
    ROUND(SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*), 2) AS actual_return_rate,
    ROUND(AVG(returns_rate), 2) AS avg_customer_returns_rate
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN products ON orders.product_id = products.product_id
WHERE returns_rate IS NOT NULL
GROUP BY product_name, brand
ORDER BY actual_return_rate DESC;

-- 3. How does regional shipping performance vary by product category and customer segment?
SELECT
    shipping_region,
    product_category,
    customer_segment,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS total_delivered,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS total_returned,
    ROUND(SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*), 2) AS delivery_rate,
    ROUND(SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*), 2) AS return_rate
FROM orders
INNER JOIN products ON orders.product_id = products.product_id
WHERE customer_segment IS NOT NULL
GROUP BY shipping_region, product_category, customer_segment
ORDER BY shipping_region, return_rate DESC;
	
-- 4. Which sales channels and payment methods yield the highest profit margins per product?
SELECT
    sales_channel,
    payment_method,
    product_name,
    ROUND(SUM((price * (1 - COALESCE(discount_pct, 0) / 100.00) - base_cost) * quantity), 2) AS total_profit
FROM orders
INNER JOIN products ON orders.product_id = products.product_id
WHERE order_status != 'Returned'
    AND price IS NOT NULL
    AND base_cost IS NOT NULL
GROUP BY sales_channel, payment_method, product_name
ORDER BY total_profit DESC;

-- 5. Are newer customers (by signup date) purchasing newer product launches, and how does this affect lifetime value?
SELECT
    DATE_PART('year', signup_date) AS signup_year,
    DATE_PART('year', launch_date) AS launch_year,
    COUNT(DISTINCT customers.customer_id) AS total_customers,
    ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN products ON orders.product_id = products.product_id
WHERE DATE_PART('year', signup_date) != 2026
    AND signup_date IS NOT NULL
    AND lifetime_value IS NOT NULL
GROUP BY signup_year, launch_year
ORDER BY signup_year DESC, launch_year DESC;