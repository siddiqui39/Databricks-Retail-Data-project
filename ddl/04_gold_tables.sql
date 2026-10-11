-- =========================================
-- GOLD LAYER TABLE DDL
-- Generated from Unity Catalog metadata
-- =========================================

-- Table: retail_q.retail_gold.dim_calendar
CREATE TABLE retail_q.retail_gold.dim_calendar (
  date DATE,
  year INT,
  quarter INT,
  month INT,
  month_name STRING COLLATE UTF8_BINARY,
  month_short_name STRING COLLATE UTF8_BINARY,
  week_of_year INT,
  day_of_month INT,
  day_of_week INT,
  day_of_week_name STRING COLLATE UTF8_BINARY,
  day_of_week_short_name STRING COLLATE UTF8_BINARY,
  day_of_year INT,
  is_weekend BOOLEAN,
  is_weekday BOOLEAN,
  year_quarter STRING COLLATE UTF8_BINARY,
  year_month STRING COLLATE UTF8_BINARY,
  last_day_of_month DATE,
  is_last_day_of_Month BOOLEAN,
  is_first_day_of_month BOOLEAN)
USING delta
COMMENT 'This table provides a detailed breakdown of calendar dates, including year, month, week, and day information. It is useful for analyzing trends over time, such as seasonality in retail sales, and for generating time-based reports. Various attributes indicate whether a date falls on a weekend or weekday, as well as specific markers for the first and last days of months, allowing for deeper temporal analysis.'
TBLPROPERTIES (
  'delta.enableDeletionVectors' = 'true',
  'delta.feature.appendOnly' = 'supported',
  'delta.feature.deletionVectors' = 'supported',
  'delta.feature.invariants' = 'supported',
  'delta.minReaderVersion' = '3',
  'delta.minWriterVersion' = '7',
  'delta.parquet.compression.codec' = 'zstd',
  'delta.parquet.format.version' = '2.12.0',
  'delta.parquet.format.version.afe.internal' = '2.12.0')


-- Table: retail_q.retail_gold.dim_customer
CREATE VIEW retail_gold.dim_customer (
  customer_id,
  customer_name,
  customer_type,
  billing_city,
  billing_state,
  billing_country,
  phone,
  website,
  industry,
  annual_revenue,
  number_of_employees,
  description)
WITH SCHEMA COMPENSATION
AS SELECT
    id AS customer_id,
    customer_name,
    type AS customer_type,
    
    billing_city,
    billing_state,
    billing_country,

    phone,
    website,

    industry,
    annual_revenue,
    number_of_employees,

    description

FROM retail_q.retail_silver.account
WHERE is_deleted = FALSE
AND is_active = TRUE


-- Table: retail_q.retail_gold.dim_product
CREATE VIEW retail_gold.dim_product (
  product_id,
  product_name,
  category,
  subcategory,
  brand,
  product_segment,
  unit_price,
  supplier_name,
  launch_date,
  updated_at)
WITH SCHEMA COMPENSATION
AS SELECT
   product_id,
   product_name,
   category,
   subcategory,
   brand,
   product_segment,
   unit_price,
   supplier_name,
   launch_date,
   updated_at

FROM retail_q.retail_silver.product_catalog
where is_active = TRUE


-- Table: retail_q.retail_gold.fact_inventory
CREATE VIEW retail_gold.fact_inventory (
  inventory_id,
  product_id,
  stock_quantity,
  reorder_level,
  inventory_status,
  warehouse_location,
  last_stock_update)
WITH SCHEMA COMPENSATION
AS SELECT
    inventory_id,
    product_id,
    
    stock_quantity,
    reorder_level,
    inventory_status,
    warehouse_location,
    last_stock_update

FROM retail_q.retail_silver.inventory


-- Table: retail_q.retail_gold.fact_sales
CREATE MATERIALIZED VIEW `retail_q`.`retail_gold`.`fact_sales` (
  transaction_id STRING COLLATE UTF8_BINARY,
  opportunity_name STRING COLLATE UTF8_BINARY,
  product_id STRING COLLATE UTF8_BINARY,
  store_id STRING COLLATE UTF8_BINARY,
  quantity INT,
  selling_price INT,
  discount_amount INT,
  transaction_timestamp TIMESTAMP,
  transaction_date DATE,
  payment_mode STRING COLLATE UTF8_BINARY,
  sales_channel STRING COLLATE UTF8_BINARY,
  name STRING COLLATE UTF8_BINARY,
  stage_name STRING COLLATE UTF8_BINARY,
  owner_id STRING COLLATE UTF8_BINARY,
  amount DECIMAL(38,22),
  customer_id STRING COLLATE UTF8_BINARY)
AS 


