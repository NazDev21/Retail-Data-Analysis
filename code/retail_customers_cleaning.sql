-- ### CUSTOMERS DATA CLEANING ### --

SELECT * FROM customers_clean;


-- Identify the duplicates --
WITH customers_duplicates AS (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY customer_id) AS row_num
	FROM customers_clean
)
SELECT * FROM customers_duplicates WHERE row_num > 1;

-- Remove the duplicates --
WITH customers_duplicates AS (
	SELECT ctid,
	ROW_NUMBER() OVER(PARTITION BY customer_id) AS row_num
	FROM customers_clean
)
DELETE FROM customers_clean
	WHERE ctid IN (
		SELECT ctid
		FROM customers_duplicates
		WHERE row_num > 1
);


-- ### STANDARDIZATION ### --

-- Standardize customer_id column --
UPDATE customers_clean
SET customer_id = TRIM(customer_id);


-- Standardize first_name column --
UPDATE customers_clean
SET first_name = INITCAP(TRIM(first_name));


-- Standardize last_name column --
UPDATE customers_clean
SET last_name = INITCAP(TRIM(last_name));


-- Standardize gender column --
UPDATE customers_clean
SET gender = INITCAP(TRIM(gender));


-- Standardize email column --
UPDATE customers_clean
SET email = LOWER(TRIM(email));


-- Standardize phone_number column --
UPDATE customers_clean
SET phone_number = TRIM(phone_number);


-- Standardize street_address column --
UPDATE customers_clean
SET street_address = INITCAP(TRIM(street_address));


-- Standardize city column --
UPDATE customers_clean
SET city = INITCAP(TRIM(city));


-- Standardize state column --
UPDATE customers_clean
SET state = UPPER(TRIM(state));


-- Standardize zip_code column --
UPDATE customers_clean
SET zip_code = TRIM(zip_code);


-- Standardize country column --
UPDATE customers_clean
SET country = TRIM(country);

UPDATE customers_clean
SET country = 'USA'
WHERE country IN ('[null]', 'NAN', 'US', 'Usa', 'usa', 'nan', 'Null', 'Nan', 'united states', 'United States', 'NULL') OR country IS NULL;


-- Standardize signup_date column --
UPDATE customers_clean
SET signup_date = TRIM(signup_date);


-- Standardize date_of_birth column --
UPDATE customers_clean
SET date_of_birth = TRIM(date_of_birth);


-- Standardize loyalty_status column --
UPDATE customers_clean
SET loyalty_status = INITCAP(TRIM(loyalty_status));


-- Standardize preferred_channel column --
UPDATE customers_clean
SET preferred_channel = TRIM(preferred_channel);

UPDATE customers_clean
SET preferred_channel = INITCAP(preferred_channel)
WHERE preferred_channel != 'SMS'


-- Standardize marketing_opt_in column --
UPDATE customers_clean
SET marketing_opt_in = INITCAP(TRIM(marketing_opt_in));

UPDATE customers_clean
SET marketing_opt_in = 'Yes'
WHERE marketing_opt_in = 'Y'

UPDATE customers_clean
SET marketing_opt_in = 'No'
WHERE marketing_opt_in = 'N'


-- Standardize lifetime_value column --
UPDATE customers_clean
SET lifetime_value = TRIM(lifetime_value);


-- Standardize returns_rate column --
UPDATE customers_clean
SET returns_rate = TRIM(returns_rate);


-- Standardize customer_status column --
UPDATE customers_clean
SET customer_status = TRIM(customer_status)

UPDATE customers_clean
SET customer_status = INITCAP(customer_status)
WHERE customer_status != 'VIP';


--- ### HANDLING NULLs AND FAKE NULLs ### ---


