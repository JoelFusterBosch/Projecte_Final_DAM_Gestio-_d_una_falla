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
    'depends': ['base', 'event', 'sale', 'familia', 'saldo_favor','website_event','website'],
    'images': ['static/description/icon.png'],
    'qweb': [
    'static/src/xml/website_event_card_status.xml',
    'static/src/xml/custom_family_registration_template.xml',
    
],
    'data': [
        'views/event_registration_views.xml',
        'views/event_event_ticket_views.xml',
        'views/event_event_views.xml',
        'security/ir.model.access.csv',
        'views/website_event_registration_templates.xml',
        'views/sale_order_mass_cancel.xml',
        'views/account_move_mass_delete.xml',
        'data/ir_cron.xml',
        'views/replace_accept_sign_button_in_portal.xml',
        'views/event_mass_payment_view.xml',
        'views/replace_footer_accept_button.xml',
        
        
        

    ],
    'test': [
        'tests/test_sale_order_expiration.py',
    ],
    'assets': {
        'web.assets_frontend': [
            'event_family_registration/static/src/js/custom_registration.js',  # Aquí se registra tu JS
            'event_family_registration/static/src/js/event_registration_status.js',
            'event_family_registration/static/src/js/event_status_ribbon.js',
            # 'event_family_registration/static/src/js/payment_confirmation.js',
            'event_family_registration/static/src/js/confirm_button_saldo.js',
            

            
            
            
            
            
        ],
    },
    'installable': True,
    'application': True,
    'license': 'LGPL-3',
}
