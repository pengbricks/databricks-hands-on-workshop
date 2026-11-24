# U.S. college admissions on Databricks: a hands-on workshop

Three labs on [Databricks Free Edition](https://docs.databricks.com/aws/en/getting-started/free-edition), all on public admissions data from the NCES Integrated Postsecondary Education Data System (IPEDS): applicants, admitted, and enrolled students for about 2,000 institutions a year, 2019 to 2023.

1. **Data ingestion.** A Lakeflow pipeline ingests the yearly admissions files from a Unity Catalog volume, joins them to the institution directory, applies data quality expectations, and runs on a schedule.
2. **Genie.** A Genie Agent answers questions in plain language on the tables the pipeline built, such as which institutions are the most selective.
3. **Databricks App serving.** An app on Lakebase Postgres saves notes about institutions, calls a served model, and exposes an API. You also fork the database with a Lakebase branch.

A governance block follows the labs: the owner, grants, and lineage of the tables in Unity Catalog.

## Before you come

1. Create a Free Edition account with a personal email at the [signup page](https://login.databricks.com/?dbx_source=docs&intent=CE_SIGN_UP) and check that you can sign in.
2. Have a personal GitHub account you can sign in to on your laptop.
3. Bring a laptop that can reach your workspace and github.com.
4. Optional, for the API step in Lab 3: install the [Databricks CLI](https://docs.databricks.com/aws/en/dev-tools/cli/install).

Free Edition accounts are for non-commercial use. Do not use yours for client work.

## Start here

In your workspace, go to **Workspace** > **Create** > **Git folder** and paste:

```
https://github.com/pengbricks/databricks-hands-on-workshop.git
```

Then run `setup/00_create_workshop_data`. It creates the schema `workspace.workshop` and the volume `raw`, and copies the raw IPEDS files every lab reads into the volume.

## Agenda

| Block | Material |
|---|---|
| Welcome | |
| Set up Free Edition | [setup](setup/README.md), steps 1 and 2 |
| GitHub, Git folder, and raw data | [setup](setup/README.md), steps 3 to 6 |
| Lab 1: Data ingestion | [labs/lab1_lakeflow_pipeline](labs/lab1_lakeflow_pipeline/README.md) |
| Break | |
| Lab 2: Genie | [labs/lab2_genie_agent](labs/lab2_genie_agent/README.md) |
| Lab 3: Databricks App serving | [labs/lab3_app_lakebase](labs/lab3_app_lakebase/README.md) |
| Governance with Unity Catalog | [labs/governance](labs/governance/walk_the_governance.sql) |
| Questions and next steps | |

## Layout

```
setup/
  00_create_workshop_data.py   Creates the schema and the volume and copies the raw data. Run this first.
  01_first_queries.sql         First queries on the raw files
  02_land_more_files.py        Lands the 2023 admissions file (Lab 1, step 8)
  data/                        The raw IPEDS files and a description of their columns
labs/
  lab1_lakeflow_pipeline/      Pipeline source with two TODOs, and an exploration notebook
  lab2_genie_agent/            Starter questions
  lab3_app_lakebase/           App source with two TODOs
  governance/                  Owner, grants, and lineage of the Lab 1 tables
completed/                     Finished code for each lab. Use it to catch up.
reference-guides/              Twelve guides that go further. They need a full workspace, so read them here.
```

## Data

The raw files are a column subset of the public [NCES IPEDS data files](https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx): the admissions survey for 2019 to 2023 and the 2023 institution directory. [setup/data](setup/data/README.md) lists the columns.

## Free Edition limits that matter today

From the [limitations page](https://docs.databricks.com/aws/en/getting-started/free-edition-limitations):

- A daily usage quota with no published number. Past it, compute is off for the rest of the day.
- One active pipeline per pipeline type, and one SQL warehouse.
- Three apps per account. An app stops 24 hours after its last start or deploy.
- One Lakebase project per account.

## Status

If a step does not match what you see, the linked documentation page is the authority.
