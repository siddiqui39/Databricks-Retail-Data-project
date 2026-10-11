-- =========================================
-- Catalog, Schemas, and Volume Setup
-- Run this first to create the Unity Catalog structure
-- =========================================

-- Catalog
CREATE CATALOG IF NOT EXISTS retail_q
  COMMENT 'RetailQ project catalog - medallion architecture (bronze/silver/gold/semantic)';

-- Schemas (Bronze layer - raw data sources)
CREATE SCHEMA IF NOT EXISTS retail_q.blob_bronze
  COMMENT 'Bronze layer - blob storage transactions';
CREATE SCHEMA IF NOT EXISTS retail_q.postgres_bronze
  COMMENT 'Bronze layer - PostgreSQL source data';
CREATE SCHEMA IF NOT EXISTS retail_q.salesforce_bronze
  COMMENT 'Bronze layer - Salesforce source data';

-- Schemas (Silver layer - cleaned/transformed)
CREATE SCHEMA IF NOT EXISTS retail_q.retail_silver
  COMMENT 'Silver layer - cleaned and transformed data';

-- Schemas (Gold layer - dimensional model)
CREATE SCHEMA IF NOT EXISTS retail_q.retail_gold
  COMMENT 'Gold layer - star schema (facts + dimensions)';

-- Schemas (Semantic layer - metric views)
CREATE SCHEMA IF NOT EXISTS retail_q.retail_semantic
  COMMENT 'Semantic layer - metric views for analytics';

-- Schemas (Volumes)
CREATE SCHEMA IF NOT EXISTS retail_q.volumes
  COMMENT 'UC volumes for blob storage';

-- Volume for blob source data
CREATE EXTERNAL VOLUME IF NOT EXISTS retail_q.volumes.blob_source
  COMMENT 'Volume for blob storage transaction source files'
  LOCATION 'abfss://retail-data@storageretailq.dfs.core.windows.net/transactions_source';
