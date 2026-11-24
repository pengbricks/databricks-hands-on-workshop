"""Builds the workshop's raw files from the public NCES IPEDS data files.

Run it on a laptop, not in the workspace. The output is already in this folder.

    python export_ipeds_subset.py <folder with the unzipped IPEDS CSV files>

Source: https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx
  ADM2019 to ADM2023  Admissions and test scores (revised files where NCES published one)
  HD2023              Institutional characteristics, directory information
"""
import csv
import os
import sys

ADMISSIONS = ["UNITID", "APPLCN", "ADMSSN", "ENRLT", "ENRLFT", "ENRLPT", "SATNUM", "SATPCT",
              "ACTNUM", "ACTPCT", "SATVR25", "SATVR75", "SATMT25", "SATMT75", "ACTCM25", "ACTCM75"]
INSTITUTIONS = ["UNITID", "INSTNM", "CITY", "STABBR", "ZIP", "SECTOR", "ICLEVEL", "CONTROL",
                "HBCU", "LOCALE", "INSTSIZE", "LONGITUD", "LATITUDE"]


def subset(source, target, columns):
    try:
        text = open(source, encoding="utf-8-sig", newline="").read()
    except UnicodeDecodeError:
        text = open(source, encoding="latin-1", newline="").read()
    reader = csv.reader(text.splitlines())
    header = [name.strip() for name in next(reader)]
    keep = [header.index(name) for name in columns]
    rows = [[row[i].strip() for i in keep] for row in reader]
    os.makedirs(os.path.dirname(target), exist_ok=True)
    with open(target, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(columns)
        writer.writerows(rows)
    print(target, len(rows), "rows")


if __name__ == "__main__":
    source_dir = sys.argv[1]
    here = os.path.dirname(os.path.abspath(__file__))
    for year in range(2019, 2024):
        revised = f"{source_dir}/adm{year}_rv.csv"
        source = revised if os.path.exists(revised) else f"{source_dir}/adm{year}.csv"
        subset(source, f"{here}/admissions/adm{year}.csv", ADMISSIONS)
    subset(f"{source_dir}/HD2023.csv", f"{here}/institutions/hd2023.csv", INSTITUTIONS)
