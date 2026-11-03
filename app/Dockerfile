# Préparer une image Debian classic avec Node et npm
FROM node:26.13.0-bookworm-slim@sha256:bc0a2afd3b74ce12222fc8bab99271e66257f021078f5f4a5d687a77d280c1d9 AS dependencies

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# Créer l'image finale avec Distroless et intégrer les dépendances de la première
FROM gcr.io/distroless/nodejs26-debian13:nonroot@sha256:a51c5d631b90e1b298e17a88a307b77f0b959b47de942d033acce0c96be3fb83

WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY package.json ./
COPY src ./src

CMD ["src/server.js"]
