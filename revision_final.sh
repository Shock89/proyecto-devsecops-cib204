#!/bin/bash
# Revision final de entrega (seccion 14.2 de la guia)
for p in servidor/servidor.js servidor/cifrado.js servidor/auth.js servidor/db.js servidor/config.js servidor/Dockerfile servidor/.dockerignore app-movil/App.js docker-compose.yml .github/workflows/devsecops.yml .devcontainer/devcontainer.json; do [ -e $p ] && echo "ok   $p" || echo "FALTA $p"; done
[ -e servidor/.env ] && echo 'ERROR servidor/.env presente' || echo 'ok   servidor/.env ausente'
ls *.pem servidor/*.pem 2>/dev/null || echo 'ok   sin llaves .pem'
