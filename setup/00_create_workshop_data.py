# Databricks notebook source
# MAGIC %md
# MAGIC # Setup: create the schema, the volume, and the raw data
# MAGIC
# MAGIC Run all cells once, on serverless compute. Running it again resets the raw files.
# MAGIC
# MAGIC | Creates | Name |
# MAGIC |---|---|
# MAGIC | Schema | `workspace.workshop` |
# MAGIC | Volume | `workspace.workshop.raw` |
# MAGIC | Admissions files | `/Volumes/workspace/workshop/raw/admissions/adm2019.csv` to `adm2022.csv` |
# MAGIC | Institution directory | `/Volumes/workspace/workshop/raw/institutions/hd2023.csv` |
# MAGIC
# MAGIC The files are a column subset of the public NCES IPEDS data files, copied from `setup/data` in this Git folder. `workspace` is the default catalog on Free Edition. If you change the catalog widget, change `workspace` in each lab file too.

# COMMAND ----------

dbutils.widgets.text("catalog", "workspace")
dbutils.widgets.text("schema", "workshop")

CATALOG = dbutils.widgets.get("catalog")
SCHEMA = dbutils.widgets.get("schema")
VOLUMES = ["raw"]
RAW = f"/Volumes/{CATALOG}/{SCHEMA}/raw"

# COMMAND ----------

spark.sql(f"CREATE SCHEMA IF NOT EXISTS `{CATALOG}`.`{SCHEMA}`")
for volume in VOLUMES:
    spark.sql(f"CREATE VOLUME IF NOT EXISTS `{CATALOG}`.`{SCHEMA}`.`{volume}`")

# COMMAND ----------

import os
import shutil

DATA = os.path.join(os.getcwd(), "data")
FILES = [f"admissions/adm{year}.csv" for year in range(2019, 2023)] + ["institutions/hd2023.csv"]

for folder in ["admissions", "institutions"]:
    shutil.rmtree(f"{RAW}/{folder}", ignore_errors=True)
    os.makedirs(f"{RAW}/{folder}")

for name in FILES:
    shutil.copy(f"{DATA}/{name}", f"{RAW}/{name}")
    print(f"{RAW}/{name}")

# COMMAND ----------

# Check: 7,972 admissions rows and 6,163 institutions.
admissions = spark.read.csv(f"{RAW}/admissions", header=True)
institutions = spark.read.csv(f"{RAW}/institutions", header=True)
print(admissions.count(), "admissions rows,", institutions.count(), "institutions")
display(admissions.limit(5))
