# NeuroTask
**Multi-User Assistive Academic Task Execution & Burnout Telemetry Platform**

NeuroTask helps students turn complex academic assignments into dependency-ordered 10–15 minute micro-actions, focus on one active step at a time, request help when stuck, and review personal focus/energy telemetry.

## Stack
- Streamlit + Python
- PostgreSQL (Supabase / Neon) + SQLAlchemy
- bcrypt password hashing
- Pandas + Plotly
- Optional Gemini / Groq API with strict JSON validation and offline fallback

## Current implementation
- Streamlit application shell
- Registration and login UI
- bcrypt password hashing
- SQLAlchemy user model and database connection
- Four-table PostgreSQL schema
- PlantUML use-case diagram and Mermaid system flowchart

## Run locally
1. Install Python 3.10+.
2. Create a virtual environment and activate it.
3. Install packages: `pip install -r requirements.txt`
4. Copy `.env.example` to `.env`.
5. Set `DATABASE_URL` to your PostgreSQL connection string.
6. Run `streamlit run app.py`.

Never commit `.env` or publish database/API credentials.

## Diagrams
- `docs/use_case_diagram.puml`
- `docs/system_flowchart.mmd`

The project is being developed in phases. The current milestone is the authentication and database foundation; task decomposition, focus sessions, rescue actions and telemetry will follow.
