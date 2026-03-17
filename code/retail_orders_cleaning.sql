--- ### ORDERS DATA CLEANING ### ---

SELECT * FROM orders_clean;

-- Identify duplicate records --
WITH orders_duplicates AS (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY order_id) AS row_num
	FROM orders_clean
)
SELECT * FROM orders_duplicates WHERE row_num > 1;

-- Remove the duplicate records --
WITH orders_duplicates AS (
	SELECT ctid,
	ROW_NUMBER() OVER(PARTITION BY order_id) AS row_num
	FROM orders_clean
)
DELETE FROM orders_clean
	WHERE ctid IN (
		SELECT ctid
		FROM orders_duplicates
		WHERE row_num > 1
);


--- ### STANDARDIZATION ### ---


-- Eliminate Whitespace in every column --

-- Standardize order_id column --
UPDATE orders_clean
SET order_id = TRIM(order_id);

-- Standardize product_id column --
UPDATE orders_clean
SET product_id = TRIM(product_id);

-- Standardize customer_id column --
UPDATE orders_clean
SET customer_id = TRIM(customer_id);

-- Standardize price column --
UPDATE orders_clean
SET price = TRIM(price);

-- Standardize shipping_date column --
UPDATE orders_clean
SET shipping_date = TRIM(shipping_date);


-- Standardize order_date column --
UPDATE orders_clean
SET order_date = TRIM(order_date);

-- Standardize quantity column --
UPDATE orders_clean
SET quantity = TRIM(quantity);

-- Standardize discount_pct column --
UPDATE orders_clean
SET discount_pct = TRIM(discount_pct);

-- Standardize sales_channel column --
UPDATE orders_clean
SET sales_channel = TRIM(sales_channel);

-- Standardize payment_method column --
UPDATE orders_clean
SET payment_method = TRIM(payment_method);

-- Standardize shipping_region column --
UPDATE orders_clean
SET shipping_region = TRIM(shipping_region);

-- Standardize order_status column --
UPDATE orders_clean
SET order_status = TRIM(order_status);

-- Standardize promo_code column --
UPDATE orders_clean
SET promo_code = TRIM(promo_code);

-- Standardize customer_segment column --
UPDATE orders_clean
SET customer_segment = TRIM(customer_segment);


--- ### HANDLING NULLs AND FAKE NULLs ### ---

-- Set fake nulls to real NULLs in product_id column --
UPDATE orders_clean
SET product_id = NULL
WHERE product_id IN ('Nan', 'NULL', '[null]');

-- Set fake nulls to real NULLs in customer_id column --
UPDATE orders_clean
SET customer_id = NULL
WHERE customer_id IN ('Nan', 'nan', 'NULL', '[null]', 'Null');

-- Set negative values to NULL in price column --
UPDATE orders_clean
SET price = NULL
WHERE price LIKE '%-%';

-- Set fake nulls to real NULLs in shipping_date column --
UPDATE orders_clean
SET shipping_date = NULL
WHERE shipping_date IN ('Nan', 'nan', 'NULL', '[null]', 'Null', 'null');

-- Set fake nulls to real NULLs in promo_code column --
UPDATE orders_clean
SET promo_code = NULL
WHERE promo_code IN ('Nan', 'nan', 'NAN', 'NULL', '[null]', 'Null', 'null', 'None');

UPDATE orders_clean
SET promo_code = UPPER(promo_code);

-- Set fake nulls to real NULLS in customer_segment --
UPDATE orders_clean
SET customer_segment = NULL
WHERE customer_segment IN ('Nan', 'nan', 'NAN', 'NULL', '[null]', 'Null', 'null');


-- FIX CASING IN sales_channel, payment_method, shipping_region, order_status, and customer_segment --

-- Casing for sales_channel --
UPDATE orders_clean
SET sales_channel = INITCAP(sales_channel);

-- Casing for payment_method --
UPDATE orders_clean
SET payment_method = INITCAP(payment_method);

-- Casing for shipping_region --
UPDATE orders_clean
SET shipping_region = INITCAP(shipping_region);

-- Casing for order_status --
UPDATE orders_clean
SET order_status = INITCAP(order_status);

-- Casing for customer_segment --
UPDATE orders_clean
SET customer_segment = INITCAP(customer_segment)
WHERE customer_segment != 'VIP';

-- Fix date formats in order_date and shipping_date --

-- Format order_date column to YYYY-MM-DD --
UPDATE orders_clean
SET order_date = REPLACE(order_date, '/', '-')
WHERE order_date LIKE '%/%';

