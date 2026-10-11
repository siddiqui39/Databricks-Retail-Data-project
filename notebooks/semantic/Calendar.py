# Databricks notebook source
# MAGIC %sql
# MAGIC --Create table
# MAGIC CREATE OR REPLACE TABLE retail_q.retail_gold.calender AS
# MAGIC WITH date_range AS (
# MAGIC     SELECT explode(sequence(
# MAGIC         to_date(:start_date),
# MAGIC         to_date(:end_date),
# MAGIC         interval 1 day
# MAGIC     )) AS date
# MAGIC )
# MAGIC
# MAGIC SELECT 
# MAGIC date,
# MAGIC year(date) AS year,
# MAGIC quarter(date) AS quarter,
# MAGIC month(date) AS month,
# MAGIC date_format(date, 'MMMM') AS month_name,
# MAGIC date_format(date, 'MMM') AS month_short_name,
# MAGIC weekofyear(date) AS week_of_year,
# MAGIC dayofmonth(date) AS day_of_month,
# MAGIC dayofweek(date) AS day_of_week,
# MAGIC date_format(date, 'EEEE') AS day_of_week_name,
# MAGIC date_format(date, 'EEE') AS day_of_week_short_name,
# MAGIC dayofyear(date) AS day_of_year,
# MAGIC CASE WHEN dayofweek(date) IN (1,7) THEN TRUE 
# MAGIC ELSE FALSE END AS is_weekend,
# MAGIC CASE WHEN dayofweek(date) NOT IN (1,7) THEN TRUE 
# MAGIC ELSE FALSE END is_weekday,
# MAGIC concat(year(date), '-Q', quarter(date)) AS year_quarter,
# MAGIC date_format(date, 'yyyy-MM') AS year_month,
# MAGIC last_day(date) AS last_day_of_month,
# MAGIC date = last_day(date) AS is_last_day_of_Month,
# MAGIC date = date_trunc('month', date) AS is_first_day_of_month
# MAGIC FROM date_range
# MAGIC ORDER BY date
# MAGIC

# COMMAND ----------

# DBTITLE 1,Drop dim_calendar table
# MAGIC %sql
# MAGIC -- Drop the duplicate dim_calendar table
# MAGIC DROP TABLE IF EXISTS retail_q.retail_gold.dim_calendar;
# MAGIC
# MAGIC -- Verify remaining tables in retail_gold
# MAGIC SHOW TABLES IN retail_q.retail_gold LIKE 'cal*';