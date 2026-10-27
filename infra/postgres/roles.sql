-- Exécuté par init.sh après schema.sql
-- init.sh définit ensuite le MDP de glossaflow_app
CREATE USER glossaflow_app;

REVOKE CONNECT, TEMPORARY ON DATABASE glossaflow_demo FROM PUBLIC;

GRANT CONNECT ON DATABASE glossaflow_demo TO glossaflow_app;
GRANT USAGE ON SCHEMA app TO glossaflow_app;
GRANT SELECT, INSERT ON TABLE app.translations TO glossaflow_app;
