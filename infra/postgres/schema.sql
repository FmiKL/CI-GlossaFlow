-- Exécuté par init.sh
CREATE SCHEMA app;

CREATE TABLE app.translations (
    id uuid PRIMARY KEY,
    created_at timestamptz NOT NULL DEFAULT now(),
    source_text text NOT NULL,
    source_language text NOT NULL,
    target_language text NOT NULL,
    translated_text text NOT NULL
);
