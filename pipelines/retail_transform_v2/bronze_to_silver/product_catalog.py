
import dlt as dp
from pyspark.sql import functions as F

@dp.table(
    name = "retail_q.retail_silver.product_catalog",
    comment = "Siver Layer: Clean product catalog with standardized data and data quality rules"
)

@dp.expect_or_drop("valid_product_id", "product_id IS NOT NULL AND LENGTH(TRIM(product_id)) >0")
@dp.expect_or_drop("valid_product_name", "product_name IS NOT NULL AND LENGTH(TRIM(product_name)) >0")
@dp.expect("valid_category", "category IS NOT NULL")
@dp.expect("valid_price", "unit_price >0")
@dp.expect_or_drop("valid_launch_date", "launch_date IS NOT NULL")
@dp.expect("valid_supplier", "supplier_name IS NOT NULL")

def product_catalog():
    return (
        spark.readStream.table("retail_q.postgres_bronze.product_catalog")
        .filter(F.col("is_active") == True)
        .select(
            # Standardize product_id: trim and uppercase
            F.col("product_id"),

            # Standardize product_name: trim and title case
            F.initcap(F.trim(F.col("product_name"))).alias("product_name"),

            # Standardize category: Trim and title case
            F.initcap(F.trim(F.col("category"))).alias("category"),

            # Standardize subcategory: Trim and title case
            F.when(F.col("subcategory").isNotNull(),
                   F.initcap(F.trim(F.col("subcategory"))))
            .otherwise(F.lit("Unknown")).alias("subcategory"),

            # Standardize brand: trim and title case, handle nulls
            F.when(F.col("brand").isNotNull(),
                   F.initcap(F.trim(F.col("brand"))))
            .otherwise(F.lit("Unknown")).alias("brand"),

            # Standardize price: round to two decimal points
            F.round(F.col("unit_price"), 2).alias("unit_price"),

            # Standardize supplier_name: trim and title case
            F.initcap(F.trim(F.col("supplier_name"))).alias("supplier_name"),

            # Keep dates and timestamps as-is
            F.col("launch_date"),

            # Product segmentation
            F.when(F.col("unit_price") > 50000, "Premium")
            .when(F.col("unit_price") > 10000, "Mid_Range")
            .otherwise("Budget")
            .alias("Product_Segment"),

            # Keep updated_at timestamp
            F.col("updated_at"),

            # Add __START_AT and __END_AT columns
            F.col("__START_AT").alias("start_at"),
            F.col("__END_AT").alias("end_at"),

            # Derive is_active based on __END_AT null status
            F.when(F.col("__END_AT").isNull(), F.lit(True)).otherwise(F.lit(False)).alias("is_active"),

            # Add processing timestamp fro audit trial
            F.current_timestamp().alias("processed_at")
        )
    )
