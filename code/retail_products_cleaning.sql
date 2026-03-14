-- ### PRODUCTS DATA CLEANING ### ---

SELECT * FROM products_clean;

-- Identify the duplicates -- 
WITH duplicates AS (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY product_id, sku) AS row_num
	FROM products_clean
)
SELECT * FROM duplicates WHERE row_num > 1;


-- Remove the duplicates --
WITH duplicates AS (
	SELECT ctid,
	ROW_NUMBER() OVER(PARTITION BY product_id, sku) AS row_num
	FROM products_clean
)
DELETE FROM products_clean
WHERE ctid IN (
	SELECT ctid
	FROM duplicates
	WHERE row_num > 1
);


-- ### STANDARDIZATION ### --


-- Standardize product_id column --
UPDATE products_clean
SET product_id = TRIM(product_id);


-- Standardize product_name column --
UPDATE products_clean
SET product_name = INITCAP(TRIM(product_name));


-- Standardize product_category column --
UPDATE products_clean
SET product_category = INITCAP(TRIM(product_category));


-- Standardize manufacturing_city column --
UPDATE products_clean
SET manufacturing_city = INITCAP(TRIM(manufacturing_city));


-- Standardize size column --
UPDATE products_clean
SET size = INITCAP(TRIM(size));


-- Standardize color column --
UPDATE products_clean
SET color = INITCAP(TRIM(color));


-- Standardize sku column --
UPDATE products_clean
SET sku = TRIM(sku);


-- Standardize brand column --
UPDATE products_clean
SET brand = INITCAP(TRIM(brand))
WHERE brand IN ('Aster', 'Drift Co', 'Luma', 'Modern Harbor', 'Northline');

UPDATE products_clean
SET brand = TRIM(brand)
WHERE brand = 'EverTrail';


-- Standardize material column --
UPDATE products_clean
SET material = INITCAP(TRIM(material));


-- Standardize base_cost column --
UPDATE products_clean
SET base_cost = TRIM(base_cost);


-- Standardize list_price column --
UPDATE products_clean
SET list_price = TRIM(list_price);


-- Standardize inventory_on_hand column --
UPDATE products_clean
SET inventory_on_hand = TRIM(inventory_on_hand);



-- Standardize rating column --
UPDATE products_clean
SET rating = TRIM(rating);



-- Standardize launch_date column --
UPDATE products_clean
SET launch_date = TRIM(launch_date);


-- ### HANDLING NULLs, AND FAKE NULLs ### --


-- Set fake null to real NULL in size column --
UPDATE products_clean
SET size = NULL
WHERE size = '[Null]';


-- Set fake null to real NULL in color column --
UPDATE products_clean
SET color = NULL
WHERE color IN ('Null', 'Nan');



-- Set fake null to real NULL in sku column --
UPDATE products_clean
SET sku = NULL
WHERE sku = 'Nan';


-- Set fake null to real NULL in material column --
UPDATE products_clean
SET material = NULL
WHERE material IN ('Null', 'Nan');



-- Set fake null to real NULL in rating column --
UPDATE products_clean
SET rating = NULL
WHERE rating = 'NULL';


-- Change Date Formats --
UPDATE products_clean
SET launch_date = TO_CHAR(TO_DATE(launch_date, 'Mon DD YYYY'),'MM/DD/YYYY')
WHERE launch_date = 'Aug 21 2025';

UPDATE products_clean
SET launch_date = TO_CHAR(TO_DATE(launch_date, 'MM/DD/YYYY'),'YYYY-MM-DD');


-- FIX NEGATIVE base_cost VALUES --
UPDATE products_clean
SET base_cost = NULL
WHERE product_id = '895667';



-- FIX NEGATIVE list_price VALUES --
UPDATE products_clean
SET list_price = NULL
WHERE product_id = '864544';


-- CONVERT DATA TYPES FROM TEXT TO THEIR ACTUAL DATA TYPE --

-- Converting product_id from TEXT to VARCHAR(6) --
ALTER TABLE products_clean
ALTER COLUMN product_id TYPE VARCHAR(6)
USING SUBSTRING(product_id FROM 1 FOR 6);

