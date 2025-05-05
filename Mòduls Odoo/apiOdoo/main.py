# -*- coding: utf-8 -*-
import requests
import sys
import yaml
import xmlrpc.client

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

def post_request(url: str, payload: dict) -> dict:
    """Envia una petició XML-RPC a l'API d'Odoo"""
    server = xmlrpc.client.ServerProxy(url)
    method = payload.get('method', 'authenticate')  # Default to 'authenticate'
    params = payload.get('params', {})
    return getattr(server, method)(*params.get('args', []), **params.get('kwargs', {}))

def getuid(props: dict) -> int:
    """Obté l'UID de l'usuari"""
    connProps = props.get('connection')
    url = connProps.get('url')  # Ensure this is the XML-RPC URL
    db = connProps.get('db')
    login = connProps.get('user')
    password = connProps.get('password')
    server = xmlrpc.client.ServerProxy(url)
    uid = server.authenticate(db, login, password, {})
    if not uid:
        raise ValueError("Authentication failed")
    return uid

def getversion(props: dict) -> dict:
    """Obté la versió d'Odoo"""
    connProps = props.get('connection')
    url = connProps.get('url')  # Use the URL directly from config.yml
    server = xmlrpc.client.ServerProxy(url)
    version_info = server.version()
    return version_info

def request_props(props: dict, tablename: str, operation: str, conditionsArr: list = [], params: dict = {}):
    """Realitza una sol·licitud genèrica a l'API d'Odoo"""
    connProps = props.get('connection')
    url = f"{connProps.get('url').replace('/common', '/object')}"  # Replace '/common' with '/object'
    db = connProps.get('db')
    uid = getuid(props)
    password = connProps.get('password')

    # Construct the arguments for the XML-RPC call
    args = [db, uid, password, tablename, operation, conditionsArr]

    # Only include 'kwargs' if it's not empty and the method supports it
    if params and operation != 'check_access_rights':
        args.append(params)

    # Make the XML-RPC call
    server = xmlrpc.client.ServerProxy(url)
    response = getattr(server, 'execute_kw')(*args)
    return response

def list_events_with_attendees(props: dict, start_date: str = '2025-01-01 00:00:00', limit: int = 10):
    """Busca eventos en el módulo 'event' y lista los asistentes registrados junto con sus compras"""
    # Buscar eventos en el modelo 'event.event'
    events = request_props(
        props,
        'event.event',
        'search_read',
        [[
            ['date_begin', '>=', start_date]  # Filtra eventos a partir de una fecha
        ]],
        {'fields': ['name', 'date_begin', 'date_end', 'registration_ids'], 'limit': limit}
    )

    if not events:
        print("No se encontraron eventos.")
        return

    for event in events:
        print(f"Evento: {event['name']}")
        print(f"  Inicio: {event['date_begin']}")
        print(f"  Fin: {event['date_end']}")

        # Obtener los asistentes del evento
        if 'registration_ids' in event and event['registration_ids']:
            attendees = request_props(
                props,
                'event.registration',
                'read',
                [event['registration_ids']],
                {'fields': ['partner_id']}
            )
            print("  Asistentes:")
            for attendee in attendees:
                if 'partner_id' in attendee and attendee['partner_id']:
                    partner_id = attendee['partner_id'][0]
                    print(f"    - {attendee['partner_id'][1]}")  # Muestra el nombre del contacto
                    # Listar las compras del asistente
                    list_purchases_by_attendee(props, partner_id)
        else:
            print("  No hay asistentes registrados.")

def get_model_fields(props: dict, model: str):
    """Retrieve and print all fields of a given model."""
    fields = request_props(
        props,
        model,
        'fields_get',
        [],
        {'attributes': ['string', 'type']}
    )
    print(f"Fields for model '{model}':")
    for field, attributes in fields.items():
        print(f"  {field}: {attributes['string']} ({attributes['type']})")

def list_purchases_by_attendee(props: dict, partner_id: int):
    """Lista los productos comprados por un asistente, filtrando órdenes en estado 'sale'"""
    # Buscar las órdenes de venta del asistente en estado 'sale'
    orders = request_props(
        props,
        'sale.order',
        'search_read',
        [[['partner_id', '=', partner_id], ['state', '=', 'sale']]],  # Filtra por ID del asistente y estado 'sale'
        {'fields': ['name', 'order_line'], 'limit': 10}
    )

    if not orders:
        print(f"  No se encontraron compras en estado 'sale' para el asistente con ID {partner_id}.")
        return

    for order in orders:
        print(f"  Orden de Venta: {order['name']}")
        if 'order_line' in order and order['order_line']:
            # Obtener los detalles de las líneas de pedido
            order_lines = request_props(
                props,
                'sale.order.line',
                'read',
                [order['order_line']],
                {'fields': ['product_id', 'product_uom_qty']}
            )
            for line in order_lines:
                print(f"    - Producto: {line['product_id'][1]} (Cantidad: {line['product_uom_qty']})")
        else:
            print("    No hay líneas de pedido en esta orden.")