-- Set fake null to real NULL in first_name column --
UPDATE customers_clean
SET first_name = NULL
WHERE first_name IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in last_name column --
UPDATE customers_clean
SET last_name = NULL
WHERE last_name IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in gender column --
UPDATE customers_clean
SET gender = NULL
WHERE gender IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in email column --
UPDATE customers_clean
SET email = NULL
WHERE email IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in phone_number column --
UPDATE customers_clean
SET phone_number = NULL
WHERE phone_number IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in street_address column --
UPDATE customers_clean
SET street_address = NULL
WHERE street_address IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in city column --
UPDATE customers_clean
SET city = NULL
WHERE city IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in state column --
UPDATE customers_clean
SET state = NULL
WHERE state IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in zip_code column --
UPDATE customers_clean
SET zip_code = NULL
WHERE zip_code IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in country column --
UPDATE customers_clean
SET country = NULL
WHERE country IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in signup_date column --
UPDATE customers_clean
SET signup_date = NULL
WHERE signup_date IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in date_of_birth column --
UPDATE customers_clean
SET date_of_birth = NULL
WHERE date_of_birth IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in loyalty_status column --
UPDATE customers_clean
SET loyalty_status = NULL
WHERE loyalty_status IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in preferred_channel column --
UPDATE customers_clean
SET preferred_channel = NULL
WHERE preferred_channel IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in marketing_opt_in column --
UPDATE customers_clean
SET marketing_opt_in = NULL
WHERE marketing_opt_in IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in lifetime_value column --
UPDATE customers_clean
SET lifetime_value = NULL
WHERE lifetime_value IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in returns_rate column --
UPDATE customers_clean
SET returns_rate = NULL
WHERE returns_rate IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');

-- Set fake null to real NULL in customer_status column --
UPDATE customers_clean
SET customer_status = NULL
WHERE customer_status IN('[null]', '[Null]', '[NULL]', 'nan', 'NAN', 'Nan', 'Null', 'NULL');


--- ### FORMAT PHONE NUMBER, DATE AND NUMERICAL COLUMNS ### ---


-- Format phone_number column to ###-###-#### --
UPDATE customers_clean
SET phone_number = REGEXP_REPLACE(phone_number, '^1 ', '')
WHERE phone_number LIKE '1 %';

UPDATE customers_clean
SET phone_number = REGEXP_REPLACE(phone_number, '\D', '', 'g')

UPDATE customers_clean
SET phone_number = REGEXP_REPLACE(phone_number, '(\d{3})(\d{3})(\d{4})', '\1-\2-\3');

UPDATE customers_clean
SET phone_number = NULL
WHERE phone_number IN ('000-000-0000', '999-999-9999'); 

-- Format signup_date column to YYYY-MM-DD --
UPDATE customers_clean
SET signup_date = REPLACE(signup_date, '/', '-')
WHERE signup_date LIKE '%/%';

UPDATE customers_clean
SET signup_date = 
	CASE
	    WHEN signup_date IS NULL OR signup_date = 'NULL' THEN NULL
	
	    WHEN signup_date ~ '^\d{4}-\d{2}-\d{2}$'
	         AND TO_CHAR(TO_DATE(signup_date, 'YYYY-MM-DD'), 'YYYY-MM-DD') = signup_date
	      THEN TO_DATE(signup_date, 'YYYY-MM-DD')::TEXT
	
	    WHEN signup_date ~ '^\d{2}-[A-Za-z]{3}-\d{4}$'
	         AND TO_CHAR(TO_DATE(signup_date, 'DD-Mon-YYYY'), 'DD-Mon-YYYY') = signup_date
	      THEN TO_DATE(signup_date, 'DD-Mon-YYYY')::TEXT
	
	    WHEN signup_date ~ '^\d{2}-\d{2}-\d{4}$'
	         AND SPLIT_PART(signup_date, '-', 1)::int > 12
	         AND TO_CHAR(TO_DATE(signup_date, 'DD-MM-YYYY'), 'DD-MM-YYYY') = signup_date
	      THEN TO_DATE(signup_date, 'DD-MM-YYYY')::TEXT
	
	    WHEN signup_date ~ '^\d{2}-\d{2}-\d{4}$'
	         AND TO_CHAR(TO_DATE(signup_date, 'MM-DD-YYYY'), 'MM-DD-YYYY') = signup_date
	      THEN TO_DATE(signup_date, 'MM-DD-YYYY')::TEXT
	
	    ELSE NULL
	END;

