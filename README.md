# Databricks-Retail-Data-Project

End-to-end retail data pipeline on Databricks using a **medallion architecture** (Bronze → Silver → Gold → Semantic) with a Declarative Automation Bundle (DAB) for infrastructure-as-code.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  SOURCE DATA (src/)                                         │
│  PostgreSQL · Salesforce · Azure Blob Storage                │
└──────────┬──────────────────┬──────────────────┬────────────┘
           │                  │                  │
           ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────┐
│  BRONZE LAYER (raw ingestion)                                │
│  postgres_bronze   ·   salesforce_bronze   ·   blob_bronze   │
└──────────┬──────────────────────────────────────────────────┘
           │  Spark Declarative Pipeline (retail_transform_v2)
           ▼
┌─────────────────────────────────────────────────────────────┐
│  SILVER LAYER (cleaned + transformed)                       │
│  retail_silver: transactions, opportunity, account,          │
│  inventory, product_catalog                                  │
└──────────┬──────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│  GOLD LAYER (dimensional model)                              │
│  retail_gold: fact_sales, fact_inventory,                    │
│  dim_product, dim_customer, dim_calendar                    │
└──────────┬──────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│  SEMANTIC LAYER (metric views)                               │
│  retail_semantic: retail_metrics                             │
└──────────┬──────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│  CONSUMPTION                                                 │
│  AI/BI Dashboard · Genie Space                               │
└─────────────────────────────────────────────────────────────┘
```

## Project Structure

```
Databricks-Retail-Data-project/
├── databricks.yml                        # DAB bundle config
├── README.md
├── notebooks/
│   ├── ingestion/
│   │   └── blob_to_bronze.py             # Ingests blob CSVs to bronze
│   ├── gold/
│   │   └── gold_views.py                 # Creates gold layer views
│   └── semantic/
│       ├── Metric_view.py               # Builds retail_metrics metric view
│       └── Calendar.py                  # Generates dim_calendar
├── pipelines/
│   └── retail_transform_v2/
│       ├── bronze_to_silver/
│       │   ├── transactions.py           # Bronze → Silver: transactions
│       │   ├── account.py                # Bronze → Silver: Salesforce accounts
│       │   ├── inventory.py              # Bronze → Silver: inventory
│       │   ├── opportunity.py            # Bronze → Silver: Salesforce opportunities
│       │   └── product_catalog.py        # Bronze → Silver: product catalog
│       └── silver_to_gold/
│           └── fact_sales.py             # Silver → Gold: fact_sales
├── dashboards/
│   └── retail_sales_executive.json        # AI/BI dashboard definition
├── resources/
│   ├── job.yml                            # RetailQ End to End Job
│   └── pipeline.yml                       # retail_transform_v2 pipeline
├── ddl/
│   ├── 01_catalog_schemas.sql             # Catalog, schemas, volume
│   ├── 02_bronze_tables.sql               # Bronze layer DDL
│   ├── 03_silver_tables.sql               # Silver layer DDL
│   └── 04_gold_tables.sql                 # Gold + semantic DDL
└── src/
    ├── postgres_product_history.sql       # PostgreSQL product catalog source
    ├── postgres_inventory_history.sql      # PostgreSQL inventory source
    ├── salesforce_accounts_history.csv     # Salesforce accounts source
    ├── salesforce_opportunities_history.csv # Salesforce opportunities source
    ├── blob_transactions_history.csv       # Blob transactions (full load)
    └── blob_transactions_incremental_100.csv # Blob transactions (incremental)
```

## Data Sources

| Source | Format | Target Schema | Tables |
|--------|--------|---------------|--------|
| PostgreSQL | SQL scripts | `postgres_bronze` | `product_catalog`, `inventory` |
| Salesforce | CSV | `salesforce_bronze` | `account`, `opportunity` |
| Azure Blob Storage | CSV | `blob_bronze` | `transactions` |

## Unity Catalog Structure

| Schema | Layer | Description |
|--------|-------|-------------|
| `retail_q.blob_bronze` | Bronze | Raw blob transaction data |
| `retail_q.postgres_bronze` | Bronze | Raw PostgreSQL data (streaming tables) |
| `retail_q.salesforce_bronze` | Bronze | Raw Salesforce data (streaming tables) |
| `retail_q.retail_silver` | Silver | Cleaned & transformed (streaming tables + materialized views) |
| `retail_q.retail_gold` | Gold | Star schema: facts + dimensions |
| `retail_q.retail_semantic` | Semantic | Metric view for dashboards |
| `retail_q.volumes` | Volume | UC volume for blob source files |

## Setup Instructions

### 1. Clone the repository in Databricks
In your Databricks workspace, go to **Repos** → **Add Repo** and link this GitHub repository.

### 2. Create the Unity Catalog structure
Run the DDL scripts in order:
```sql
-- In a Databricks SQL notebook or editor
%sql
-- Step 1: Catalog + schemas + volume
/ddl/01_catalog_schemas.sql

-- Step 2: Bronze tables
/ddl/02_bronze_tables.sql

-- Step 3: Silver tables
/ddl/03_silver_tables.sql

-- Step 4: Gold + semantic
/ddl/04_gold_tables.sql
```

### 3. Deploy with DAB
```bash
# Validate the bundle
databricks bundle validate --target default

# Deploy all resources (pipeline, job, dashboard, notebooks)
databricks bundle deploy --target default
```

### 4. Run the pipeline
```bash
# Run the full end-to-end job
databricks bundle run retailq_end_to_end --target default

# Or trigger just the pipeline
databricks bundle run retail_transform_v2 --target default
```

## Pipeline Details

The `retail_transform_v2` Spark Declarative Pipeline uses:
- **Serverless compute** with Photon acceleration
- **Data quality checks** (expectations) on each silver table
- **CDC/SCD2** support on product_catalog and inventory

### Bronze → Silver transformations
| File | Source | Target | DQ Checks |
|------|--------|--------|-----------|
| `transactions.py` | `blob_bronze.transactions` | `retail_silver.transactions` | Non-null IDs, valid quantities/prices |
| `account.py` | `salesforce_bronze.account` | `retail_silver.account` | Non-null ID, non-null name |
| `inventory.py` | `postgres_bronze.inventory` | `retail_silver.inventory` | Non-null IDs, positive stock |
| `opportunity.py` | `salesforce_bronze.opportunity` | `retail_silver.opportunity` | Non-null ID, valid amount/probability |
| `product_catalog.py` | `postgres_bronze.product_catalog` | `retail_silver.product_catalog` | Non-null ID, valid price, SCD2 |

### Silver → Gold transformations
| File | Target | Description |
|------|--------|-------------|
| `fact_sales.py` | `retail_gold.fact_sales` | Joins transactions + opportunities |

## Dashboard

The **Retail Sales Analysis - Executive Dashboard** provides:
- KPI counters: Total Revenue, Transaction Count, Unique Customers, Avg Transaction Value
- Charts: Revenue Trend by Month, Revenue by Category/Channel/Payment Mode/State/Brand
- Data source: `retail_q.retail_semantic.retail_metrics` metric view

## Technologies

- **Databricks** — Unified analytics platform
- **Unity Catalog** — Data governance and access control
- **Spark Declarative Pipelines (SDP)** — ETL with data quality
- **Declarative Automation Bundles (DAB)** — Infrastructure as code
- **AI/BI Dashboards** — Lakehouse-native visualization
- **Azure Blob Storage** — Source data (transactions)
- **PostgreSQL** — Source data (product catalog, inventory)
- **Salesforce** — Source data (accounts, opportunities)
