-- ### PRODUCTS DATA STAGING ### ---

CREATE TABLE products_raw (
	product_id TEXT,
	product_name TEXT,
	product_category TEXT,
	manufacturing_city TEXT,
	size TEXT,
	color TEXT,
	sku TEXT,
	brand TEXT,
	material TEXT,
	base_cost TEXT,
	list_price TEXT,
	inventory_on_hand TEXT,
	rating TEXT,
	launch_date TEXT
);

COPY products_raw FROM 'C:\Data Analyst Projects\retail_dataset\retail_products_dirty.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');


CREATE TABLE products_clean AS SELECT * FROM products_raw;