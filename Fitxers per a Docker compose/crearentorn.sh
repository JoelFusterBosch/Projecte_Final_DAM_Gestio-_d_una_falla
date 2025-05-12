#!/bin/bash

set -e

# VARIABLES
PROJECT_DIR=~/odoo_server
ODOO_PORT=8069
ODOO_DB_NAME=falla
ODOO_DB_USER=admin
ODOO_DB_PASS='Pa$$w0rd'
ODOO_MASTER_PASS='Pa$$w0rd'
ODOO_PG_PORT=5432
ADDONS_DIR=$PROJECT_DIR/dev_addons
REENTRY_FLAG="/tmp/.odoo_docker_ready"

# 1. DOCKER I DEPENDÈNCIES
echo "🔧 Instal·lant Docker i dependències..."
sudo apt -y remove docker docker-engine docker.io containerd runc || true
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release python3 python3-pip

# Clau GPG Docker
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
fi

# Repositori Docker
if ! grep -q docker /etc/apt/sources.list.d/docker.list 2>/dev/null; then
  echo "🗂️ Afegint repositori oficial de Docker..."
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

if ! groups $USER | grep -q docker; then
  echo "➕ Afegint $USER al grup docker..."
  sudo usermod -aG docker $USER
fi

if ! docker info >/dev/null 2>&1; then
  if [ ! -f "$REENTRY_FLAG" ]; then
    echo "🔁 Reiniciant sessió amb permisos Docker (newgrp docker)..."
    touch "$REENTRY_FLAG"
    exec sg docker "$0"
  else
    echo "❌ No s'han pogut obtenir permisos de Docker. Reinicia la sessió manualment."
    exit 1
  fi
fi
rm -f "$REENTRY_FLAG"

# 2. ESTRUCTURA I CONFIGURACIÓ
echo "📂 Creant estructura de carpetes i fitxers..."
mkdir -p $PROJECT_DIR/{config_odoo,dev_addons,log}
cd $PROJECT_DIR

# odoo.conf
cat > config_odoo/odoo.conf <<EOF
[options]
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo
proxy_mode = True
db_host = db
db_port = $ODOO_PG_PORT
db_user = odoo
db_password = myodoo
xmlrpc_interface = 0.0.0.0
xmlrpc_port = $ODOO_PORT
admin_passwd = $ODOO_MASTER_PASS
logfile = /var/log/odoo/odoo.log
log_level = info
EOF

# Dockerfile
cat > Dockerfile <<'EOF'
FROM odoo:16.0

USER root
RUN pip uninstall jinja2 markupsafe -y && \
    pip install jinja2==3.1.2 markupsafe==2.1.1 requests

COPY . /mnt/extra-addons
USER odoo
WORKDIR /mnt/extra-addons
EOF

# docker-compose.yml
cat > docker-compose.yml <<EOF
services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
    depends_on:
      - db
    ports:
      - "$ODOO_PORT:$ODOO_PORT"
    volumes:
      - odoo-web-data:/var/lib/odoo
      - ./config_odoo:/etc/odoo
      - ./dev_addons:/mnt/extra-addons
      - ./log:/var/log/odoo
    environment:
      - HOST=db
      - USER=odoo
      - PASSWORD=myodoo
      - TZ=Europe/Madrid
    restart: always
    command: odoo -c /etc/odoo/odoo.conf --log-level=info

  db:
    image: postgres:latest
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=myodoo
      - POSTGRES_USER=odoo
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - odoo-db-data:/var/lib/postgresql/data/pgdata
    restart: always

volumes:
  odoo-web-data:
  odoo-db-data:
EOF

# 3. MÒDULS
echo "⬇️ Clonant mòduls dins dev_addons..."
cd $ADDONS_DIR

# # 🔁 Clonar dependències externes (OCA)
# if [ ! -d "$ADDONS_DIR/account-financial-tools" ]; then
#   echo "📥 Clonant account-financial-tools d'OCA..."
#   git clone https://github.com/OCA/account-financial-tools.git "$ADDONS_DIR/account-financial-tools"
# else
#   echo "🔁 El repositori account-financial-tools ja existeix, no es clona."
# fi

# 🔁 Clonar mòduls propis
for repo in payment_with_saldo familia event_family_registration saldo_favor; do
  if [ ! -d "$repo" ]; then
    echo "📥 Clonant $repo..."
    git clone https://github.com/juatafe/$repo.git
  else
    echo "🔁 $repo ja existeix, no es clona."
  fi
done


# 4. ARRANCA ODOO
echo "🚀 Arrancant Odoo..."
cd $PROJECT_DIR
docker compose build
docker compose up -d

# 5. INSTAL·LACIÓ DE MÒDULS DESPRÉS DE CREAR LA BASE
echo ""
echo "🎯 Accedeix ara a http://localhost:$ODOO_PORT i crea la base de dades \"$ODOO_DB_NAME\" amb usuari \"$ODOO_DB_USER\" i contrasenya \"$ODOO_DB_PASS\""
echo ""
read -p "Vols instal·lar automàticament els mòduls ara a la base \"$ODOO_DB_NAME\"? (s/n): " resposta
if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
    echo "📦 Instal·lant mòduls base i dependències..."
    for modul in sale account contacts event website_event payment website_event_sale; do
        echo "🔹 Instal·lant $modul..."
        docker compose exec -T web odoo -d "$ODOO_DB_NAME" -i "$modul" --stop-after-init
    done

    echo "📦 Instal·lant mòduls personalitzats..."
    for modul in saldo_favor familia event_family_registration payment_with_saldo; do
        echo "🔸 Instal·lant $modul..."
        docker compose exec -T web odoo -d "$ODOO_DB_NAME" -i "$modul" --stop-after-init
    done

    echo "✅ Tots els mòduls han sigut instal·lats correctament."
else
    echo "ℹ️ Pots instal·lar-los manualment amb:"
    echo "   ➤ docker compose exec -T web odoo -d $ODOO_DB_NAME -i <modul> --stop-after-init"
fi


