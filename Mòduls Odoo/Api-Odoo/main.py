# -*- coding: utf-8 -*-
import xmlrpc.client
import ssl
import sys
import yaml

# ------------------------------------------------------
# Configuració i utilitats bàsiques
# ------------------------------------------------------

def read_app_props(env: str) -> dict:
    """Llig les propietats de connexió des de l'arxiu config.yml"""
    configFile = sys.path[0] + "/config.yml"
    with open(configFile, 'r', encoding='utf-8') as f:
        configData = yaml.full_load(f).get(env)
    return configData

# ------------------------------------------------------
# Funcions per a manejar l'API d'Odoo
# ------------------------------------------------------

def get_xmlrpc_url(url: str, port: int) -> str:
    """Construeix la URL base per a XML-RPC"""
    return f"{url}:{port}/xmlrpc/2"

def get_ws_rpcclient(props: dict):
    """Obtiene el cliente XML-RPC para la conexión"""
    connProps = props.get('connection')
    host = connProps.get('host')
    port = connProps.get('port')
    connProps = props.get('connection')
    url = get_xmlrpc_url(connProps.get('url'), connProps.get('port'))

    return{
       'common': xmlrpc.client.ServerProxy(f'{url}/common', allow_none=True, context=ssl._create_unverified_context()),
       'object': xmlrpc.client.ServerProxy(f'{url}/object', allow_none=True, context=ssl._create_unverified_context()),
   }
def getuid(props: dict) -> int:
    """Obté l'UID de l'usuari"""
    connProps = props.get('connection')
    db = connProps.get('db')
    user = connProps.get('user')
    pwd = connProps.get('password')
    wsClient = get_ws_rpcclient(props)
    print(wsClient)
    return wsClient['common'].authenticate(db, user, pwd, {})

def getversion(props: dict) -> dict:
    """Obté la versió d'Odoo"""
    wsClient = get_ws_rpcclient(props)
    return wsClient['common'].version()

def request_props(props: dict, tablename: str, operation: str, conditionsArr: list = [], params: dict = {}):
    """Realitza una sol·licitud genèrica a l'API d'Odoo"""
    connProps = props.get('connection')
    db = connProps.get('db')
    uid = getuid(props)
    pwd = connProps.get('password')
    wsClient = get_ws_rpcclient(props)
    return wsClient['object'].execute_kw(db, uid, pwd, tablename, operation, conditionsArr, params)

# ------------------------------------------------------
# Test per a verificar funcionalitat
# ------------------------------------------------------

def main_test():
    """Executa proves per a verificar la connexió i operacions bàsiques"""
    env = "development"  # Canviar a 'production' per a entorns en producció
    props = read_app_props(env)

    print("UID:", getuid(props))
    print("Versió d'Odoo:", getversion(props))
    print("Permisos:",
          request_props(props, 'res.partner', 'check_access_rights', ['read'], {'raise_exception': False}))

    print("Buscar registres:",
          request_props(props, 'res.partner', 'search_read', [[['name', 'like', '%Escr%']]],
                        {'fields': ['name'], 'limit': 5}))

if __name__ == "__main__":
    print("Executant proves de connexió amb Odoo...")
    main_test()