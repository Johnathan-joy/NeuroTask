from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker
from src.config import DATABASE_URL

class Base(DeclarativeBase):
    pass

if not DATABASE_URL:
    engine = None
    SessionLocal = None
else:
    engine = create_engine(
        DATABASE_URL,
        pool_pre_ping=True,
        pool_recycle=300,
        future=True,
    )
    SessionLocal = sessionmaker(
        bind=engine,
        autoflush=False,
        autocommit=False,
        expire_on_commit=False,
    )

def initialize_database():
    if engine is None:
        raise RuntimeError("DATABASE_URL is not configured. Add it to your .env file.")
    from src import models  # noqa: F401
    Base.metadata.create_all(bind=engine)
