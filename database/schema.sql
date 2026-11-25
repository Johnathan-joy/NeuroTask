-- NeuroTask v2 PostgreSQL schema.
-- Student-owned records must always be queried using the authenticated user ID.
-- DAG cycle detection is an application-level validation in addition to these constraints.

CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(120),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'student'
        CHECK (role IN ('student', 'admin')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS blueprints (
    id BIGSERIAL PRIMARY KEY,
    created_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    template_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS assignments (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    blueprint_id BIGINT REFERENCES blueprints(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    assignment_prompt TEXT NOT NULL,
    deadline DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS subtasks (
    id BIGSERIAL PRIMARY KEY,
    assignment_id BIGINT NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    estimated_minutes INTEGER NOT NULL
        CHECK (estimated_minutes BETWEEN 1 AND 15),
    sequence_order INTEGER NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'locked',
    completion_criteria TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_subtasks_assignment_sequence UNIQUE (assignment_id, sequence_order)
);

CREATE TABLE IF NOT EXISTS subtask_dependencies (
    subtask_id BIGINT NOT NULL REFERENCES subtasks(id) ON DELETE CASCADE,
    depends_on_subtask_id BIGINT NOT NULL REFERENCES subtasks(id) ON DELETE CASCADE,
    CONSTRAINT pk_subtask_dependencies PRIMARY KEY (subtask_id, depends_on_subtask_id),
    CONSTRAINT ck_dependency_not_self CHECK (subtask_id <> depends_on_subtask_id)
);

CREATE TABLE IF NOT EXISTS focus_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assignment_id BIGINT NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
    subtask_id BIGINT REFERENCES subtasks(id) ON DELETE SET NULL,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,
    duration_minutes INTEGER CHECK (duration_minutes IS NULL OR duration_minutes >= 0),
    status VARCHAR(30) NOT NULL DEFAULT 'in_progress'
);

CREATE TABLE IF NOT EXISTS telemetry_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_id BIGINT REFERENCES focus_sessions(id) ON DELETE SET NULL,
    assignment_id BIGINT REFERENCES assignments(id) ON DELETE SET NULL,
    subtask_id BIGINT REFERENCES subtasks(id) ON DELETE SET NULL,
    event_type VARCHAR(50) NOT NULL,
    energy_rating SMALLINT CHECK (energy_rating IS NULL OR energy_rating BETWEEN 1 AND 5),
    distraction_tags JSONB NOT NULL DEFAULT '[]'::jsonb,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS admin_audit_logs (
    id BIGSERIAL PRIMARY KEY,
    admin_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    action VARCHAR(100) NOT NULL,
    target_type VARCHAR(50) NOT NULL,
    target_id BIGINT,
    details JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_assignments_user_id ON assignments(user_id);
CREATE INDEX IF NOT EXISTS idx_subtasks_assignment_id ON subtasks(assignment_id);
CREATE INDEX IF NOT EXISTS idx_focus_sessions_user_started ON focus_sessions(user_id, started_at);
CREATE INDEX IF NOT EXISTS idx_telemetry_user_created ON telemetry_logs(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_admin_audit_admin_created ON admin_audit_logs(admin_id, created_at);
