# Software Requirements Specification (SRS)
## NeuroTask — Multi-User Assistive Academic Task Execution & Burnout Telemetry Platform

**Version:** 2.0  
**Date:** 25 November 2026

## 1. Introduction

### 1.1 Purpose
NeuroTask helps students overcome procrastination and task-initiation friction by converting complex academic assignments into dependency-ordered, manageable micro-actions. It provides a focused work area, a mechanism for splitting blocked actions, and personal workload and energy insights.

### 1.2 Objectives
- Break academic assignments into approximately 10–15-minute actions.
- Organise actions using prerequisite dependencies represented as a directed acyclic graph (DAG).
- Provide a single-action focus workspace and visual timer.
- Allow students to split blocked actions into smaller steps using an "I'm Stuck" feature.
- Record energy ratings, distraction tags and focus-session activity.
- Present personal workload and burnout-related indicators.
- Provide reusable academic assignment blueprints.
- Provide a separate Admin role for account management and aggregate application monitoring.

### 1.3 Scope
The system is intended for academic assignments and student work. Burnout-related insights are informational and are not medical diagnoses. The application will not include XP, points, streaks, avatars or virtual currency.

## 2. User Roles

### 2.1 Student
Students can register, log in, manage their own accounts, create and manage assignments, generate subtasks, view dependencies, use the focus workspace and timer, request task splitting, record energy and distractions, view personal insights, and use assignment blueprints.

Students may access only their own private assignments, subtasks, focus sessions and telemetry records.

### 2.2 Admin
Admins have a separate Admin Dashboard. They can search and view basic user-account information, activate or deactivate accounts, view aggregate user/assignment/task statistics, monitor general application health and errors, maintain blueprints where authorised, and review administrative audit logs.

Admins cannot retrieve passwords and must not automatically access private assignment descriptions or individual student energy/distraction records. Administrative actions must be auditable. Admin accounts must be provisioned through a trusted process; public registration creates Student accounts only.

## 3. System Architecture and Technology

### 3.1 Prototype
- Interface: Streamlit
- Language: Python
- Database: PostgreSQL (for example, Supabase or Neon)
- ORM: SQLAlchemy
- Password hashing: bcrypt
- Data processing: Pandas
- Charts: Plotly
- Optional AI provider: Gemini or Groq, with structured-output validation and an offline fallback

### 3.2 Final Application
- Frontend: React.js
- Styling: Tailwind CSS
- Backend/API: Python with FastAPI
- Database: PostgreSQL
- ORM: SQLAlchemy
- Authentication: bcrypt with secure session or token-based authentication
- Analytics: Pandas and suitable chart components
- AI provider: Gemini or Groq

### 3.3 Reusable Logic
Task decomposition, DAG validation, focus-session handling, telemetry processing, analytics and database models must be implemented in reusable Python modules. The Streamlit prototype calls these modules directly. The final FastAPI backend exposes the same core functionality through authorised API endpoints to React.

## 4. Functional Requirements

- **FR-01 Authentication and authorisation:** Register and log in users; hash passwords; distinguish Student and Admin roles; restrict pages and operations by role; reject inactive accounts; isolate student-owned records.
- **FR-02 Assignment management:** Students can create, view, edit and delete academic assignments with title, description, deadline and status.
- **FR-03 Task decomposition:** Convert assignment descriptions into validated, structured micro-actions, generally 10–15 minutes each. Provide a fallback if the AI provider is unavailable.
- **FR-04 Dependencies:** Represent prerequisites as a DAG. A task is available only when its prerequisites are complete. Prevent self-dependencies and cycles.
- **FR-05 Focus workspace:** Display one active action, provide a visual timer and record focus-session activity.
- **FR-06 I'm Stuck:** Split a blocked action into smaller actions, ideally around five minutes each, while preserving the intended outcome.
- **FR-07 Telemetry:** Record user energy ratings, distraction tags and relevant focus-session information.
- **FR-08 Insights:** Display personal workload, focus and energy patterns and informational recovery alerts. Do not present these as clinical diagnoses.
- **FR-09 Blueprint library:** Allow students to browse and use reusable academic templates; allow authorised maintenance.
- **FR-10 Admin user management:** Allow authorised Admins to search accounts, view basic account details, activate/deactivate accounts and record these actions.
- **FR-11 Admin monitoring:** Display aggregate user, assignment and task statistics, system status, relevant errors and administrative activity while respecting student privacy.

## 5. Non-Functional Requirements

- **Security:** bcrypt password hashing, role-based authorisation, user-scoped queries, protected secrets and auditable Admin actions.
- **Performance:** Common navigation and database operations should respond promptly; AI operations should provide loading and error feedback.
- **Reliability:** Handle database and AI failures gracefully; provide an offline task-generation fallback.
- **Usability:** Keep the prototype straightforward; make the final React interface responsive, consistent and professional.
- **Maintainability:** Separate frontend code, business logic, API operations and database models; use Git/GitHub version control.

## 6. Database Requirements

The PostgreSQL design contains eight entities:
1. **Users** — Student/Admin accounts and roles.
2. **Assignments** — student-owned academic assignments.
3. **Subtasks** — atomic actions belonging to assignments.
4. **Subtask_Dependencies** — prerequisite links between subtasks.
5. **Focus_Sessions** — start/end times, duration and status of focus sessions.
6. **Telemetry_Logs** — energy, distraction and activity events.
7. **Blueprints** — reusable assignment templates.
8. **Admin_Audit_Logs** — records of Admin actions.

Assignments may optionally reference a blueprint. Telemetry may optionally reference a focus session, assignment or subtask. DAG cycle validation and cross-record ownership checks must be enforced by application logic in addition to database constraints.

## 7. External Interfaces

- Streamlit provides the prototype screens.
- React provides the final user interface.
- FastAPI exposes authorised application operations to React.
- SQLAlchemy manages PostgreSQL access.
- A Python integration module communicates with the selected AI provider and validates its output.

## 8. Constraints and Assumptions

- The application focuses on academic assignments.
- Hosted database and AI services may require internet access.
- AI-generated steps must be validated and reviewable.
- The prototype and final application reuse the core Python logic and PostgreSQL data model.
- The final frontend is separate from Streamlit.
- Admin privileges are assigned only through a trusted process.
- The system does not diagnose medical or mental-health conditions.

## 9. Acceptance Criteria

The project is successful when:
1. Students can register, log in and access isolated accounts.
2. Admins can securely access their separate dashboard.
3. Admins can manage account status and view aggregate application metrics.
4. Students can create and manage assignments.
5. Assignments can be decomposed into manageable subtasks.
6. Dependency order is respected and cycles are rejected.
7. Students can use the focus workspace and timer.
8. The stuck-rescue feature can generate smaller actions.
9. Energy and distraction information can be recorded and visualised.
10. Students can browse and use blueprints.
11. Private student records remain isolated.
12. The Streamlit prototype demonstrates core workflows.
13. The React frontend communicates with the FastAPI backend.
14. A pilot can be conducted with approximately 8–10 peers over one week.

## 10. Development Stages

1. Requirements and design: SRS, ER diagram, architecture, flowcharts and wireframes.
2. Environment setup: Python, Git, VS Code, Antigravity and PostgreSQL setup.
3. Streamlit prototype: authentication, assignments, task engine and core workflows.
4. Prototype testing: database, feature validation and peer feedback.
5. Final backend: FastAPI endpoints and integration with reusable Python modules.
6. Final frontend: React pages, Tailwind styling and API integration.
7. Final testing: security, usability, integration and deployment.
8. Documentation: report, diagrams, presentation and demonstration.

**End of SRS — Version 2.0**