def serve_product_by_barcode(props: dict, barcode: str, product_name: str = "Cadira dinar Faller@"):
    """Serveix una unitat del producte associat al codi de barres d'un contacte, només per a comandes en estat 'sale'"""
    # Buscar el contacte pel codi de barres
    partner = request_props(
        props,
        'res.partner',
        'search_read',
        [[['barcode', '=', barcode]]],
        {'fields': ['id', 'name', 'email'], 'limit': 1}
    )

    if not partner:
        print(f"No s'ha trobat cap contacte amb el codi de barres {barcode}.")
        return

    partner_id = partner[0]['id']
    partner_name = partner[0]['name']
    partner_email = partner[0].get('email', 'No especificat')
    print(f"Contacte trobat: {partner_name} (ID: {partner_id}, Email: {partner_email})")

    # Buscar les ordres de venda en estat 'sale' associades al contacte
    orders = request_props(
        props,
        'sale.order',
        'search_read',
        [[['partner_id', '=', partner_id], ['state', '=', 'sale']]],  # Filtra per contacte i estat 'sale'
        {'fields': ['id', 'name', 'order_line']}
    )

    if not orders:
        print(f"No s'han trobat ordres de venda en estat 'sale' per al contacte {partner_name}.")
        return

    for order in orders:
        print(f"  Processant ordre de venda: {order['name']}")

        # Buscar les línies de comanda associades al producte dins de l'ordre
        order_lines = request_props(
            props,
            'sale.order.line',
            'search_read',
            [[['product_id.name', '=', product_name], ['id', 'in', order['order_line']]]],
            {'fields': ['id', 'product_uom_qty', 'qty_delivered', 'product_id']}
        )

        if not order_lines:
            print(f"  No s'han trobat línies de comanda per al producte '{product_name}' en l'ordre {order['name']}.")
            continue

        for line in order_lines:
            line_id = line['id']
            qty_ordered = line['product_uom_qty']
            qty_delivered = line['qty_delivered']
            qty_remaining = qty_ordered - qty_delivered

            if qty_remaining <= 0:
                print(f"  Totes les unitats del producte '{product_name}' ja han estat servides per a aquesta línia de comanda.")
                continue

            # Actualitzar la quantitat servida
            new_qty_delivered = qty_delivered + 1
            if new_qty_delivered > qty_ordered:
                new_qty_delivered = qty_ordered

            request_props(
                props,
                'sale.order.line',
                'write',
                [[line_id], {'qty_delivered': new_qty_delivered}]
            )

            print(f"  S'ha servit 1 unitat del producte '{product_name}' per al contacte {partner_name}.")
            print(f"  Quantitat servida: {new_qty_delivered}/{qty_ordered}. Resten per servir: {qty_ordered - new_qty_delivered}.")

            # Opcional: Enviar un correu electrònic al contacte amb el resum
            if partner_email != 'No especificat':
                print(f"  Enviant correu electrònic a {partner_email} amb el resum de les unitats servides i pendents.")

