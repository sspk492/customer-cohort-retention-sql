USE olist_db;

-- Enable local infile if needed
SET GLOBAL local_infile = 1;

-- Customers
LOAD DATA LOCAL INFILE '/Users/prudhvikrishna/Documents/Projects/Brazilian E-Commerce Dataset/cleaned/olist_customers_clean.csv'
INTO TABLE olist_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id,
 customer_unique_id,
 customer_zip_code_prefix,
 customer_city,
 customer_state);

-- Orders
LOAD DATA LOCAL INFILE '/Users/prudhvikrishna/Documents/Projects/Brazilian E-Commerce Dataset/cleaned/olist_orders_clean.csv'
INTO TABLE olist_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id,
 customer_id,
 order_status,
 order_purchase_timestamp,
 order_approved_at,
 order_delivered_carrier_date,
 order_delivered_customer_date,
 order_estimated_delivery_date);

-- Order Items
LOAD DATA LOCAL INFILE '/Users/prudhvikrishna/Documents/Projects/Brazilian E-Commerce Dataset/cleaned/olist_order_items_clean.csv'
INTO TABLE olist_order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id,
 order_item_id,
 product_id,
 seller_id,
 shipping_limit_date,
 price,
 freight_value);

-- Payments
LOAD DATA LOCAL INFILE '/Users/prudhvikrishna/Documents/Projects/Brazilian E-Commerce Dataset/cleaned/olist_order_payments_clean.csv'
INTO TABLE olist_order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id,
 payment_sequential,
 payment_type,
 payment_installments,
 payment_value);

-- Products
LOAD DATA LOCAL INFILE '/Users/prudhvikrishna/Documents/Projects/Brazilian E-Commerce Dataset/cleaned/olist_products_clean.csv'
INTO TABLE olist_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id,
 product_category_name,
 product_name_lenght,
 product_description_lenght,
 product_photos_qty,
 product_weight_g,
 product_length_cm,
 product_height_cm,
 product_width_cm);

-- Sellers
LOAD DATA LOCAL INFILE '/Users/prudhvikrishna/Documents/Projects/Brazilian E-Commerce Dataset/cleaned/olist_sellers_clean.csv'
INTO TABLE olist_sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(seller_id,
 seller_zip_code_prefix,
 seller_city,
 seller_state);

-- Geolocation
LOAD DATA LOCAL INFILE '/Users/prudhvikrishna/Documents/Projects/Brazilian E-Commerce Dataset/cleaned/olist_geolocation_clean.csv'
INTO TABLE olist_geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
 geolocation_zip_code_prefix,
 geolocation_lat,
 geolocation_lng,
 geolocation_city,
 geolocation_state
);

-- Reviews
LOAD DATA LOCAL INFILE '/Users/prudhvikrishna/Documents/Projects/Brazilian E-Commerce Dataset/cleaned/olist_order_reviews_clean.csv'
INTO TABLE olist_order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id,
 order_id,
 review_score,
 review_creation_date,
 review_answer_timestamp);

-- Category Translation
LOAD DATA LOCAL INFILE '/Users/prudhvikrishna/Documents/Projects/Brazilian E-Commerce Dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_category_name,
 product_category_name_english);
 
 
SELECT COUNT(*) AS orders_cnt FROM olist_orders;
SELECT COUNT(*) AS customers_cnt FROM olist_customers;
SELECT COUNT(*) AS items_cnt FROM olist_order_items;