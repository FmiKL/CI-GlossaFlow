# CI GlossaFlow

Pipeline CI/CD pour GlossaFlow, une application de traduction.

> **Note :** l'application sert de support au pipeline (la traduction est simulée).

## Base de données

Les fichiers d'initialisation de PostgreSQL se trouvent dans `infra/postgres/` :

- [schema.sql](infra/postgres/schema.sql) crée la table translations `app.translations`.
- [roles.sql](infra/postgres/roles.sql) crée le user `glossaflow_app` et attribue ses droits.
- [init.sh](infra/postgres/init.sh) exécute les scripts SQL et définit le mot de passe du user.

## Tests

Depuis `app/`, installer les dépendances pour pouvoir lancer les tests :

```sh
npm ci
npm test
```
