#!/bin/bash

# Variables per defecte
DB_NAME=${1:-provestalens}
MODULE_NAME=${2:-event_family_registration}
DOCKER_SERVICE="web"

# Comprovar que el servei està actiu
if ! docker compose ps | grep -q "$DOCKER_SERVICE"; then
    echo "❌ El servei $DOCKER_SERVICE no està actiu. Primer inicia els contenidors amb 'docker compose up -d'."
    exit 1
fi

# Missatge informatiu
echo "🚀 Executant tests per al mòdul $MODULE_NAME a la base de dades $DB_NAME..."

# Executar la comanda de tests
docker compose exec $DOCKER_SERVICE odoo \
    -d $DB_NAME \
    --test-enable \
    --stop-after-init \
    --test-tags $MODULE_NAME

# Missatge final
if [ $? -eq 0 ]; then
    echo "✅ Tests completats correctament."
else
    echo "❌ Hi ha hagut algun error durant els tests."
fi