UPDATE orders_clean 
SET order_date =
	CASE
	    WHEN order_date IS NULL OR order_date = 'NULL' THEN NULL
	
	    WHEN order_date ~ '^\d{4}-\d{2}-\d{2}$'
	         AND TO_CHAR(TO_DATE(order_date, 'YYYY-MM-DD'), 'YYYY-MM-DD') = order_date
	      THEN TO_DATE(order_date, 'YYYY-MM-DD')::TEXT
	
	    WHEN order_date ~ '^\d{2}-[A-Za-z]{3}-\d{4}$'
	         AND TO_CHAR(TO_DATE(order_date, 'DD-Mon-YYYY'), 'DD-Mon-YYYY') = order_date
	      THEN TO_DATE(order_date, 'DD-Mon-YYYY')::TEXT

	    WHEN order_date ~ '^[A-Za-z]{3} \d{2} \d{4}$'
	         AND TO_CHAR(TO_DATE(order_date, 'Mon DD YYYY'), 'Mon DD YYYY') = order_date
	      THEN TO_DATE(order_date, 'Mon DD YYYY')::TEXT
	
	    WHEN order_date ~ '^\d{2}-\d{2}-\d{4}$'
	         AND SPLIT_PART(order_date, '-', 1)::int > 12
	         AND TO_CHAR(TO_DATE(order_date, 'DD-MM-YYYY'), 'DD-MM-YYYY') = order_date
	      THEN TO_DATE(order_date, 'DD-MM-YYYY')::TEXT
	
	    WHEN order_date ~ '^\d{2}-\d{2}-\d{4}$'
	         AND TO_CHAR(TO_DATE(order_date, 'MM-DD-YYYY'), 'MM-DD-YYYY') = order_date
	      THEN TO_DATE(order_date, 'MM-DD-YYYY')::TEXT
	
	    ELSE NULL
	END;

-- Format shipping_date column --
UPDATE orders_clean
SET shipping_date = REPLACE(shipping_date, '/', '-')
WHERE shipping_date LIKE '%/%';

UPDATE orders_clean 
SET shipping_date =
	CASE
	    WHEN shipping_date IS NULL OR shipping_date = 'NULL' THEN NULL
	
	    WHEN shipping_date ~ '^\d{4}-\d{2}-\d{2}$'
	         AND TO_CHAR(TO_DATE(shipping_date, 'YYYY-MM-DD'), 'YYYY-MM-DD') = shipping_date
	      THEN TO_DATE(shipping_date, 'YYYY-MM-DD')::TEXT
	
	    WHEN shipping_date ~ '^\d{2}-[A-Za-z]{3}-\d{4}$'
	         AND TO_CHAR(TO_DATE(shipping_date, 'DD-Mon-YYYY'), 'DD-Mon-YYYY') = shipping_date
	      THEN TO_DATE(shipping_date, 'DD-Mon-YYYY')::TEXT

	    WHEN shipping_date ~ '^[A-Za-z]{3} \d{2} \d{4}$'
	         AND TO_CHAR(TO_DATE(shipping_date, 'Mon DD YYYY'), 'Mon DD YYYY') = shipping_date
	      THEN TO_DATE(shipping_date, 'Mon DD YYYY')::TEXT
	
	    WHEN shipping_date ~ '^\d{2}-\d{2}-\d{4}$'
	         AND SPLIT_PART(shipping_date, '-', 1)::int > 12
	         AND TO_CHAR(TO_DATE(shipping_date, 'DD-MM-YYYY'), 'DD-MM-YYYY') = shipping_date
	      THEN TO_DATE(shipping_date, 'DD-MM-YYYY')::TEXT
	
	    WHEN shipping_date ~ '^\d{2}-\d{2}-\d{4}$'
	         AND TO_CHAR(TO_DATE(shipping_date, 'MM-DD-YYYY'), 'MM-DD-YYYY') = shipping_date
	      THEN TO_DATE(shipping_date, 'MM-DD-YYYY')::TEXT
	
	    ELSE NULL
	END;

-- Validate order_date comes before shipping_date --
SELECT * FROM orders_clean WHERE order_date > shipping_date;

-- Set invalid order_date/shipping_date to NULL
UPDATE orders_clean
SET shipping_date = NULL
WHERE order_date > shipping_date;

-- ### CONVERT DATA TYPES FROM TEXT TO THEIR ACTUAL DATA TYPE ### --

-- Converting order_id from TEXT to VARCHAR(9) --
ALTER TABLE orders_clean
ALTER COLUMN order_id TYPE VARCHAR(9)
USING SUBSTRING(order_id FROM 1 FOR 9);

-- Converting product_id from TEXT to VARCHAR(6) --
ALTER TABLE orders_clean
ALTER COLUMN product_id TYPE VARCHAR(6)
USING SUBSTRING(product_id FROM 1 FOR 6);

-- Converting customer_id from TEXT to VARCHAR(7) --
ALTER TABLE orders_clean
ALTER COLUMN customer_id TYPE VARCHAR(7)
USING SUBSTRING(customer_id FROM 1 FOR 7);

