# AWS Certifications - Notas Centralizadas

Este proyecto centraliza todas las notas y recursos para las certificaciones de AWS.

## 🐳 Entorno Docker

### Requisitos

- Docker
- Docker Compose

### Uso

1. **Construir la imagen:**

   ```bash
   docker compose build
   ```

2. **Comandos directos:**

   ```bash
   # Linting de Markdown
   docker compose run --rm cli markdownlint .
   docker compose run --rm cli markdownlint --fix .

   # Linting de ortografía
   docker compose run --rm cli cspell .
   docker compose run --rm cli cspell "**/*.md" --words-only

   # Acceso interactivo al contenedor
   docker compose run --rm cli sh
   ```

### Herramientas Incluidas

- **markdownlint-cli** - Linter de Markdown
- **cspell** - Linter de ortografía (español e inglés)
