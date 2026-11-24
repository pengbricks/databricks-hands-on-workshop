# Lab 1: Data ingestion with a Lakeflow pipeline

**Time:** 35 minutes

You build four datasets from the IPEDS files the setup notebook copied to `/Volumes/workspace/workshop/raw/`.

| Layer | Dataset | Type | What it does |
|---|---|---|---|
| Bronze | `admissions_raw` | Streaming table | Ingests the admissions files incrementally, one file per survey year |
| Bronze | `institutions` | Materialized view | Loads the institution directory and decodes the control code |
| Silver | `admissions_prepared` | Materialized view | Joins the two, names the columns, adds admit and yield rates, and applies three expectations |
| Gold | `admissions_by_state` | Materialized view | Totals applicants, admitted, and enrolled by state and year |

## Steps

1. In the sidebar, click **New** > **ETL pipeline**. Name it `admissions_pipeline`.
2. Next to the name, set the default catalog to `workspace` and the schema to `workshop`.
3. Open the menu next to **Use sample code** and choose **Add existing source code**. Select `labs/lab1_lakeflow_pipeline/transformations/admissions_pipeline.sql` in your Git folder.
4. Read steps 1 and 2 in the file. Then write steps 3 and 4 where the `TODO` comments are.
5. Click **Run pipeline**. Watch the four datasets build in the graph.
6. Click `admissions_prepared` in the graph and read the expectation results. Some institutions reported no applicants, and some that reported in 2019 are no longer in the 2023 directory.
7. Open `explorations/explore_admissions` in this folder and run it.
8. Run `setup/02_land_more_files` to land the 2023 file, then run the pipeline again. `admissions_raw` reads the 1,972 new rows, not all 9,944.
9. In the pipeline editor, click **Schedule**. Keep the default of once a day and click **Create**.

Optional: change `has_applicants` to `EXPECT (applicants > 0) ON VIOLATION DROP ROW`, run the pipeline, and compare the row count of `admissions_prepared`.

## Done when

`workspace.workshop` holds the four tables and **Jobs & Pipelines** lists a scheduled job.

## If stuck

- **Add existing source code** is not offered: set the `my_transformation` file to **SQL** and paste the contents of `transformations/admissions_pipeline.sql` into it.
- Steps 3 and 4 do not run: paste `completed/lab1_lakeflow_pipeline/transformations/admissions_pipeline.sql` over your file.
- The pipeline does not run at all: run `completed/lab1_lakeflow_pipeline/build_tables_without_pipeline`. It builds the same four tables so you can do Labs 2 and 3.

## If you come from an ETL tool

| You are used to | In this lab |
|---|---|
| A mapping that moves and reshapes data | A dataset definition in SQL |
| A lookup that decodes a code | A `CASE` expression or a join in the dataset definition |
| A session or task that runs a mapping | A pipeline update |
| A workflow with a schedule | A Lakeflow Job with a schedule |
| Data quality rules in a separate tool | Expectations in the dataset definition |

Docs: [Build an ETL pipeline with Lakeflow pipelines](https://docs.databricks.com/aws/en/getting-started/data-pipeline-get-started)
