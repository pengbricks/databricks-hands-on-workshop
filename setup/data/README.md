# Raw data

A column subset of the public [NCES IPEDS data files](https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx). The rows are unchanged.

| File | IPEDS source | Rows | Content |
|---|---|---|---|
| `admissions/adm2019.csv` to `adm2023.csv` | ADM2019 to ADM2023 | about 2,000 each | One row per institution: applicants, admitted, enrolled, SAT and ACT scores |
| `institutions/hd2023.csv` | HD2023 | 6,163 | Institution directory: name, city, state, control, sector |

The 2019 to 2022 admissions files are the revised files NCES published. Blank cells mean the institution did not report the value.

| Column | Meaning |
|---|---|
| `UNITID` | IPEDS institution ID |
| `APPLCN`, `ADMSSN`, `ENRLT` | Applicants, admitted, enrolled (first-time, degree-seeking undergraduates) |
| `ENRLFT`, `ENRLPT` | Enrolled full time, part time |
| `SATNUM`, `SATPCT`, `ACTNUM`, `ACTPCT` | Number and percent of enrolled students who submitted SAT or ACT scores |
| `SATVR25`, `SATVR75`, `SATMT25`, `SATMT75` | SAT reading and math, 25th and 75th percentile |
| `ACTCM25`, `ACTCM75` | ACT composite, 25th and 75th percentile |
| `INSTNM`, `CITY`, `STABBR`, `ZIP` | Institution name and location |
| `CONTROL` | 1 public, 2 private nonprofit, 3 private for-profit |
| `SECTOR`, `ICLEVEL`, `HBCU`, `LOCALE`, `INSTSIZE` | IPEDS codes; see the HD2023 dictionary on the NCES site |

`export_ipeds_subset.py` rebuilds these files from the NCES downloads.
