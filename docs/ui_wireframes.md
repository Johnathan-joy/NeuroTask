# NeuroTask UI Wireframes — Design Draft

These are structural wireframes for the Streamlit prototype and the later React + Tailwind CSS application. They describe page layout and content, not final visual styling.

## 1. Shared layout and role navigation

The application has role-specific navigation after authentication.

### Student navigation
- Overview
- My Assignments
- Focus Workspace
- Burnout Insights
- Blueprint Library
- Settings
- Log out

### Admin navigation
- Admin Overview
- User Management
- Application Monitoring
- Blueprint Management
- Admin Audit Logs
- Log out

The Admin and Student areas must be protected by server-side role checks. Hiding navigation items alone is not authorisation.

## 2. Student Overview / Dashboard

**Header:** NeuroTask branding, notification area and account menu.

**Welcome section:** Greeting and a short explanation of the student's current workload.

**Summary cards:**
- Active assignments
- Pending micro-actions
- Actions completed today

**Next action card:**
- Next available subtask title
- Parent assignment
- Estimated duration
- Start Focus Session action

**Assignment summary:** A short list of current assignments, deadlines and progress.

## 3. My Assignments

- Page title and Create Assignment action.
- Assignment cards/list with title, deadline, status and progress.
- Assignment detail view with description and generated subtasks.
- Dependency status showing locked, available and completed actions.
- Create/edit/delete assignment controls.
- Task generation and validation feedback.

## 4. Focus Workspace

- Assignment title and active subtask.
- Short task instructions and completion criteria.
- Visual countdown timer with Start, Pause and Finish controls.
- I'm Stuck action to request smaller steps.
- At session end, prompt for energy rating and optional distraction tags.
- Show the next available action after completion.

The workspace should minimise distractions and show one active action at a time.

## 5. Burnout Insights

- Informational notice that insights are not medical diagnoses.
- Weekly focus duration.
- Average energy rating.
- Energy trend chart.
- Common distraction categories.
- Focus-session history and workload patterns.
- Non-clinical recovery suggestions when activity patterns warrant them.

Only the authenticated Student may see their individual telemetry.

## 6. Blueprint Library

- Search and category filters.
- Blueprint cards with title, description and category.
- Preview blueprint structure.
- Use Blueprint action to create a new assignment based on the template.

## 7. Admin Overview

- Total registered accounts.
- Active and deactivated account counts.
- Aggregate assignment and subtask counts.
- Application health indicators.
- Recent system errors and administrative activity summaries.

Admin monitoring should use aggregate statistics and must not expose private assignment descriptions or individual energy/distraction records by default.

## 8. User Management

- Search and filter user accounts.
- Display basic account information and registration date.
- Display account status and role.
- Activate/deactivate account action with confirmation.
- Record every account-affecting action in Admin Audit Logs.

Passwords and password hashes must never be displayed.

## 9. Application Monitoring

- Database connectivity status.
- AI provider availability.
- Application error summaries.
- Recent system events.
- Service status and last health-check time.

Do not expose secrets, connection strings or sensitive user content.

## 10. Blueprint Management and Audit Logs

**Blueprint Management:** Authorised Admins can create, edit, archive or remove shared blueprints. Each change should be recorded.

**Admin Audit Logs:** Display timestamp, Admin identity, action, target type and target identifier. Do not store passwords, API keys or unnecessary private content in audit details.

## 11. Visual direction for final React application

- Professional, calm productivity interface.
- Green and neutral colour palette.
- Clear typography, consistent spacing and restrained borders.
- Responsive sidebar/navigation.
- Accessible contrast and visible keyboard focus.
- Consistent cards, forms, buttons, charts and status indicators.

The Streamlit prototype may use simpler native components while preserving the same page structure and workflows.
