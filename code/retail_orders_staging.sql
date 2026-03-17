--- ### ORDERS DATA STAGING ### ---

CREATE TABLE orders_raw (
	order_id TEXT,
	product_id TEXT,
	customer_id TEXT,
	price TEXT,
	shipping_date TEXT,
	order_date TEXT,
	quantity TEXT,
	discount_pct TEXT,
	sales_channel TEXT,
	payment_method TEXT,
	shipping_region TEXT,
	order_status TEXT,
	promo_code TEXT,
	customer_segment TEXT
);

COPY orders_raw FROM 'C:\Data Analyst Projects\retail_dataset\retail_orders_dirty.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');

CREATE TABLE orders_clean AS SELECT * FROM orders_raw;