# Lab 3: Databricks App serving: an app on Lakebase that calls a served model

**Time:** 40 minutes

The app in `app/` saves notes about institutions to a Lakebase Postgres table and asks a served model to summarize them. It has a web page and an API under `/api`.

| File | What it does |
|---|---|
| `app/app.py` | FastAPI app with three routes: `GET /api/notes`, `POST /api/notes`, `POST /api/summary`. Two functions are left for you: `save_note()` and `summarize()` |
| `app/index.html` | The page, with a **Notes** tab and a **Use in an API** tab |
| `app/app.yaml` | Start command, and two environment variables read from the app's resources |
| `app/requirements.txt` | Postgres driver, Databricks SDK, FastAPI |

## Steps

1. Open **Lakebase Postgres** from the app switcher. Select **Autoscaling**, click **New project**, and name it `workshop`. The project comes with a `production` branch and a `databricks_postgres` database.
2. Open **Databricks Apps** from the app switcher. Click **+ Create app** > **Create a custom app** and name it `admissions-notes`.
3. In **App resources**, click **+ Add resource** > **Database**. Pick the `workshop` project, the `production` branch, and the `databricks_postgres` database. Keep the permission **Can connect and create** and the resource key `postgres`.
4. Click **+ Add resource** > **Model**. In the **Serving Endpoints** section, pick `databricks-meta-llama-3-3-70b-instruct`. Set the permission to **Can query** and the resource key to `model`.
5. Create the app. On the app page, click **Deploy** > **From workspace** and set **Source code path** to `labs/lab3_app_lakebase/app` in your Git folder.
6. Open the app's URL. Saving a note shows `TODO 1` and **Summarize notes** shows `TODO 2`.
7. In `app/app.py`, write `save_note()` (TODO 1). Deploy again and save three notes.
8. In **Lakebase Postgres**, open the SQL Editor on the `production` branch and run `SELECT * FROM workshop_app.notes;`.
9. Write `summarize()` (TODO 2). Deploy again and click **Summarize notes**.

### Fork the database

A Lakebase branch is a copy-on-write fork of the database. It starts with the parent's data and schema, and changes on the branch stay on the branch.

10. In **Lakebase Postgres**, open the `workshop` project, then **Branches** > **Create branch**. Name it `dev`, keep **Branch data and schema**, set **Auto-delete** to **After 1 day**, and click **Create**.
11. Open the SQL Editor on the `dev` branch. Run `SELECT count(*) FROM workshop_app.notes;`. The branch has the notes you saved in production.
12. On `dev`, run `DELETE FROM workshop_app.notes;`.
13. Switch the SQL Editor to `production` and run the count again. Reload the app. Your notes are still there.

### Call the app's API

14. Open the **Use in an API** tab. Follow it to get a token, then save a note with curl or Postman and reload the page. This step needs the Databricks CLI on your laptop.

## Done when

The app lists your notes from Lakebase and returns a summary from the model, the notes survived the delete on `dev`, and the app shows a note you saved through the API.

## If stuck

- TODO 1 or TODO 2 does not work: deploy from `completed/lab3_app_lakebase/app`.
- Do not delete the `workshop` project during the session. A deleted project keeps its name, and Free Edition allows one project per account.
- The app shows an error: open the **Logs** tab on the app page. A missing resource key (`postgres` or `model`) is the usual cause.

## How the app reaches each resource

| Resource | Key | What the app gets | Used in |
|---|---|---|---|
| Lakebase database | `postgres` | `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGSSLMODE`, and `LAKEBASE_ENDPOINT` through `valueFrom` | `connect()` |
| Serving endpoint | `model` | `MODEL_NAME` through `valueFrom`, the endpoint's name | `summarize()` |

Free Edition allows three apps and one Lakebase project per account, and stops an app 24 hours after its last start or deploy. Restart it from the app page.

A call to the API needs a Databricks OAuth token and **Can use** permission on the app. You have both as the app's creator.

Docs: [Connect to an app's API with a token](https://docs.databricks.com/aws/en/dev-tools/databricks-apps/connect-local), [Add a Lakebase resource to an app](https://docs.databricks.com/aws/en/dev-tools/databricks-apps/lakebase), [Add a model serving endpoint to an app](https://docs.databricks.com/aws/en/dev-tools/databricks-apps/model-serving), [Deploy an app](https://docs.databricks.com/aws/en/dev-tools/databricks-apps/deploy)
