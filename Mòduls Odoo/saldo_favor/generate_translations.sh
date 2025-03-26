#!/bin/bash
docker compose exec web odoo --i18n-export=/mnt/extra-addons/saldo_favor/i18n/ca.pot --modules=saldo_favor --language=es_ES -d provestalens
docker compose exec web cp /mnt/extra-addons/saldo_favor/i18n/ca.pot /mnt/extra-addons/saldo_favor/i18n/ca.po
