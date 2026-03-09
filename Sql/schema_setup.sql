CREATE DATABASE olist_db;

USE olist_db;

-- Customers
CREATE TABLE IF NOT EXISTS olist_customers (
    customer_id                VARCHAR(50) PRIMARY KEY,
    customer_unique_id         VARCHAR(50),
    customer_zip_code_prefix   INT,
    customer_city              VARCHAR(100),
    customer_state             CHAR(2)
);

-- Orders
CREATE TABLE IF NOT EXISTS olist_orders (
    order_id                       VARCHAR(50) PRIMARY KEY,
    customer_id                    VARCHAR(50),
    order_status                   VARCHAR(50),
    order_purchase_timestamp       DATETIME,
    order_approved_at              DATETIME,
    order_delivered_carrier_date   DATETIME,
    order_delivered_customer_date  DATETIME,
    order_estimated_delivery_date  DATETIME,
    FOREIGN KEY (customer_id) REFERENCES olist_customers(customer_id)
);

-- Order Items
CREATE TABLE IF NOT EXISTS olist_order_items (
    order_id             VARCHAR(50),
    order_item_id        INT,
    product_id           VARCHAR(50),
    seller_id            VARCHAR(50),
    shipping_limit_date  DATETIME,
    price                DECIMAL(10,2),
    freight_value        DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- Payments
CREATE TABLE IF NOT EXISTS olist_order_payments (
    order_id             VARCHAR(50),
    payment_sequential   INT,
    payment_type         VARCHAR(50),
    payment_installments INT,
    payment_value        DECIMAL(10,2)
);

-- Products
CREATE TABLE IF NOT EXISTS olist_products (
    product_id                    VARCHAR(50) PRIMARY KEY,
    product_category_name         VARCHAR(100),
    product_name_lenght           INT,
    product_description_lenght    INT,
    product_photos_qty            INT,
    product_weight_g              INT,
    product_length_cm             INT,
    product_height_cm             INT,
    product_width_cm              INT
);

-- Sellers
CREATE TABLE IF NOT EXISTS olist_sellers (
    seller_id              VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city            VARCHAR(100),
    seller_state           CHAR(2)
);

-- Geolocation
CREATE TABLE IF NOT EXISTS olist_geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat             DECIMAL(11,9),
    geolocation_lng             DECIMAL(11,9),
    geolocation_city            VARCHAR(100),
    geolocation_state           CHAR(2)
);

-- Order Reviews
CREATE TABLE IF NOT EXISTS olist_order_reviews (
    review_id                VARCHAR(50) PRIMARY KEY,
    order_id                 VARCHAR(50),
    review_score             INT,
    review_creation_date     DATETIME,
    review_answer_timestamp  DATETIME
);

-- Category Translation
CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name         VARCHAR(100),
    product_category_name_english VARCHAR(100)
);