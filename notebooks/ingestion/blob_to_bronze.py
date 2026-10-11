# Databricks notebook source
# DBTITLE 1,Notebook Title
# MAGIC %md
# MAGIC # Blob to Bronze Pipeline
# MAGIC
# MAGIC Ingests CSV transaction files from blob storage using Auto Loader and writes to the bronze layer table.

# COMMAND ----------

# DBTITLE 1,Auto Loader: Read CSV and Write to Bronze
# Source and target configuration
source_path = "/Volumes/retail_q/volumes/blob_source/transactions_source/"
target_table = "retail_q.blob_bronze.transactions"

# Read CSV files using Auto Loader
df = (spark.readStream
  .format("cloudFiles")
  .option("cloudFiles.format", "csv")
  .option("header", "true")
  .option("inferSchema", "true")
  .option("cloudFiles.schemaLocation", "/Volumes/retail_q/volumes/blob_source/_schema/transactions")
  .load(source_path)
)

# Write to bronze table
(df.writeStream
  .format("delta")
  .option("checkpointLocation", "/Volumes/retail_q/volumes/blob_source/_checkpoint/transactions")
  .option("mergeSchema", "true")
  .trigger(availableNow=True)
  .toTable(target_table)
)

# COMMAND ----------

# MAGIC %sql
# MAGIC select count(*) from retail_q.blob_bronze.transactions