-- Table: retail_q.retail_semantic.retail_metrics
CREATE VIEW retail_q.retail_semantic.retail_metrics (
  Transaction Date COMMENT 'Date of transaction',
  Year COMMENT 'Year of the transaction',
  Quarter COMMENT 'Quarter of the transaction',
  Month Name COMMENT 'Month name of the transaction',
  Product Category COMMENT 'Main product category',
  Product Brand COMMENT 'Product brand name',
  Payment Mode COMMENT 'Method of payment used for transaction',
  Sales Channel COMMENT 'Channel through which sale was made',
  Stage Name COMMENT 'Sales opportunity stage',
  Customer Type COMMENT 'Type or category of customer',
  Customer Name COMMENT 'Name of the customer',
  Billing City COMMENT 'Customer billing city',
  Billing State COMMENT 'Customer billing state',
  Billing Country COMMENT 'Customer billing country',
  Industry COMMENT 'Customer industry sector',
  Transaction Count COMMENT 'Total number of transactions',
  Total Revenue COMMENT 'Sum of all transaction amounts',
  Total Quantity Sold COMMENT 'Total number of items sold',
  Total Discount COMMENT 'Sum of all discount amounts',
  Average Transaction Value COMMENT 'Average revenue per transaction',
  Unique Customers COMMENT 'Count of distinct customers')
COMMENT 'Retail metrics for analyzing sales transactions, revenue, and product performance'
WITH METRICS
LANGUAGE YAML
AS
$$
version: 1.1

source: retail_q.retail_gold.fact_sales

joins:
  - name: product
    source: retail_q.retail_gold.dim_product
    "on": source.product_id = product.product_id
  - name: calendar
    source: retail_q.retail_gold.dim_calendar
    "on": source.transaction_date = calendar.date
  - name: customer
    source: retail_q.retail_gold.dim_customer
    "on": source.customer_id = customer.customer_id

comment: "Retail metrics for analyzing sales transactions, revenue, and product performance"

dimensions:
  - name: Transaction Date
    expr: calendar.date
    comment: Date of transaction
    display_name: Transaction Date
    format:
      type: date
      date_format: year_month_day
    synonyms:
      - date
      - sale date
      - transaction day

  - name: Year
    expr: calendar.year
    comment: Year of the transaction
    display_name: Year

  - name: Quarter
    expr: calendar.quarter
    comment: Quarter of the transaction
    display_name: Quarter

  - name: Month Name
    expr: calendar.month_name
    comment: Month name of the transaction
    display_name: Month
    synonyms:
      - month

  - name: Product Category
    expr: product.category
    comment: Main product category
    display_name: Product Category
    synonyms:
      - category

  - name: Product Brand
    expr: product.brand
    comment: Product brand name
    display_name: Brand
    synonyms:
      - brand

  - name: Payment Mode
    expr: source.payment_mode
    comment: Method of payment used for transaction
    display_name: Payment Mode
    synonyms:
      - payment method
      - payment type

  - name: Sales Channel
    expr: source.sales_channel
    comment: Channel through which sale was made
    display_name: Sales Channel
    synonyms:
      - channel

  - name: Stage Name
    expr: source.stage_name
    comment: Sales opportunity stage
    display_name: Opportunity Stage

  - name: Customer Type
    expr: customer.customer_type
    comment: Type or category of customer
    display_name: Customer Type
    synonyms:
      - customer segment
      - customer category

  - name: Customer Name
    expr: customer.customer_name
    comment: Name of the customer
    display_name: Customer Name
    synonyms:
      - customer

  - name: Billing City
    expr: customer.billing_city
    comment: Customer billing city
    display_name: City
    synonyms:
      - city
      - customer city

  - name: Billing State
    expr: customer.billing_state
    comment: Customer billing state
    display_name: State
    synonyms:
      - state
      - customer state

  - name: Billing Country
    expr: customer.billing_country
    comment: Customer billing country
    display_name: Country
    synonyms:
      - country
      - customer country

  - name: Industry
    expr: customer.industry
    comment: Customer industry sector
    display_name: Industry
    synonyms:
      - customer industry
      - sector

measures:
  - name: Transaction Count
    expr: COUNT(1)
    comment: Total number of transactions
    display_name: Transaction Count
    format:
      type: number
      decimal_places:
        type: exact
        places: 0
    synonyms:
      - transactions
      - count
      - order count

  - name: Total Revenue
    expr: SUM(amount)
    comment: Sum of all transaction amounts
    display_name: Total Revenue
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 2
    synonyms:
      - revenue
      - sales
      - total sales

  - name: Total Quantity Sold
    expr: SUM(quantity)
    comment: Total number of items sold
    display_name: Total Quantity
    format:
      type: number
      decimal_places:
        type: exact
        places: 0
    synonyms:
      - quantity
      - units sold

  - name: Total Discount
    expr: SUM(discount_amount)
    comment: Sum of all discount amounts
    display_name: Total Discount
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 2
    synonyms:
      - discounts

  - name: Average Transaction Value
    expr: SUM(amount) / COUNT(1)
    comment: Average revenue per transaction
    display_name: Avg Transaction Value
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 2
    synonyms:
      - avg revenue
      - average order value

  - name: Unique Customers
    expr: COUNT(DISTINCT customer.customer_id)
    comment: Count of distinct customers
    display_name: Unique Customers
    format:
      type: number
      decimal_places:
        type: exact
        places: 0
    synonyms:
      - customer count
      - distinct customers
$$

