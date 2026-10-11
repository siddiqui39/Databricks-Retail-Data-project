-- =========================================
-- BRONZE LAYER TABLE DDL
-- Generated from Unity Catalog metadata
-- =========================================

-- Table: retail_q.blob_bronze.transactions
CREATE TABLE retail_q.blob_bronze.transactions (
  transaction_id STRING COLLATE UTF8_BINARY,
  opportunity_name STRING COLLATE UTF8_BINARY,
  product_id STRING COLLATE UTF8_BINARY,
  store_id STRING COLLATE UTF8_BINARY,
  quantity STRING COLLATE UTF8_BINARY,
  selling_price STRING COLLATE UTF8_BINARY,
  discount_amount STRING COLLATE UTF8_BINARY,
  transaction_timestamp STRING COLLATE UTF8_BINARY,
  payment_mode STRING COLLATE UTF8_BINARY,
  sales_channel STRING COLLATE UTF8_BINARY,
  _rescued_data STRING COLLATE UTF8_BINARY)
USING delta
TBLPROPERTIES (
  'delta.enableDeletionVectors' = 'true',
  'delta.enableRowTracking' = 'true',
  'delta.feature.appendOnly' = 'supported',
  'delta.feature.deletionVectors' = 'supported',
  'delta.feature.domainMetadata' = 'supported',
  'delta.feature.invariants' = 'supported',
  'delta.feature.rowTracking' = 'supported',
  'delta.minReaderVersion' = '3',
  'delta.minWriterVersion' = '7',
  'delta.parquet.compression.codec' = 'zstd',
  'delta.parquet.format.version' = '2.12.0',
  'delta.parquet.format.version.afe.internal' = '2.12.0')


-- Table: retail_q.postgres_bronze.inventory
CREATE STREAMING TABLE `retail_q`.`postgres_bronze`.`inventory` (
  inventory_id VARCHAR(20) COLLATE UTF8_BINARY,
  product_id VARCHAR(20) COLLATE UTF8_BINARY,
  store_id VARCHAR(20) COLLATE UTF8_BINARY,
  stock_quantity INT,
  reorder_level INT,
  warehouse_location VARCHAR(100) COLLATE UTF8_BINARY,
  last_stock_update TIMESTAMP)
TBLPROPERTIES (
  '__ingestion_connector_cursor_columns' = '["last_stock_update"]',
  '__ingestion_connector_primary_key' = '["inventory_id"]',
  'delta.columnMapping.mode' = 'name')
AS 


-- Table: retail_q.postgres_bronze.product_catalog
CREATE STREAMING TABLE `retail_q`.`postgres_bronze`.`product_catalog` (
  product_id VARCHAR(20) COLLATE UTF8_BINARY,
  product_name VARCHAR(200) COLLATE UTF8_BINARY,
  category VARCHAR(100) COLLATE UTF8_BINARY,
  subcategory VARCHAR(100) COLLATE UTF8_BINARY,
  brand VARCHAR(100) COLLATE UTF8_BINARY,
  unit_price DECIMAL(10,2),
  supplier_name VARCHAR(200) COLLATE UTF8_BINARY,
  launch_date DATE,
  is_active BOOLEAN,
  updated_at TIMESTAMP,
  __START_AT TIMESTAMP,
  __END_AT TIMESTAMP)
TBLPROPERTIES (
  '__ingestion_connector_cursor_columns' = '["updated_at"]',
  '__ingestion_connector_primary_key' = '["product_id"]',
  'delta.columnMapping.mode' = 'name')
AS 


