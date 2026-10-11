-- =========================================
-- SILVER LAYER TABLE DDL
-- Generated from Unity Catalog metadata
-- =========================================

-- Table: retail_q.retail_silver.account
CREATE STREAMING TABLE `retail_q`.`retail_silver`.`account` (
  id STRING COLLATE UTF8_BINARY,
  is_deleted BOOLEAN,
  customer_name STRING COLLATE UTF8_BINARY,
  type STRING COLLATE UTF8_BINARY,
  parent_id STRING COLLATE UTF8_BINARY,
  billing_street STRING COLLATE UTF8_BINARY,
  billing_city STRING COLLATE UTF8_BINARY,
  billing_state STRING COLLATE UTF8_BINARY,
  billing_postal_code STRING COLLATE UTF8_BINARY,
  billing_country STRING COLLATE UTF8_BINARY,
  shipping_street STRING COLLATE UTF8_BINARY,
  shipping_city STRING COLLATE UTF8_BINARY,
  shipping_state STRING COLLATE UTF8_BINARY,
  shipping_postal_code STRING COLLATE UTF8_BINARY,
  shipping_country STRING COLLATE UTF8_BINARY,
  phone STRING COLLATE UTF8_BINARY,
  website STRING COLLATE UTF8_BINARY,
  industry STRING COLLATE UTF8_BINARY,
  annual_revenue DECIMAL(38,20),
  number_of_employees INT,
  description STRING COLLATE UTF8_BINARY,
  is_active BOOLEAN)
COMMENT 'Salesforce account data with core business columns and data quality checks'
AS 


-- Table: retail_q.retail_silver.inventory
CREATE STREAMING TABLE `retail_q`.`retail_silver`.`inventory` (
  inventory_id VARCHAR(20) COLLATE UTF8_BINARY,
  product_id VARCHAR(20) COLLATE UTF8_BINARY,
  store_id VARCHAR(20) COLLATE UTF8_BINARY,
  stock_quantity INT,
  reorder_level INT,
  inventory_status STRING COLLATE UTF8_BINARY,
  warehouse_location VARCHAR(100) COLLATE UTF8_BINARY,
  last_stock_update TIMESTAMP)
COMMENT 'Inventory data with profiled columns and data quality checks'
AS 


-- Table: retail_q.retail_silver.opportunity
CREATE STREAMING TABLE `retail_q`.`retail_silver`.`opportunity` (
  id STRING COLLATE UTF8_BINARY,
  is_deleted BOOLEAN,
  account_id STRING COLLATE UTF8_BINARY,
  name STRING COLLATE UTF8_BINARY,
  description STRING COLLATE UTF8_BINARY,
  stage_name STRING COLLATE UTF8_BINARY,
  amount DECIMAL(38,22),
  deal_size STRING COLLATE UTF8_BINARY,
  probability DOUBLE,
  close_date DATE,
  type STRING COLLATE UTF8_BINARY,
  next_step STRING COLLATE UTF8_BINARY,
  lead_source STRING COLLATE UTF8_BINARY,
  is_closed BOOLEAN,
  is_won BOOLEAN,
  forecast_category STRING COLLATE UTF8_BINARY,
  owner_id STRING COLLATE UTF8_BINARY,
  created_date TIMESTAMP,
  last_modified_date TIMESTAMP)
COMMENT 'Salesforce opportunity data with core sales fields and data quality checks'
AS 


-- Table: retail_q.retail_silver.product_catalog
CREATE STREAMING TABLE `retail_q`.`retail_silver`.`product_catalog` (
  product_id VARCHAR(20) COLLATE UTF8_BINARY,
  product_name STRING COLLATE UTF8_BINARY,
  category STRING COLLATE UTF8_BINARY,
  subcategory STRING COLLATE UTF8_BINARY,
  brand STRING COLLATE UTF8_BINARY,
  unit_price DECIMAL(11,2),
  supplier_name STRING COLLATE UTF8_BINARY,
  launch_date DATE,
  Product_Segment STRING COLLATE UTF8_BINARY,
  updated_at TIMESTAMP,
  start_at TIMESTAMP,
  end_at TIMESTAMP,
  is_active BOOLEAN,
  processed_at TIMESTAMP)
COMMENT 'Siver Layer: Clean product catalog with standardized data and data quality rules'
AS 


-- Table: retail_q.retail_silver.transactions
CREATE MATERIALIZED VIEW `retail_q`.`retail_silver`.`transactions` (
  transaction_id STRING COLLATE UTF8_BINARY,
  opportunity_name STRING COLLATE UTF8_BINARY,
  product_id STRING COLLATE UTF8_BINARY,
  store_id STRING COLLATE UTF8_BINARY,
  quantity INT,
  selling_price INT,
  gross_amount INT,
  discount_amount INT,
  transaction_timestamp TIMESTAMP,
  payment_mode STRING COLLATE UTF8_BINARY,
  sales_channel STRING COLLATE UTF8_BINARY)
COMMENT 'Transaction data with profiled columns and data quality checks'
AS 

