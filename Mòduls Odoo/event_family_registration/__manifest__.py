{
    'name': 'Event Family Registration',
    'version': '1.0',
    'category': 'Events',
    'summary': 'Permite la inscripción de familias en eventos y manejo de pagos con saldo a favor.',
    'description': """
        Extensión del módulo de eventos de Odoo para permitir la inscripción de familias.
        Funcionalidades adicionales incluyen:
        - Registro de múltiples miembros de la familia en eventos.
        - Validación de tickets seleccionados con respecto al número de miembros de la familia.
        - Uso de saldo a favor para el pago de eventos.
        - Generación de códigos QR para facilitar el proceso de pago.
        - Personalización del proceso de registro en el frontend del sitio web.
    """,
    'author': 'JB Talens',
    'website': 'https://provestalens.es',
    'depends': ['base', 'event', 'sale', 'familia', 'website_event'],
    'images': ['static/description/icon.png'],
    'qweb': [
    'static/src/xml/website_event_card_status.xml',
],
    'data': [
        'views/event_registration_views.xml',
        'views/event_event_ticket_views.xml',
        'views/event_event_views.xml',
        'security/ir.model.access.csv',
        'views/website_event_registration_templates.xml',
        
        
        'data/ir_cron.xml',
    ],
    'assets': {
        'web.assets_frontend': [
            'event_family_registration/static/src/js/custom_registration.js',  # Aquí se registra tu JS
            'event_family_registration/static/src/js/event_registration_status.js',
            'event_family_registration/static/src/js/event_status_ribbon.js',
            
            
        ],
    },
    'installable': True,
    'application': True,
    'license': 'LGPL-3',
}
