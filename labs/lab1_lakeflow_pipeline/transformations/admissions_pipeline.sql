-- Lab 1 pipeline source. Runs inside a Lakeflow pipeline, not as a notebook.
-- Steps 1 and 2 are written for you. Write steps 3 and 4.
-- Answers: completed/lab1_lakeflow_pipeline/transformations/admissions_pipeline.sql

-- 1. Ingest the admissions files incrementally. One file per survey year; the year comes from the file name.
CREATE OR REFRESH STREAMING TABLE admissions_raw
COMMENT "IPEDS admissions survey, one row per institution per year"
AS SELECT
  *,
  CAST(regexp_extract(_metadata.file_name, '[0-9]{4}', 0) AS INT) AS year
FROM STREAM read_files(
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
  """,
  schemaEvolutionMode => "none"
);

-- 2. Load the institution directory and decode the control code.
CREATE OR REFRESH MATERIALIZED VIEW institutions
COMMENT "IPEDS institution directory, 2023"
AS SELECT
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

-- 3. TODO: create the materialized view admissions_prepared.
--    Left join admissions_raw to institutions on UNITID = unit_id.
--    Columns:
--      unit_id (UNITID), year, institution_name, state, control,
--      applicants (APPLCN), admitted (ADMSSN), enrolled (ENRLT),
--      admit_rate  = try_divide(ADMSSN, APPLCN)
--      yield_rate  = try_divide(ENRLT, ADMSSN)
--      sat_reading_75 (SATVR75), sat_math_75 (SATMT75)
--    Expectations:
--      has_applicants       applicants > 0
--      reported_enrollment  enrolled IS NOT NULL
--      known_institution    institution_name IS NOT NULL
--
-- CREATE OR REFRESH MATERIALIZED VIEW admissions_prepared (
--   CONSTRAINT <name> EXPECT (<rule>),
--   ...
-- )
-- AS SELECT ... FROM admissions_raw AS a LEFT JOIN institutions AS i ON ...;


-- 4. TODO: create the materialized view admissions_by_state from admissions_prepared.
--    One row per state and year.
--    Columns: state, year, institutions (a count), applicants, admitted, enrolled (sums),
--             admit_rate = try_divide(SUM(admitted), SUM(applicants))
--    Leave out rows where state is NULL.
