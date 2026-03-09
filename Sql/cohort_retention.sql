USE olist_db;

-- Assign cohort month and compute months_since_cohort per order
CREATE OR REPLACE VIEW customer_cohort_base AS
WITH first_order AS (
    SELECT
        customer_unique_id,
        MIN(order_date) AS first_order_date,
        DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS cohort_month
    FROM orders_enriched
    GROUP BY customer_unique_id
)
SELECT
    oe.customer_unique_id,
    fo.cohort_month,
    oe.order_id,
    oe.order_date,
    DATE_FORMAT(oe.order_date, '%Y-%m-01') AS order_month,
    TIMESTAMPDIFF(
        MONTH,
        fo.cohort_month,
        DATE_FORMAT(oe.order_date, '%Y-%m-01')
    ) AS months_since_cohort,
    oe.order_revenue
FROM orders_enriched oe
JOIN first_order fo
    ON oe.customer_unique_id = fo.customer_unique_id;

-- Cohort retention (users + revenue)
CREATE OR REPLACE VIEW cohort_retention AS
WITH cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) AS cohort_users
    FROM customer_cohort_base
    WHERE months_since_cohort = 0
    GROUP BY cohort_month
),
activity AS (
    SELECT
        cohort_month,
        months_since_cohort,
        COUNT(DISTINCT customer_unique_id) AS active_users,
        SUM(order_revenue) AS active_revenue
    FROM customer_cohort_base
    GROUP BY cohort_month, months_since_cohort
)
SELECT
    a.cohort_month,
    a.months_since_cohort,
    s.cohort_users,
    a.active_users,
    a.active_revenue,
    a.active_users / s.cohort_users       AS user_retention_rate,
    a.active_revenue / NULLIF(
        SUM(CASE WHEN a.months_since_cohort = 0 THEN a.active_revenue END)
            OVER (PARTITION BY a.cohort_month),
        0
    ) AS revenue_retention_rate
FROM activity a
JOIN cohort_sizes s
    ON a.cohort_month = s.cohort_month;
    
SELECT * FROM cohort_retention ORDER BY cohort_month, months_since_cohort LIMIT 50;