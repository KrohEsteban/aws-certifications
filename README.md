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

### CI/CD

El proyecto incluye un workflow de GitHub Actions que ejecuta automáticamente:

- **Markdown Lint** - Verifica el formato de archivos Markdown
- **Spell Check** - Verifica la ortografía en español e inglés

Se ejecuta en cada push y pull request a la rama `master`.

## 🌐 Sitio publicado

Las notas se publican automáticamente con Jekyll y GitHub Pages en
<https://estebankroh.com/aws-certifications/>.

Cada certificación vive en su propia carpeta (`DVA-C02/`, `SAA-C03/`, ...) y la
navegación se define con front matter en cada página.

### Agregar o editar una nota

1. Creá o editá el `.md` dentro de la carpeta de la certificación.
2. Agregá el front matter de navegación:

   ```yaml
   ---
   title: Mi nota
   parent: DVA-C02
   nav_order: 3
   ---
   ```

3. Push a `master`: el workflow **Deploy Jekyll site to GitHub Pages** construye
   y publica el sitio.

### Agregar una certificación

1. Creá la carpeta y su índice, por ejemplo `SAA-C03/index.md`, con
   `title: SAA-C03`, `has_children: true`, `has_toc: false` y un `nav_order`
   único.
2. Agregá las notas en esa carpeta con `parent: SAA-C03` y su `nav_order`.
3. Sumá la certificación al índice de `index.md`.

Los títulos con `nav_order` repetido se ordenan alfabéticamente, así que conviene
numerarlos. Las URLs se generan con `permalink: pretty`
(`/SAA-C03/mi-nota/`).
