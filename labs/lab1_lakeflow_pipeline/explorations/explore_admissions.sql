-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Lab 1: explore what the pipeline built

-- COMMAND ----------

USE CATALOG workspace;
USE SCHEMA workshop;

-- COMMAND ----------

-- How many rows does each dataset hold?
SELECT 'admissions_raw' AS dataset, COUNT(*) AS row_count FROM admissions_raw
UNION ALL SELECT 'institutions', COUNT(*) FROM institutions
UNION ALL SELECT 'admissions_prepared', COUNT(*) FROM admissions_prepared
UNION ALL SELECT 'admissions_by_state', COUNT(*) FROM admissions_by_state;

-- COMMAND ----------

-- Rows per survey year
SELECT year, COUNT(*) AS institutions, SUM(applicants) AS applicants
  FROM admissions_prepared
  GROUP BY year
  ORDER BY year;

-- COMMAND ----------

-- The 20 lowest admit rates in the latest year, among institutions with 5,000 or more applicants
SELECT institution_name, state, applicants, ROUND(admit_rate * 100, 1) AS admit_rate_pct
  FROM admissions_prepared
  WHERE year = (SELECT MAX(year) FROM admissions_prepared) AND applicants >= 5000
  ORDER BY admit_rate
  LIMIT 20;

-- COMMAND ----------

-- Applications by state in the latest year
SELECT state, institutions, applicants, ROUND(admit_rate * 100, 1) AS admit_rate_pct
  FROM admissions_by_state
  WHERE year = (SELECT MAX(year) FROM admissions_by_state)
  ORDER BY applicants DESC
  LIMIT 20;
