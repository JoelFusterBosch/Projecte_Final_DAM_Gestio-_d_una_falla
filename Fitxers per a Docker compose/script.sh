#!/bin/bash

set -e

# Variables
PROJECT_DIR=~/odoo_server
ODOO_PORT=8069
ODOO_ADMIN_PASS=admin
ODOO_DB_PASS=myodoo
ODOO_DB_USER=odoo
ODOO_PG_PORT=5432
ADDONS_DIR=$PROJECT_DIR/dev_addons
REENTRY_FLAG="/tmp/.odoo_docker_ready"

echo "🔧 1. Instal·lant Docker i dependències oficials..."

# Elimina restes si n'hi ha, sense mostrar errors si no existeixen
sudo apt -y remove docker docker-engine docker.io containerd runc || true

# Instal·lació segura de paquets base
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# Clau GPG només si no existeix
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  echo "🔑 Afegint clau GPG de Docker..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
fi

# Repositori només si no existeix
if ! grep -q docker /etc/apt/sources.list.d/docker.list 2>/dev/null; then
  echo "🗂️ Afegint repositori oficial de Docker..."
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# Instal·la Docker i Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Activa i inicia Docker
sudo systemctl enable --now docker

# Afegeix l'usuari al grup docker i reinicia amb newgrp si cal
if ! groups $USER | grep -q docker; then
  echo "➕ Afegint $USER al grup docker..."
  sudo usermod -aG docker $USER
fi

# Si no pot accedir al socket Docker, reinicia el context amb newgrp
if ! docker info >/dev/null 2>&1; then
  if [ ! -f "$REENTRY_FLAG" ]; then
    echo "🔁 Reiniciant sessió amb permisos Docker (newgrp docker)..."
    touch "$REENTRY_FLAG"
    exec sg docker "$0"
  else
    echo "❌ No s'han pogut obtenir permisos de Docker tot i estar al grup."
    echo "   Reinicia la sessió manualment o comprova l'accés a /var/run/docker.sock"
    exit 1
  fi
fi

# Ja tenim accés a Docker. Esborra la bandera de reentrada.
rm -f "$REENTRY_FLAG"

echo "📂 2. Creant estructura de carpetes..."
mkdir -p $PROJECT_DIR/{config_odoo,dev_addons,log}
cd $PROJECT_DIR

echo "📝 3. Creant fitxer de configuració odoo.conf..."
cat > config_odoo/odoo.conf <<EOF
[options]
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo
proxy_mode = True

db_host = db
db_port = $ODOO_PG_PORT
db_user = $ODOO_DB_USER
db_password = $ODOO_DB_PASS

xmlrpc_interface = 0.0.0.0
xmlrpc_port = $ODOO_PORT

admin_passwd = $ODOO_ADMIN_PASS

logfile = /var/log/odoo/odoo.log
log_level = info
EOF

echo "🐳 4. Creant Dockerfile..."
cat > Dockerfile <<'EOF'
FROM odoo:16.0

USER root

RUN pip uninstall jinja2 markupsafe -y && \
    pip install jinja2==3.1.2 markupsafe==2.1.1

COPY . /mnt/extra-addons

USER odoo
WORKDIR /mnt/extra-addons
EOF

echo "🐳 5. Creant docker-compose.yml (sense camp 'version')..."
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
      - USER=$ODOO_DB_USER
      - PASSWORD=$ODOO_DB_PASS
      - TZ=Europe/Madrid
    restart: always
    command: odoo -c /etc/odoo/odoo.conf --log-level=info

  db:
    image: postgres:latest
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=$ODOO_DB_PASS
      - POSTGRES_USER=$ODOO_DB_USER
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - odoo-db-data:/var/lib/postgresql/data/pgdata
    restart: always

volumes:
  odoo-web-data:
  odoo-db-data:
EOF

echo "⬇️ 6. Clonant mòduls dins dev_addons..."
cd $ADDONS_DIR
for repo in payment_with_saldo familia event_family_registration saldo_favor; do
  if [ ! -d "$repo" ]; then
    echo "📥 Clonant $repo..."
    git clone https://github.com/juatafe/$repo.git
  else
    echo "🔁 $repo ja existeix, no es clona."
  fi
done

echo "🚀 7. Construint i arrancant contenidors..."
cd $PROJECT_DIR
docker compose build
docker compose up -d

echo "✅ Odoo executant-se a http://<IP>:8069"