-- Format date_of_birth column to YYYY-MM-DD --
UPDATE customers_clean
SET date_of_birth = REPLACE(date_of_birth, '/', '-')
WHERE date_of_birth LIKE '%/%';

UPDATE customers_clean 
SET date_of_birth =
	CASE
	    WHEN date_of_birth IS NULL OR date_of_birth = 'NULL' THEN NULL
	
	    WHEN date_of_birth ~ '^\d{4}-\d{2}-\d{2}$'
	         AND TO_CHAR(TO_DATE(date_of_birth, 'YYYY-MM-DD'), 'YYYY-MM-DD') = date_of_birth
	      THEN TO_DATE(date_of_birth, 'YYYY-MM-DD')::TEXT
	
	    WHEN date_of_birth ~ '^\d{2}-[A-Za-z]{3}-\d{4}$'
	         AND TO_CHAR(TO_DATE(date_of_birth, 'DD-Mon-YYYY'), 'DD-Mon-YYYY') = date_of_birth
	      THEN TO_DATE(date_of_birth, 'DD-Mon-YYYY')::TEXT
	
	    WHEN date_of_birth ~ '^\d{2}-\d{2}-\d{4}$'
	         AND SPLIT_PART(date_of_birth, '-', 1)::int > 12
	         AND TO_CHAR(TO_DATE(date_of_birth, 'DD-MM-YYYY'), 'DD-MM-YYYY') = date_of_birth
	      THEN TO_DATE(date_of_birth, 'DD-MM-YYYY')::TEXT
	
	    WHEN date_of_birth ~ '^\d{2}-\d{2}-\d{4}$'
	         AND TO_CHAR(TO_DATE(date_of_birth, 'MM-DD-YYYY'), 'MM-DD-YYYY') = date_of_birth
	      THEN TO_DATE(date_of_birth, 'MM-DD-YYYY')::TEXT
	
	    ELSE NULL
	END;

-- Validate all signup_date values come after date_of_birth values -- 
SELECT *
FROM customers_clean
WHERE signup_date <= date_of_birth;

-- Handle negative values in lifetime_value column --
UPDATE customers_clean
SET lifetime_value = NULL
WHERE lifetime_value LIKE '%-%';


-- ### CONVERT DATA TYPES FROM TEXT TO THEIR ACTUAL DATA TYPE ### --

-- Converting customer_id from TEXT to VARCHAR(7) --
ALTER TABLE customers_clean
ALTER COLUMN customer_id TYPE VARCHAR(7)
USING SUBSTRING(customer_id FROM 1 FOR 7);

-- Converting first_name from TEXT to VARCHAR(50) --
ALTER TABLE customers_clean
ALTER COLUMN first_name TYPE VARCHAR(50);

-- Converting last_name from TEXT to VARCHAR(50) --
ALTER TABLE customers_clean
ALTER COLUMN last_name TYPE VARCHAR(50);

-- Converting gender from TEXT to VARCHAR(50) --
ALTER TABLE customers_clean
ALTER COLUMN gender TYPE VARCHAR(17)
USING SUBSTRING(gender FROM 1 FOR 17);

-- Converting phone_number from TEXT to VARCHAR(12) --
ALTER TABLE customers_clean
ALTER COLUMN phone_number TYPE VARCHAR(12)
USING SUBSTRING(phone_number FROM 1 FOR 12);

-- Converting state from TEXT to VARCHAR(2) --
ALTER TABLE customers_clean
ALTER COLUMN state TYPE CHAR(2)
USING SUBSTRING(state FROM 1 FOR 2);

-- Converting zip_code from TEXT to VARCHAR(5) --
ALTER TABLE customers_clean
ALTER COLUMN zip_code TYPE VARCHAR(5)
USING SUBSTRING(zip_code FROM 1 FOR 5);

