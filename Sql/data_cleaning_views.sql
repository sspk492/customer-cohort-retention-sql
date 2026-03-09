USE olist_db;

-- Order-level revenue
CREATE OR REPLACE VIEW order_revenue AS
SELECT
    order_id,
    SUM(payment_value) AS order_revenue
FROM olist_order_payments
GROUP BY order_id;

-- Delivered orders enriched with customer + time features
CREATE OR REPLACE VIEW orders_enriched AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    DATE(o.order_purchase_timestamp) AS order_date,
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS order_month,
    r.order_revenue
FROM olist_orders o
JOIN olist_customers c
    ON o.customer_id = c.customer_id
LEFT JOIN order_revenue r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL;
  

SELECT * FROM orders_enriched LIMIT 10;