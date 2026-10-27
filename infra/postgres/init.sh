#!/bin/sh
set -eu

app_password=$(cat /run/secrets/pg_app_password)
test -n "$app_password"

psql -X -v ON_ERROR_STOP=1 \
    --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
    --file /opt/glossaflow/schema.sql \
    --file /opt/glossaflow/roles.sql

# psql demande le MDP et sa confirmation
printf '%s\n%s\n' "$app_password" "$app_password" |
    psql -X -v ON_ERROR_STOP=1 \
        --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
        --command '\password glossaflow_app'
