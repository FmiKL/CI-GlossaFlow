# CI GlossaFlow

Pipeline CI/CD pour GlossaFlow, une application de traduction.

> **Note :** l'application sert de support au pipeline (la traduction est simulée).

## Base de données

Les fichiers d'initialisation de PostgreSQL se trouvent dans [infra/postgres/](infra/postgres/).

## Tests

Tests unitaires, depuis `app/` :

```sh
npm ci
npm test
```

Test d'intégration API/PostgreSQL, après le démarrage de l'application :

```sh
npm run test:integration
```

## Pipeline CI/CD

Le [workflow GitHub Actions](.github/workflows/ci.yml) se lance avec les pushes/PR sur `main` :

1. Tests unitaires
2. Build de l'image Docker
3. Scan de l'image API avec Trivy
4. Déploiement avec Terraform
5. Test d'intégration
6. Nettoyage
7. Publication dans GHCR (après un push sur `main`)

## Lancement local

Depuis la racine du dépôt, dans le même terminal, avec Docker démarré et Terraform installé :

### 1. Construire l'image

```sh
docker build -t glossaflow:local app
```

### 2. Préparer l'environnement

```sh
. ./infra/prepare.sh
```

### 3. Démarrer l'application

```sh
terraform -chdir=infra init -backend-config="path=$GLOSSAFLOW_DIR/terraform.tfstate"
terraform -chdir=infra apply
```

Vérifier l'API :

```sh
curl --fail --retry 20 --retry-delay 1 --retry-all-errors http://127.0.0.1:8080/health
```

## Nettoyage

Supprimer l'environnement et ses données :

```sh
terraform -chdir=infra destroy && rm -r "$GLOSSAFLOW_DIR"
```
