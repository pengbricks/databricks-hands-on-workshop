-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Governance: owner, grants, and lineage of your tables
-- MAGIC
-- MAGIC **Time:** 10 minutes
-- MAGIC
-- MAGIC ## In Catalog Explorer
-- MAGIC
-- MAGIC 1. In **Catalog**, open `workspace` > `workshop` and click `admissions_prepared`.
-- MAGIC 2. Open the **Permissions** tab. Read the owner and the grants.
-- MAGIC 3. Open the **Lineage** tab, then **See Lineage Graph**. Follow the table back to `admissions_raw` and `institutions`, and forward to `admissions_by_state`.
-- MAGIC
-- MAGIC ## In SQL
-- MAGIC
-- MAGIC Run the cells below.

-- COMMAND ----------

USE CATALOG workspace;
USE SCHEMA workshop;

-- COMMAND ----------

-- Who owns the table? Find the Owner row.
DESCRIBE TABLE EXTENDED admissions_prepared;

-- COMMAND ----------

-- Who has been granted what on the table?
SHOW GRANTS ON TABLE admissions_prepared;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Optional: grant and revoke
-- MAGIC
-- MAGIC Run this only if your account has another user or group.
-- MAGIC
-- MAGIC ```sql
-- MAGIC GRANT SELECT ON TABLE admissions_prepared TO `<group or user>`;
-- MAGIC SHOW GRANTS ON TABLE admissions_prepared;
-- MAGIC REVOKE SELECT ON TABLE admissions_prepared FROM `<group or user>`;
-- MAGIC ```
-- MAGIC
-- MAGIC ## Done when
-- MAGIC
-- MAGIC You can name the owner of `admissions_prepared`, who can read it, and the pipeline that built it.
-- MAGIC
-- MAGIC ## If stuck
-- MAGIC
-- MAGIC If a tab is empty on your account, follow along on the presenter's screen.
