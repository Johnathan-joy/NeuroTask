import bcrypt
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from src.database import SessionLocal
from src.models import User

def hash_password(password: str) -> str:
    if len(password) < 8:
        raise ValueError("Password must contain at least 8 characters.")
    return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

def verify_password(password: str, password_hash: str) -> bool:
    try:
        return bcrypt.checkpw(password.encode("utf-8"), password_hash.encode("utf-8"))
    except (ValueError, TypeError):
        return False

def register_user(email: str, password: str):
    if SessionLocal is None:
        raise RuntimeError("Database is not configured.")
    normalized_email = email.strip().lower()
    if not normalized_email or "@" not in normalized_email:
        raise ValueError("Enter a valid email address.")
    password_hash = hash_password(password)
    with SessionLocal() as db:
        user = User(email=normalized_email, password_hash=password_hash)
        db.add(user)
        try:
            db.commit()
            db.refresh(user)
            return user.id, user.email
        except IntegrityError:
            db.rollback()
            raise ValueError("An account with this email already exists.")

def authenticate_user(email: str, password: str):
    if SessionLocal is None:
        raise RuntimeError("Database is not configured.")
    with SessionLocal() as db:
        user = db.scalar(select(User).where(User.email == email.strip().lower()))
        if user and verify_password(password, user.password_hash):
            return {"id": user.id, "email": user.email}
    return None
