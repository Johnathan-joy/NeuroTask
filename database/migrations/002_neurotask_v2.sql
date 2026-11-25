-- Migration from the original four-table NeuroTask schema to v2.
-- Back up the database before running. Execute once against an existing v1 database.
-- For a brand-new database, use database/schema.sql instead.

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS name VARCHAR(120),
    ADD COLUMN IF NOT EXISTS role VARCHAR(20) NOT NULL DEFAULT 'student',
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'ck_users_role'
    ) THEN
        ALTER TABLE users ADD CONSTRAINT ck_users_role
            CHECK (role IN ('student', 'admin'));
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS blueprints (
    id BIGSERIAL PRIMARY KEY,
    created_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    template_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE assignments
    ADD COLUMN IF NOT EXISTS blueprint_id BIGINT REFERENCES blueprints(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS deadline DATE;

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

ALTER TABLE telemetry_logs
    ADD COLUMN IF NOT EXISTS session_id BIGINT REFERENCES focus_sessions(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS admin_audit_logs (
    id BIGSERIAL PRIMARY KEY,
    admin_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    action VARCHAR(100) NOT NULL,
    target_type VARCHAR(50) NOT NULL,
    target_id BIGINT,
    details JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_focus_sessions_user_started ON focus_sessions(user_id, started_at);
CREATE INDEX IF NOT EXISTS idx_admin_audit_admin_created ON admin_audit_logs(admin_id, created_at);
