USE olist_db;

-- Base customer behavior: orders, revenue, timing
CREATE OR REPLACE VIEW customer_behavior_base AS
WITH customer_orders AS (
    SELECT
        customer_unique_id,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(order_revenue) AS total_revenue
    FROM orders_enriched
    GROUP BY customer_unique_id
),
order_intervals AS (
    SELECT
        customer_unique_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_unique_id
            ORDER BY order_date
        ) AS prev_order_date
    FROM orders_enriched
),
interval_stats AS (
    SELECT
        customer_unique_id,
        AVG(TIMESTAMPDIFF(DAY, prev_order_date, order_date)) AS avg_days_between_orders
    FROM order_intervals
    WHERE prev_order_date IS NOT NULL
    GROUP BY customer_unique_id
)
SELECT
    co.customer_unique_id,
    co.first_order_date,
    co.last_order_date,
    co.total_orders,
    co.total_revenue,
    co.total_revenue / NULLIF(co.total_orders, 0) AS avg_order_value,
    TIMESTAMPDIFF(DAY, co.first_order_date, co.last_order_date) AS active_days,
    CASE 
        WHEN co.total_orders > 1 THEN TIMESTAMPDIFF(DAY, co.first_order_date, co.last_order_date)
        ELSE NULL
    END AS days_between_first_last,
    i.avg_days_between_orders
FROM customer_orders co
LEFT JOIN interval_stats i
    ON co.customer_unique_id = i.customer_unique_id;

-- Top category per customer
CREATE OR REPLACE VIEW customer_top_category AS
WITH customer_category_counts AS (
    SELECT
        oe.customer_unique_id,
        COALESCE(t.product_category_name_english, p.product_category_name) AS category_name,
        COUNT(*) AS category_orders
    FROM orders_enriched oe
    JOIN olist_order_items oi
        ON oe.order_id = oi.order_id
    JOIN olist_products p
        ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation t
        ON p.product_category_name = t.product_category_name
    GROUP BY oe.customer_unique_id, category_name
),
ranked_categories AS (
    SELECT
        customer_unique_id,
        category_name,
        category_orders,
        ROW_NUMBER() OVER (
            PARTITION BY customer_unique_id
            ORDER BY category_orders DESC
        ) AS rn
    FROM customer_category_counts
)
SELECT
    customer_unique_id,
    category_name AS top_category,
    category_orders AS top_category_orders
FROM ranked_categories
WHERE rn = 1;

-- Master customer table with segments
CREATE TABLE IF NOT EXISTS customer_master AS
WITH base AS (
    SELECT
        b.*,
        tc.top_category
    FROM customer_behavior_base b
    LEFT JOIN customer_top_category tc
        ON b.customer_unique_id = tc.customer_unique_id
),
ranked AS (
    SELECT
        base.*,
        NTILE(5) OVER (ORDER BY total_revenue DESC) AS revenue_ntile
    FROM base
)
SELECT
    customer_unique_id,
    first_order_date,
    last_order_date,
    total_orders,
    total_revenue,
    avg_order_value,
    active_days,
    days_between_first_last,
    avg_days_between_orders,
    top_category,
    CASE
        WHEN total_orders >= 10 THEN 'High Frequency (10+)'
        WHEN total_orders BETWEEN 5 AND 9 THEN 'Medium Frequency (5–9)'
        ELSE 'Low Frequency (<5)'
    END AS frequency_segment,
    CASE
        WHEN revenue_ntile = 1 THEN 'Top 20% Revenue'
        WHEN revenue_ntile = 2 THEN '20–40% Revenue'
        WHEN revenue_ntile = 3 THEN '40–60% Revenue'
        WHEN revenue_ntile = 4 THEN '60–80% Revenue'
        ELSE 'Bottom 20% Revenue'
    END AS revenue_segment
FROM ranked;

SELECT * FROM customer_master LIMIT 20;