-- Converting country from TEXT to CHAR(3) --
ALTER TABLE customers_clean
ALTER COLUMN country TYPE CHAR(3)
USING SUBSTRING(country FROM 1 FOR 3);

-- Converting signup_date from TEXT to DATE --
ALTER TABLE customers_clean
ALTER COLUMN signup_date TYPE DATE
USING signup_date::DATE;

-- Converting date_of_birth from TEXT to DATE --
ALTER TABLE customers_clean
ALTER COLUMN date_of_birth TYPE DATE
USING date_of_birth::DATE;

-- Converting loyalty_status from TEXT to VARCHAR(8) --
ALTER TABLE customers_clean
ALTER COLUMN loyalty_status TYPE VARCHAR(8)
USING SUBSTRING(loyalty_status FROM 1 FOR 8);

-- Converting preferred_channel from TEXT to VARCHAR(8) --
ALTER TABLE customers_clean
ALTER COLUMN preferred_channel TYPE VARCHAR(8)
USING SUBSTRING(preferred_channel FROM 1 FOR 8);

-- Converting marketing_opt_in from TEXT to CHAR(3) --
ALTER TABLE customers_clean
ALTER COLUMN marketing_opt_in TYPE CHAR(3)
USING SUBSTRING(marketing_opt_in FROM 1 FOR 3);

-- Converting lifetime_value from TEXT to NUMERIC(10, 2) --
ALTER TABLE customers_clean
ALTER COLUMN lifetime_value TYPE NUMERIC(10, 2)
USING lifetime_value::NUMERIC(10,2);

-- Converting returns_rate from TEXT to NUMERIC(3, 2) --
ALTER TABLE customers_clean
ALTER COLUMN returns_rate TYPE NUMERIC(3, 2)
USING returns_rate::NUMERIC(3,2);

-- Converting customer_status from TEXT to VARCHAR(10) --
ALTER TABLE customers_clean
ALTER COLUMN customer_status TYPE VARCHAR(10)
USING SUBSTRING(customer_status FROM 1 FOR 10);


-- ### TRANSFER DATA TO FINAL CUSTOMERS TABLE ### ---

-- Add primary key
ALTER TABLE customers_clean
ADD CONSTRAINT customers_clean_pkey
PRIMARY KEY (customer_id);

-- Copy full structure
CREATE TABLE customers
(LIKE customers_clean INCLUDING ALL);

-- Copy data
INSERT INTO customers
SELECT * FROM customers_clean;

-- Add constraints to customers table --
ALTER TABLE customers
ADD CONSTRAINT customers_valid_gender CHECK (gender IN('Male', 'Female', 'Non-Binary', 'Prefer Not To Say')),
ADD CONSTRAINT customers_valid_phone_number CHECK (phone_number ~ '^\d{3}-\d{3}-\d{4}$'),
ADD CONSTRAINT customers_valid_country CHECK (country = 'USA'),
ADD CONSTRAINT customers_valid_loyalty_status CHECK (loyalty_status IN('Bronze', 'Silver', 'Gold', 'Platinum', 'None')),
ADD CONSTRAINT customers_valid_preferred_channel CHECK (preferred_channel IN('Email', 'SMS', 'In-Store', 'Phone', 'App Push')),
ADD CONSTRAINT customers_valid_marketing_opt_in CHECK (marketing_opt_in IN('Yes', 'No')),
ADD CONSTRAINT customers_valid_lifetime_value CHECK (lifetime_value >= 0),
ADD CONSTRAINT customers_valid_returns_rate CHECK (returns_rate BETWEEN 0 AND 1),
ADD CONSTRAINT customers_valid_customer_status CHECK (customer_status IN('Active', 'Inactive', 'VIP', 'Churn Risk'));

-- DROP STAGING TABLES --
DROP TABLE customers_clean;
DROP TABLE customers_raw;

-- Check finalized table --
SELECT * FROM customers;