# Reference guides

Twelve guides that go further than the labs, kept here so the whole workshop sits in one Git folder. Read them in the workspace alongside the labs.

**They are reference material, not Free Edition labs.** Each guide is part of a Declarative Automation Bundle. Its notebooks import shared code from the bundle's `src` folder and expect the bundle's jobs and pipelines to be deployed, so they do not run from this folder as they are. To run a guide, clone the source repository into a full Databricks workspace and deploy its bundle as that guide's README describes.

Source: [pengbricks/pengbricks-app-capabilities-walkthrough](https://github.com/pengbricks/pengbricks-app-capabilities-walkthrough), commit `8a2f1d9b13e3aca115695f5abc8626c7e19a694f` (2026-11-18). The copies are unchanged.

| Workshop block | Folder | Guide | Path in the source repository |
|---|---|---|---|
| Lab 1 | `transformation-patterns` | Transformation patterns | `reference/data-engineering/guides/transformation-patterns` |
| Lab 1 | `batch-real-time-ingestion` | Batch and streaming ingestion | `reference/ingestion/guides/batch-real-time-ingestion` |
| Lab 1 | `orchestration-patterns` | Orchestration patterns | `reference/orchestration/guides/orchestration-patterns` |
| Lab 2 | `genie-agents` | Genie Agents | `reference/genie/guides/genie-agents` |
| Lab 2 | `genie-code` | Genie Code: from sample data to notebooks and dashboards | `reference/analyst/guides/genie-code` |
| Lab 2 | `metric-views` | Metric views | `reference/metric-views/guides/metric-views` |
| Governance | `access-management` | Access management | `reference/governance/guides/access-management` |
| Governance | `row-column-security` | Row and column security | `reference/governance/guides/row-column-security` |
| Governance | `data-observability` | Lineage and drift detection | `reference/orchestration/guides/data-observability` |
| Client projects | `environment-workspaces-catalogs` | Workspaces and catalogs across dev, test, stage, and prod | `reference/environments/guides/environment-workspaces-catalogs` |
| Client projects | `compute-capacity-management` | Compute and capacity management | `reference/governance/guides/compute-capacity-management` |
| Client projects | `legacy-conversion` | Legacy workload migration | `reference/legacy-conversion/guides/legacy-conversion` |
