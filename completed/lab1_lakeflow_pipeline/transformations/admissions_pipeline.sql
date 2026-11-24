-- Lab 1 pipeline source, completed. Runs inside a Lakeflow pipeline, not as a notebook.

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

-- 3. Join the two, name the columns, add the rates, and check data quality.
CREATE OR REFRESH MATERIALIZED VIEW admissions_prepared (
  CONSTRAINT has_applicants EXPECT (applicants > 0),
  CONSTRAINT reported_enrollment EXPECT (enrolled IS NOT NULL),
  CONSTRAINT known_institution EXPECT (institution_name IS NOT NULL)
)
COMMENT "Admissions by institution and year, with names, state, and rates"
AS SELECT
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

-- 4. Total by state and year.
CREATE OR REFRESH MATERIALIZED VIEW admissions_by_state
COMMENT "Applicants, admitted, and enrolled by state and year"
AS SELECT
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
