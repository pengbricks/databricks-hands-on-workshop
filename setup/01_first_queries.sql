-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Setup: first queries
-- MAGIC
-- MAGIC Run `00_create_workshop_data` first. Then attach this notebook to serverless compute and run all cells.

-- COMMAND ----------

-- Who am I, and where do new objects land by default?
SELECT current_user() AS me, current_catalog() AS default_catalog, current_schema() AS default_schema;

-- COMMAND ----------

-- The schema and volume the setup notebook created
SHOW VOLUMES IN workspace.workshop;

-- COMMAND ----------

-- The raw admissions files in the volume, one per survey year
LIST '/Volumes/workspace/workshop/raw/admissions/';

-- COMMAND ----------

-- The raw admissions data. Column names are the IPEDS variable names. Lab 1 gives them readable names.
SELECT * FROM read_files(
  '/Volumes/workspace/workshop/raw/admissions/',
  format => 'csv',
  header => 'true'
) LIMIT 10;

-- COMMAND ----------

-- The institution directory
SELECT UNITID, INSTNM, CITY, STABBR, CONTROL FROM read_files(
  '/Volumes/workspace/workshop/raw/institutions/',
  format => 'csv',
  header => 'true'
) LIMIT 10;