def serve_product_by_date_time(props: dict, barcode: str, date: str, time: str, product_name: str = "Cadira dinar Faller@"):
    """Serveix una unitat del producte si coincideix amb el dia i l'hora d'un esdeveniment"""
    # Buscar el contacte pel codi de barres
    partner = request_props(
        props,
        'res.partner',
        'search_read',
        [[['barcode', '=', barcode]]],
        {'fields': ['id', 'name', 'email'], 'limit': 1}
    )

    if not partner:
        print(f"No s'ha trobat cap contacte amb el codi de barres {barcode}.")
        return

    partner_id = partner[0]['id']
    partner_name = partner[0]['name']
    print(f"Contacte trobat: {partner_name} (ID: {partner_id})")

    # Buscar esdeveniments que coincideixin amb la data i hora
    events = request_props(
        props,
        'event.event',
        'search_read',
        [[['date_begin', '<=', f"{date} {time}"], ['date_end', '>=', f"{date} {time}"]]],
        {'fields': ['id', 'name', 'date_begin', 'date_end']}
    )

    if not events:
        print(f"No s'han trobat esdeveniments actius per al dia {date} a les {time}.")
        return

    # Comprovar si el contacte està registrat a algun dels esdeveniments
    for event in events:
        registrations = request_props(
            props,
            'event.registration',
            'search_read',
            [[['event_id', '=', event['id']], ['partner_id', '=', partner_id]]],
            {'fields': ['id', 'sale_order_id', 'sale_order_line_id']}
        )
        print(f"Registrations for event '{event['name']}': {registrations}")

        if not registrations:
            continue

        registration = registrations[0]
        sale_order_id = registration.get('sale_order_id')
        sale_order_line_id = registration.get('sale_order_line_id')

        if not sale_order_id:
            print(f"El registre de l'esdeveniment '{event['name']}' no té una comanda associada.")
            continue

        # Si no hi ha línia de comanda, buscar-la manualment
        if not sale_order_line_id:
            print(f"No hi ha línia de comanda associada. Buscant manualment dins de la comanda {sale_order_id[1]}...")
            order_lines = request_props(
                props,
                'sale.order.line',
                'search_read',
                [[['order_id', '=', sale_order_id[0]], ['product_id.name', '=', product_name]]],
                {'fields': ['id', 'product_uom_qty', 'qty_delivered', 'product_id', 'write_date']}
            )
            if not order_lines:
                print(f"No s'ha trobat cap línia de comanda per al producte '{product_name}' dins de la comanda {sale_order_id[1]}.")
                continue

            sale_order_line_id = order_lines[0]['id']
            print(f"Línia de comanda trobada manualment: {sale_order_line_id}")

        # Buscar la línia de comanda associada
        order_line = request_props(
            props,
            'sale.order.line',
            'read',
            [sale_order_line_id],
            {'fields': ['id', 'product_uom_qty', 'qty_delivered', 'product_id', 'write_date']}
        )

        if not order_line:
            print(f"No s'ha trobat la línia de comanda associada al registre de l'esdeveniment '{event['name']}'.")
            return

        line = order_line[0]
        qty_ordered = line['product_uom_qty']
        qty_delivered = line['qty_delivered']
        qty_remaining = qty_ordered - qty_delivered
        last_delivery_date = line.get('write_date', 'Desconeguda')

        print(f"Detalls de la línia de comanda:")
        print(f"  - Quantitat total: {qty_ordered}")
        print(f"  - Quantitat servida: {qty_delivered}")
        print(f"  - Quantitat restant: {qty_remaining}")
        print(f"  - Última data de lliurament: {last_delivery_date}")

        if qty_remaining <= 0:
            print(f"Totes les unitats del producte '{product_name}' ja han estat servides per a aquesta línia de comanda.")
            return

        # Actualitzar la quantitat servida
        new_qty_delivered = qty_delivered + 1
        if new_qty_delivered > qty_ordered:
            new_qty_delivered = qty_ordered

        request_props(
            props,
            'sale.order.line',
            'write',
            [[line['id']], {'qty_delivered': new_qty_delivered}]
        )

        print(f"S'ha servit 1 unitat del producte '{product_name}' per al contacte {partner_name}.")
        print(f"Quantitat servida: {new_qty_delivered}/{qty_ordered}. Resten per servir: {qty_ordered - new_qty_delivered}.")
        return  # Serveix només una unitat i surt de la funció

    print(f"El contacte {partner_name} no té cap comanda associada a l'esdeveniment actiu per al dia {date} a les {time}.")

# ------------------------------------------------------
# Test per a verificar funcionalitat
# ------------------------------------------------------

def main_test():
    """Executa proves per a verificar la connexió i operacions bàsiques"""
    #env = "production"  # Canviar a 'development' depenent de l'entorn  
    env = "development"  # Cambiar a 'production' per entorns de producció
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
    env = "development"  # Cambiar a 'development' para entornos locales o  production
    props = read_app_props(env)

    # Llamar a la nueva función para listar eventos y asistentes
    #list_events_with_attendees(props, start_date='2025-04-01 00:00:00', limit=5)

    # Call this function to check the fields of 'event.event'
    #get_model_fields(props, 'event.event')
    #get_model_fields(props, 'sale.order')
    # Serveix una unitat del producte associat al codi de barres
    #serve_product_by_barcode(props, barcode='8430001000017', product_name='Cadira dinar Faller@')
    serve_product_by_date_time(props, barcode='899068849304', date='2025-10-18', time='14:00:00', product_name='Cadira dinar Faller@')
