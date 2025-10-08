# Imagen base mínima con Node.js
FROM node:18-alpine

# Instalar solo las herramientas necesarias
RUN npm install -g \
    markdownlint-cli \
    cspell \
    @cspell/dict-es-es \
    aws-cli

# Crear directorio de trabajo
WORKDIR /workspace

# Comando por defecto
CMD ["/bin/sh"]