-- Converting product_name from TEXT to VARCHAR(20)
ALTER TABLE products_clean
ALTER COLUMN product_name TYPE VARCHAR(20)
USING SUBSTRING(product_name FROM 1 FOR 20);


-- Converting product_category from TEXT to VARCHAR(11)
ALTER TABLE products_clean
ALTER COLUMN product_category TYPE VARCHAR(11)
USING SUBSTRING(product_category FROM 1 FOR 11);


-- Converting manufacturing_city from TEXT to VARCHAR(11)
ALTER TABLE products_clean
ALTER COLUMN manufacturing_city TYPE VARCHAR(11)
USING SUBSTRING(manufacturing_city FROM 1 FOR 11);


-- Converting size from TEXT to VARCHAR(8)
ALTER TABLE products_clean
ALTER COLUMN size TYPE VARCHAR(8)
USING SUBSTRING(size FROM 1 FOR 8);



-- Converting color from TEXT to VARCHAR(6)
ALTER TABLE products_clean
ALTER COLUMN color TYPE VARCHAR(6)
USING SUBSTRING(color FROM 1 FOR 6);


-- Converting sku from TEXT to VARCHAR(8)
ALTER TABLE products_clean
ALTER COLUMN sku TYPE VARCHAR(8)
USING SUBSTRING(sku FROM 1 FOR 8);



-- Converting brand from TEXT to VARCHAR(13)
ALTER TABLE products_clean
ALTER COLUMN brand TYPE VARCHAR(13)
USING SUBSTRING(brand FROM 1 FOR 13);



-- Converting material from TEXT to VARCHAR(13)
ALTER TABLE products_clean
ALTER COLUMN material TYPE VARCHAR(9)
USING SUBSTRING(material FROM 1 FOR 9);



-- Converting base_cost from TEXT to NUMERIC(10,2)
ALTER TABLE products_clean
ALTER COLUMN base_cost TYPE NUMERIC(10,2)
USING base_cost::NUMERIC(10,2);


-- Converting list_price from TEXT to NUMERIC(10,2)
ALTER TABLE products_clean
ALTER COLUMN list_price TYPE NUMERIC(10,2)
USING list_price::NUMERIC(10,2);



-- Converting inventory_on_hand from TEXT to INTEGER
ALTER TABLE products_clean
ALTER COLUMN inventory_on_hand TYPE INTEGER
USING inventory_on_hand::INTEGER;


-- Converting rating from TEXT to NUMERIC(2,1)
ALTER TABLE products_clean
ALTER COLUMN rating TYPE NUMERIC(2,1)
USING rating::NUMERIC(2,1);


-- Converting launch_date from TEXT to DATE
ALTER TABLE products_clean
ALTER COLUMN launch_date TYPE DATE
USING launch_date::DATE;

-- ### TRANSFER DATA TO FINAL PRODUCTS TABLE ### ---

-- Add primary key
ALTER TABLE products_clean
ADD CONSTRAINT products_clean_pkey
PRIMARY KEY (product_id);

-- Copy full structure
CREATE TABLE products
(LIKE products_clean INCLUDING ALL);

-- Copy data
INSERT INTO products
SELECT * FROM products_clean;


-- Add constraints to products table --
ALTER TABLE products
ADD CONSTRAINT products_base_cost_nonnegative CHECK (base_cost >= 0),
ADD CONSTRAINT products_list_price_nonnegative CHECK (list_price >= 0),
ADD CONSTRAINT products_inventory_on_hand_nonnegative CHECK (inventory_on_hand >= 0),
ADD CONSTRAINT products_rating_valid_range CHECK (rating BETWEEN 1 AND 5),
ADD CONSTRAINT products_sku_numeric_only CHECK (sku ~ '^[0-9]{8}$'),
ADD CONSTRAINT products_launch_date_valid CHECK (launch_date IS NULL OR (launch_date >= DATE '2000-01-01' AND launch_date <= CURRENT_DATE));

-- DROP STAGING TABLE --
DROP TABLE products_raw;
DROP TABLE products_clean;

-- Check finalized table --
SELECT * FROM products;