-- Converting price from TEXT to NUMERIC(10, 2) --
ALTER TABLE orders_clean
ALTER COLUMN price TYPE NUMERIC(10, 2)
USING price::NUMERIC(10, 2);

-- Converting shipping_date from TEXT to DATE --
ALTER TABLE orders_clean
ALTER COLUMN shipping_date TYPE DATE
USING shipping_date::DATE;

-- Converting order_date from TEXT to DATE --
ALTER TABLE orders_clean
ALTER COLUMN order_date TYPE DATE
USING order_date::DATE;

-- Converting quantity from TEXT to INTEGER --
ALTER TABLE orders_clean
ALTER COLUMN quantity TYPE INTEGER
USING quantity::INTEGER;

-- Converting discount_pct from TEXT to NUMERIC(3, 2) --
ALTER TABLE orders_clean
ALTER COLUMN discount_pct TYPE NUMERIC(3, 2)
USING discount_pct::NUMERIC;

-- Converting sales_channel from TEXT to VARCHAR(11) --
ALTER TABLE orders_clean
ALTER COLUMN sales_channel TYPE VARCHAR(11)
USING SUBSTRING(sales_channel FROM 1 FOR 11);

-- Converting payment_method from TEXT to VARCHAR(17) --
ALTER TABLE orders_clean
ALTER COLUMN payment_method TYPE VARCHAR(17)
USING SUBSTRING(payment_method FROM 1 FOR 17);

-- Converting shipping_region from TEXT to VARCHAR(9) --
ALTER TABLE orders_clean
ALTER COLUMN shipping_region TYPE VARCHAR(20)
USING SUBSTRING(shipping_region FROM 1 FOR 20);

-- Converting order_status from TEXT to VARCHAR(9) --
ALTER TABLE orders_clean
ALTER COLUMN order_status TYPE VARCHAR(10)
USING SUBSTRING(order_status FROM 1 FOR 10);

-- Converting promo_code from TEXT to VARCHAR(20) --
ALTER TABLE orders_clean
ALTER COLUMN promo_code TYPE VARCHAR(20)
USING SUBSTRING(promo_code FROM 1 FOR 20);

-- Converting customer_segment from TEXT to VARCHAR(20) --
ALTER TABLE orders_clean
ALTER COLUMN customer_segment TYPE VARCHAR(20)
USING SUBSTRING(customer_segment FROM 1 FOR 20);


-- ### TRANSFER DATA TO FINAL ORDERS TABLE ### ---

-- Add primary key
ALTER TABLE orders_clean
ADD CONSTRAINT orders_clean_pkey
PRIMARY KEY (order_id);

-- Add foreign keys for product_id
ALTER TABLE orders_clean
ADD CONSTRAINT orders_clean_product_id_fkey
FOREIGN KEY (product_id)
REFERENCES products (product_id);

-- Add foreign keys for customer_id
ALTER TABLE orders_clean
ADD CONSTRAINT orders_clean_customer_id_fkey
FOREIGN KEY (customer_id)
REFERENCES customers (customer_id);

-- Copy full structure
CREATE TABLE orders
(LIKE orders_clean INCLUDING ALL);

-- Copy data
INSERT INTO orders
SELECT * FROM orders_clean;

-- Add constraints to customers table --
ALTER TABLE orders
ADD CONSTRAINT orders_valid_price CHECK (price > 0),
ADD CONSTRAINT orders_valid_shipping_date CHECK (shipping_date IS NULL OR shipping_date >= order_date),
ADD CONSTRAINT orders_valid_quantity CHECK (quantity > 0),
ADD CONSTRAINT orders_valid_discount_pct CHECK (discount_pct BETWEEN 0 AND 1),
ADD CONSTRAINT orders_valid_sales_channel CHECK (sales_channel IN('Online', 'Marketplace', 'Mobile App', 'In Store')),
ADD CONSTRAINT orders_valid_payment_method CHECK (payment_method IN('Apple Pay', 'Buy Now Pay Later', 'Gift Card', 'Debit Card', 'Credit Card', 'PayPal')),
ADD CONSTRAINT orders_valid_shipping_region CHECK (shipping_region IN('Midwest', 'South', 'West', 'Northeast')),
ADD CONSTRAINT orders_valid_order_status CHECK (order_status IN('Delivered', 'Processing', 'Shipped', 'Cancelled', 'Returned')),
ADD CONSTRAINT orders_valid_promo_code CHECK (promo_code IN('SAVE15', 'WELCOME10', 'FREESHIP', 'BFCM25')),
ADD CONSTRAINT orders_valid_customer_segment CHECK (customer_segment IN('Returning', 'New', 'VIP'));

-- DROP STAGING TABLES --
DROP TABLE orders_clean;
DROP TABLE orders_raw;


-- Check finalized table --
SELECT * FROM orders;