-- Table: retail_q.salesforce_bronze.account
CREATE STREAMING TABLE `retail_q`.`salesforce_bronze`.`account` (
  Id STRING COLLATE UTF8_BINARY,
  IsDeleted BOOLEAN,
  MasterRecordId STRING COLLATE UTF8_BINARY,
  Name STRING COLLATE UTF8_BINARY,
  Type STRING COLLATE UTF8_BINARY,
  ParentId STRING COLLATE UTF8_BINARY,
  BillingStreet STRING COLLATE UTF8_BINARY,
  BillingCity STRING COLLATE UTF8_BINARY,
  BillingState STRING COLLATE UTF8_BINARY,
  BillingPostalCode STRING COLLATE UTF8_BINARY,
  BillingCountry STRING COLLATE UTF8_BINARY,
  BillingStateCode STRING COLLATE UTF8_BINARY,
  BillingCountryCode STRING COLLATE UTF8_BINARY,
  BillingLatitude DOUBLE,
  BillingLongitude DOUBLE,
  BillingGeocodeAccuracy STRING COLLATE UTF8_BINARY,
  ShippingStreet STRING COLLATE UTF8_BINARY,
  ShippingCity STRING COLLATE UTF8_BINARY,
  ShippingState STRING COLLATE UTF8_BINARY,
  ShippingPostalCode STRING COLLATE UTF8_BINARY,
  ShippingCountry STRING COLLATE UTF8_BINARY,
  ShippingStateCode STRING COLLATE UTF8_BINARY,
  ShippingCountryCode STRING COLLATE UTF8_BINARY,
  ShippingLatitude DOUBLE,
  ShippingLongitude DOUBLE,
  ShippingGeocodeAccuracy STRING COLLATE UTF8_BINARY,
  Phone STRING COLLATE UTF8_BINARY,
  Fax STRING COLLATE UTF8_BINARY,
  Website STRING COLLATE UTF8_BINARY,
  PhotoUrl STRING COLLATE UTF8_BINARY,
  Industry STRING COLLATE UTF8_BINARY,
  AnnualRevenue DECIMAL(38,20),
  NumberOfEmployees INT,
  Description STRING COLLATE UTF8_BINARY,
  OwnerId STRING COLLATE UTF8_BINARY,
  CreatedDate TIMESTAMP,
  CreatedById STRING COLLATE UTF8_BINARY,
  LastModifiedDate TIMESTAMP,
  LastModifiedById STRING COLLATE UTF8_BINARY,
  SystemModstamp TIMESTAMP,
  LastActivityDate DATE,
  LastViewedDate TIMESTAMP,
  LastReferencedDate TIMESTAMP,
  IsCustomerPortal BOOLEAN,
  Jigsaw STRING COLLATE UTF8_BINARY,
  JigsawCompanyId STRING COLLATE UTF8_BINARY,
  AccountSource STRING COLLATE UTF8_BINARY,
  SicDesc STRING COLLATE UTF8_BINARY,
  IsBuyer BOOLEAN,
  __START_AT TIMESTAMP,
  __END_AT TIMESTAMP)
COMMENT 'The table contains comprehensive information about accounts, typically used in sales and customer relationship management contexts. It includes key attributes such as account names, types, and billing and shipping addresses, which can facilitate regional analyses or account segmentation. Use cases may involve tracking account status, analyzing revenue data, assessing customer demographics, and understanding account ownership details.'
TBLPROPERTIES (
  '__ingestion_connector_primary_key' = '["Id"]',
  '__ingestion_connector_sequence_key' = '["SystemModstamp"]')
AS 


-- Table: retail_q.salesforce_bronze.opportunity
CREATE STREAMING TABLE `retail_q`.`salesforce_bronze`.`opportunity` (
  Id STRING COLLATE UTF8_BINARY,
  IsDeleted BOOLEAN,
  AccountId STRING COLLATE UTF8_BINARY,
  Name STRING COLLATE UTF8_BINARY,
  Description STRING COLLATE UTF8_BINARY,
  StageName STRING COLLATE UTF8_BINARY,
  Amount DECIMAL(38,22),
  Probability DOUBLE,
  CloseDate DATE,
  Type STRING COLLATE UTF8_BINARY,
  NextStep STRING COLLATE UTF8_BINARY,
  LeadSource STRING COLLATE UTF8_BINARY,
  IsClosed BOOLEAN,
  IsWon BOOLEAN,
  ForecastCategory STRING COLLATE UTF8_BINARY,
  ForecastCategoryName STRING COLLATE UTF8_BINARY,
  HasOpportunityLineItem BOOLEAN,
  Pricebook2Id STRING COLLATE UTF8_BINARY,
  OwnerId STRING COLLATE UTF8_BINARY,
  CreatedDate TIMESTAMP,
  CreatedById STRING COLLATE UTF8_BINARY,
  LastModifiedDate TIMESTAMP,
  LastModifiedById STRING COLLATE UTF8_BINARY,
  SystemModstamp TIMESTAMP,
  LastActivityDate DATE,
  PushCount INT,
  LastStageChangeDate TIMESTAMP,
  FiscalQuarter INT,
  FiscalYear INT,
  Fiscal STRING COLLATE UTF8_BINARY,
  ContactId STRING COLLATE UTF8_BINARY,
  LastViewedDate TIMESTAMP,
  LastReferencedDate TIMESTAMP,
  HasOpenActivity BOOLEAN,
  HasOverdueTask BOOLEAN,
  LastAmountChangedHistoryId STRING COLLATE UTF8_BINARY,
  LastCloseDateChangedHistoryId STRING COLLATE UTF8_BINARY)
COMMENT 'The table contains data about sales opportunities, including their status, projected amounts, stages in the sales process, and dates relating to their progress. It can be used to track potential sales, analyze forecasts, and assess the likelihood of closing deals. Relevant metrics include opportunity amount, probability of success, and associated accounts.'
TBLPROPERTIES (
  '__ingestion_connector_primary_key' = '["Id"]',
  '__ingestion_connector_sequence_key' = '["SystemModstamp"]')
AS 

