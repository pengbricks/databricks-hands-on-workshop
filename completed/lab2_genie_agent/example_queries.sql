-- Example query for the Genie Agent: selective institutions in the latest year.
SELECT institution_name, state, applicants, ROUND(admit_rate * 100, 1) AS admit_rate_pct
  FROM workspace.workshop.admissions_prepared
  WHERE year = (SELECT MAX(year) FROM workspace.workshop.admissions_prepared)
    AND admit_rate < 0.25
    AND applicants >= 5000
  ORDER BY admit_rate;
