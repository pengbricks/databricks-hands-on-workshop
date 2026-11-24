# Databricks notebook source
# MAGIC %md
# MAGIC # Land the next survey year
# MAGIC
# MAGIC Lab 1, step 8. Copies the 2023 admissions file into the volume. Run the pipeline again afterward and `admissions_raw` reads only the new file.

# COMMAND ----------

dbutils.widgets.text("catalog", "workspace")
dbutils.widgets.text("schema", "workshop")

RAW = f"/Volumes/{dbutils.widgets.get('catalog')}/{dbutils.widgets.get('schema')}/raw"

# COMMAND ----------

import os
import shutil

shutil.copy(os.path.join(os.getcwd(), "data/admissions/adm2023.csv"), f"{RAW}/admissions/adm2023.csv")
print(sorted(os.listdir(f"{RAW}/admissions")))
