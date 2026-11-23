from datetime import datetime
from sqlalchemy import BigInteger, DateTime, ForeignKey, Integer, String, Text, func
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column
from src.database import Base

class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

class Assignment(Base):
    __tablename__ = "assignments"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    assignment_prompt: Mapped[str] = mapped_column(Text, nullable=False)
    status: Mapped[str] = mapped_column(String(30), default="active", nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

class Subtask(Base):
    __tablename__ = "subtasks"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    assignment_id: Mapped[int] = mapped_column(ForeignKey("assignments.id", ondelete="CASCADE"))
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[str | None] = mapped_column(Text)
    estimated_minutes: Mapped[int] = mapped_column(Integer, nullable=False)
    sequence_order: Mapped[int] = mapped_column(Integer, nullable=False)
    prerequisite_ids: Mapped[list] = mapped_column(JSONB, default=list, nullable=False)
    status: Mapped[str] = mapped_column(String(30), default="locked", nullable=False)
    completion_criteria: Mapped[str | None] = mapped_column(Text)

class TelemetryLog(Base):
    __tablename__ = "telemetry_logs"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    assignment_id: Mapped[int | None] = mapped_column(ForeignKey("assignments.id", ondelete="SET NULL"))
    subtask_id: Mapped[int | None] = mapped_column(ForeignKey("subtasks.id", ondelete="SET NULL"))
    event_type: Mapped[str] = mapped_column(String(50), nullable=False)
    session_duration_minutes: Mapped[int | None] = mapped_column(Integer)
    energy_rating: Mapped[int | None] = mapped_column(Integer)
    distraction_tags: Mapped[list] = mapped_column(JSONB, default=list, nullable=False)
    metadata_json: Mapped[dict] = mapped_column("metadata", JSONB, default=dict, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
