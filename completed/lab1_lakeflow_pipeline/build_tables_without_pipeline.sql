-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Lab 1 catch-up: build the four tables without a pipeline
-- MAGIC
-- MAGIC Use this only if your pipeline did not run. It builds `admissions_raw`, `institutions`, `admissions_prepared`, and `admissions_by_state` as plain tables so you can do Labs 2 and 3. It fails if a pipeline already created tables with these names.

-- COMMAND ----------

USE CATALOG workspace;
USE SCHEMA workshop;

-- COMMAND ----------

CREATE OR REPLACE TABLE admissions_raw AS
SELECT
  *,
  CAST(regexp_extract(_metadata.file_name, '[0-9]{4}', 0) AS INT) AS year
FROM read_files(
  '/Volumes/workspace/workshop/raw/admissions/',
  format => "csv",
  header => "true",
  schema => """
    UNITID INT,
    APPLCN INT,
    ADMSSN INT,
    ENRLT INT,
    ENRLFT INT,
    ENRLPT INT,
    SATNUM INT,
    SATPCT INT,
    ACTNUM INT,
    ACTPCT INT,
    SATVR25 INT,
    SATVR75 INT,
    SATMT25 INT,
    SATMT75 INT,
    ACTCM25 INT,
    ACTCM75 INT
  """
);

-- COMMAND ----------

CREATE OR REPLACE TABLE institutions AS
SELECT
  UNITID AS unit_id,
  INSTNM AS institution_name,
  CITY AS city,
  STABBR AS state,
  CASE CONTROL
    WHEN 1 THEN 'Public'
    WHEN 2 THEN 'Private nonprofit'
    WHEN 3 THEN 'Private for-profit'
  END AS control
FROM read_files(
  '/Volumes/workspace/workshop/raw/institutions/',
  format => "csv",
  header => "true",
  schema => """
    UNITID INT,
    INSTNM STRING,
    CITY STRING,
    STABBR STRING,
    ZIP STRING,
    SECTOR INT,
    ICLEVEL INT,
    CONTROL INT,
    HBCU INT,
    LOCALE INT,
    INSTSIZE INT,
    LONGITUD DOUBLE,
    LATITUDE DOUBLE
  """
);

-- COMMAND ----------

CREATE OR REPLACE TABLE admissions_prepared AS
SELECT
  a.UNITID AS unit_id,
  a.year,
  i.institution_name,
  i.state,
  i.control,
  a.APPLCN AS applicants,
  a.ADMSSN AS admitted,
  a.ENRLT AS enrolled,
  try_divide(a.ADMSSN, a.APPLCN) AS admit_rate,
  try_divide(a.ENRLT, a.ADMSSN) AS yield_rate,
  a.SATVR75 AS sat_reading_75,
  a.SATMT75 AS sat_math_75
FROM admissions_raw AS a
LEFT JOIN institutions AS i ON a.UNITID = i.unit_id;

-- COMMAND ----------

CREATE OR REPLACE TABLE admissions_by_state AS
SELECT
  state,
  year,
  COUNT(*) AS institutions,
  SUM(applicants) AS applicants,
  SUM(admitted) AS admitted,
  SUM(enrolled) AS enrolled,
  try_divide(SUM(admitted), SUM(applicants)) AS admit_rate
FROM admissions_prepared
WHERE state IS NOT NULL
GROUP BY state, year;

-- COMMAND ----------

SELECT 'admissions_raw' AS dataset, COUNT(*) AS row_count FROM admissions_raw
UNION ALL SELECT 'institutions', COUNT(*) FROM institutions
UNION ALL SELECT 'admissions_prepared', COUNT(*) FROM admissions_prepared
UNION ALL SELECT 'admissions_by_state', COUNT(*) FROM admissions_by_state;
