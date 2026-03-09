# Customer Cohort Retention & Behavioral Analytics (SQL Project)

This project analyzes customer purchasing behavior and retention patterns using the Brazilian E-Commerce Public Dataset (Olist).  
The goal is to build an analytics pipeline in MySQL to understand customer lifetime value, retention trends, and purchasing segments.

---

## Project Objective

The project answers key business questions:

• How does customer retention evolve over time?  
• What behavioral patterns indicate high-value customers?  
• Which product categories drive the most revenue?  
• What percentage of customers return after their first purchase?

---

## Dataset

Brazilian E-Commerce Public Dataset by Olist.

The dataset contains real e-commerce transactions including:

- 100K+ orders
- 90K+ customers
- product catalog
- payments
- reviews
- sellers
- geolocation data

Main tables used:

- olist_customers
- olist_orders
- olist_order_items
- olist_order_payments
- olist_products
- olist_sellers
- olist_geolocation
- olist_order_reviews
- product_category_name_translation

---

## SQL Project Architecture

The project follows a layered analytics pipeline:

### 1️⃣ Schema Layer
Create relational database structure and tables.

File: schema_setup.sql


---

### 2️⃣ Data Loading Layer
Load cleaned CSV datasets into MySQL using bulk ingestion.

File: data_loading.sql


---

### 3️⃣ Data Cleaning & Enrichment

Create analytical views to prepare clean order-level data.

Key Views:

- `order_revenue`
- `orders_enriched`

File: data_cleaning_views.sql


---

### 4️⃣ Behavioral Analytics Layer

Build customer-level behavioral metrics including:

- first purchase date
- total orders
- total revenue
- average order value
- purchase frequency
- average days between purchases
- top product category

Output table: customer_master

File: behavioral_layer.sql


---

### 5️⃣ Cohort Retention Analysis

Customers are grouped into cohorts based on their first purchase month.

Metrics calculated:

- cohort size
- active users per month
- user retention rate
- revenue retention rate

Output view: cohort_retention

File: cohort_retention.sql


---


---

## Key SQL Concepts Used

This project demonstrates several advanced SQL techniques:

- Common Table Expressions (CTEs)
- Window Functions
- LAG()
- NTILE()
- Cohort Analysis
- Behavioral Segmentation
- Revenue Aggregation
- Multi-table Joins
- Date Functions

---

## Example Cohort Retention Query

```sql
SELECT
cohort_month,
months_since_cohort,
active_users,
cohort_users,
active_users / cohort_users AS user_retention_rate
FROM cohort_retention
ORDER BY cohort_month, months_since_cohort;
```

## Project Outputs
Final analytical datasets:
- customer_master – customer behavioral metrics and segmentation
- cohort_retention – cohort retention and revenue retention analysis
These outputs can be used for dashboards or business reporting.

## Business Insights Generated
The project enables analysis of:
- Customer retention patterns over time
- Revenue contribution by customer segments
- Repeat purchase behavior
- Product category revenue distribution

## Tools Used
- MySQL
- SQL Window Functions
- Git / GitHub

## Author
- **Sankar Prudhvi Krishna Simhadri**

- **Master’s in Data Analytics**

- **University of North Texas**
