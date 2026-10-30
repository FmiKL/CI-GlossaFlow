# À lancer depuis la racine du dépôt : . ./infra/prepare.sh
TF_VAR_api_image_id="$(docker image inspect glossaflow:local --format '{{.Id}}')" || return

GLOSSAFLOW_DIR="$(dirname "$PWD")/.glossaflow-local"
umask 077
mkdir -p "$GLOSSAFLOW_DIR"
chmod 700 "$GLOSSAFLOW_DIR"
test -f "$GLOSSAFLOW_DIR/pg_admin_password" || openssl rand -hex 32 > "$GLOSSAFLOW_DIR/pg_admin_password"
test -f "$GLOSSAFLOW_DIR/pg_app_password" || openssl rand -hex 32 > "$GLOSSAFLOW_DIR/pg_app_password"
chmod 444 "$GLOSSAFLOW_DIR/pg_admin_password" "$GLOSSAFLOW_DIR/pg_app_password"

export TF_DATA_DIR="$GLOSSAFLOW_DIR/data"
export TF_VAR_secrets_dir="$GLOSSAFLOW_DIR"
export TF_VAR_api_image_id
