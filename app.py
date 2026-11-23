import streamlit as st
from src.config import DATABASE_URL
from src.database import initialize_database
from src.auth import authenticate_user, register_user

st.set_page_config(page_title="NeuroTask", page_icon="🧠", layout="wide")

st.title("🧠 NeuroTask")
st.caption("A calmer way to start, structure and complete academic work.")

if not DATABASE_URL:
    st.warning("Database setup is required before registration/login can be used.")
    st.code("1. Copy .env.example to .env\n2. Add your PostgreSQL DATABASE_URL\n3. Restart Streamlit")
    st.stop()

try:
    initialize_database()
except Exception as exc:
    st.error(f"Could not connect to or initialize the database: {exc}")
    st.stop()

if "user" not in st.session_state:
    st.session_state.user = None

if st.session_state.user is None:
    login_tab, signup_tab = st.tabs(["Log in", "Create account"])
    with login_tab:
        with st.form("login_form"):
            email = st.text_input("Email", key="login_email")
            password = st.text_input("Password", type="password", key="login_password")
            submitted = st.form_submit_button("Log in", use_container_width=True)
        if submitted:
            user = authenticate_user(email, password)
            if user:
                st.session_state.user = user
                st.rerun()
            st.error("Email or password is incorrect.")
    with signup_tab:
        with st.form("signup_form"):
            new_email = st.text_input("Email address", key="signup_email")
            new_password = st.text_input("Password (minimum 8 characters)", type="password")
            confirm_password = st.text_input("Confirm password", type="password")
            create = st.form_submit_button("Create account", use_container_width=True)
        if create:
            if new_password != confirm_password:
                st.error("Passwords do not match.")
            else:
                try:
                    register_user(new_email, new_password)
                    st.success("Account created. You can now log in.")
                except (ValueError, RuntimeError) as exc:
                    st.error(str(exc))
else:
    user = st.session_state.user
    with st.sidebar:
        st.write(f"Signed in as **{user['email']}**")
        if st.button("Log out"):
            st.session_state.user = None
            st.rerun()
        page = st.radio("Navigate", ["Overview", "My Assignments", "Focus Workspace", "Burnout Insights", "Blueprint Library"])

    if page == "Overview":
        st.subheader("Welcome to your private workspace")
        st.write("Start by creating an academic assignment. NeuroTask will help turn it into small, ordered actions.")
        a, b, c = st.columns(3)
        a.metric("Active assignments", "—")
        b.metric("Completed micro-actions", "—")
        c.metric("Focus sessions", "—")
    elif page == "My Assignments":
        st.subheader("My Assignments")
        st.info("Assignment creation and dependency-aware task decomposition are the next development milestone.")
    elif page == "Focus Workspace":
        st.subheader("Single-Step Focus Workspace")
        st.info("The active micro-action, completion criteria and visual timer will be implemented next.")
    elif page == "Burnout Insights":
        st.subheader("Burnout Telemetry")
        st.info("Personal energy, distraction and focus trends will appear here after telemetry logging is implemented.")
    elif page == "Blueprint Library":
        st.subheader("Blueprint Library")
        st.info("Reusable assignment blueprints will be implemented after the core task workflow.")
