# NeuroTask
**Multi-User Assistive Academic Task Execution & Burnout Telemetry Platform**

NeuroTask helps students turn complex academic assignments into dependency-ordered 10–15 minute micro-actions, focus on one active step at a time, request help when stuck, and review personal focus/energy telemetry.

## Development approach

NeuroTask is being developed in two stages:

1. **Prototype:** Streamlit interface for rapid feature development, testing and faculty demonstration.
2. **Final application:** React.js frontend styled with Tailwind CSS, communicating with a Python FastAPI backend.

The core Python business logic and PostgreSQL database are intended to be reused across both stages. Keep task decomposition, dependency handling, focus sessions and telemetry separate from frontend-specific code.

## Technology stack

### Prototype
- Streamlit + Python
- PostgreSQL (Supabase / Neon) + SQLAlchemy
- bcrypt password hashing
- Pandas + Plotly
- Optional Gemini / Groq API with strict JSON validation and offline fallback

### Final application
- React.js + Tailwind CSS
- Python + FastAPI
- PostgreSQL + SQLAlchemy
- bcrypt with secure session or token-based authentication
- Reusable Python core modules
- Gemini / Groq API integration

## Current repository foundation

- Streamlit application shell with registration and login.
- Role-aware authentication response (Student/Admin) and inactive-account login rejection.
- Public registration creates Student accounts only; Admin accounts must be provisioned through a trusted setup process.
- Eight SQLAlchemy entities and matching PostgreSQL schema:
  - users
  - assignments
  - subtasks
  - subtask_dependencies
  - focus_sessions
  - telemetry_logs
  - blueprints
  - admin_audit_logs
- Updated Student/Admin use-case diagram.
- Updated application flowchart.
- ER diagram and prototype/final architecture diagrams.

**Important:** Dashboard pages and most feature modules are scaffolding/placeholders. The database schema is a design foundation; it has not yet been connected to a live database or migration-tested. DAG cycle detection and cross-record ownership checks must be enforced by application logic.

## Run the prototype locally

1. Install Python 3.10+.
2. Create and activate a virtual environment.
3. Install packages: `pip install -r requirements.txt`
4. Copy `.env.example` to `.env`.
5. Set `DATABASE_URL` to your PostgreSQL connection string.
6. Run `streamlit run app.py`.

Never commit `.env` or publish database/API credentials.

## Documentation

- `docs/use_case_diagram.puml` — Student and Admin use cases.
- `docs/system_flowchart.mmd` — Student and Admin application flow.
- `docs/er_diagram.mmd` — Database entities and relationships.
- `docs/system_architecture.mmd` — Prototype and final application architectures.

## Security and privacy notes

- Passwords are stored as bcrypt hashes.
- Public registration cannot select the Admin role.
- Admin access must be provisioned securely.
- Student-owned data queries must be scoped to the authenticated user.
- Admin monitoring should use aggregate information and must not expose private assignment descriptions or individual telemetry by default.
- Keep database credentials and AI API keys out of source control.

## Development status

The project is currently completing its design and environment-setup stages. Task decomposition, DAG operations, focus-session workflows, stuck rescue, telemetry dashboards, blueprint management, Admin operations, FastAPI endpoints and the React frontend remain future implementation work.
