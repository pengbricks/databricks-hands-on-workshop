import os
import time
from pathlib import Path

import psycopg
from databricks.sdk import WorkspaceClient
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from pydantic import BaseModel

app = FastAPI(title="Admissions notes")

# The app runs as its own service principal. The SDK picks up its credentials.
w = WorkspaceClient()

_token = {"value": None, "expires": 0.0}


def database_token():
    """A Postgres password for the service principal. Valid for one hour, reused for 45 minutes."""
    if time.time() > _token["expires"]:
        credential = w.postgres.generate_database_credential(endpoint=os.environ["LAKEBASE_ENDPOINT"])
        _token.update(value=credential.token, expires=time.time() + 2700)
    return _token["value"]


def connect():
    # PGHOST, PGPORT, PGDATABASE, PGUSER, and PGSSLMODE come from the Database resource.
    return psycopg.connect(
        host=os.environ["PGHOST"],
        port=os.environ.get("PGPORT", "5432"),
        dbname=os.environ["PGDATABASE"],
        user=os.environ["PGUSER"],
        password=database_token(),
        sslmode=os.environ.get("PGSSLMODE", "require"),
        autocommit=True,
    )


def read_notes():
    with connect() as conn:
        conn.execute("CREATE SCHEMA IF NOT EXISTS workshop_app")
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS workshop_app.notes (
                id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                institution TEXT NOT NULL,
                note TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT now()
            )
            """
        )
        rows = conn.execute(
            "SELECT id, institution, note, created_at FROM workshop_app.notes ORDER BY created_at DESC"
        ).fetchall()
    return [{"id": i, "institution": a, "note": n, "created_at": c.isoformat()} for i, a, n, c in rows]


def save_note(institution, note):
    with connect() as conn:
        row = conn.execute(
            "INSERT INTO workshop_app.notes (institution, note) VALUES (%s, %s) "
            "RETURNING id, institution, note, created_at",
            (institution, note),
        ).fetchone()
    return {"id": row[0], "institution": row[1], "note": row[2], "created_at": row[3].isoformat()}


def summarize(notes):
    lines = "\n".join(f"- {n['institution']}: {n['note']}" for n in notes)
    prompt = f"Summarize these notes about college admissions in three sentences.\n\n{lines}"
    model = os.environ["MODEL_NAME"]
    body = {"messages": [{"role": "user", "content": prompt}], "max_tokens": 300}

    if model.count(".") == 2:
        # A Unity Gateway model service, named catalog.schema.service. Free Edition has none.
        response = w.api_client.do(
            "POST", "/ai-gateway/mlflow/v1/chat/completions", body={"model": model, **body}
        )
    else:
        # A model serving endpoint, named by its endpoint name.
        response = w.api_client.do("POST", f"/serving-endpoints/{model}/invocations", body=body)

    return response["choices"][0]["message"]["content"]


class NewNote(BaseModel):
    institution: str
    note: str


@app.get("/", response_class=HTMLResponse)
def page():
    return (Path(__file__).parent / "index.html").read_text()


@app.get("/api/info")
def api_info():
    return {"workspace_host": w.config.host}


@app.get("/api/notes")
def api_list_notes():
    return read_notes()


@app.post("/api/notes", status_code=201)
def api_save_note(new: NewNote):
    return save_note(new.institution, new.note)


@app.post("/api/summary")
def api_summary():
    notes = read_notes()
    if not notes:
        raise HTTPException(400, "Save a note first.")
    return {"summary": summarize(notes)}