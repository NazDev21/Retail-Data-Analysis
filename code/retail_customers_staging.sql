--- ### CUSTOMERS DATA STAGING ### ---

CREATE TABLE customers_raw (
	customer_id TEXT,
	first_name TEXT,
	last_name TEXT,
	gender TEXT,
	email TEXT,
	phone_number TEXT,
	street_address TEXT,
	city TEXT,
	state TEXT,
	zip_code TEXT,
	country TEXT,
	signup_date TEXT,
	date_of_birth TEXT,
	loyalty_status TEXT,
	preferred_channel TEXT,
	marketing_opt_in TEXT,
	lifetime_value TEXT,
	returns_rate TEXT,
	customer_status TEXT
);


COPY customers_raw FROM 'C:\Data Analyst Projects\retail_dataset\retail_customers_dirty.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');

CREATE TABLE customers_clean AS SELECT * FROM customers_raw;