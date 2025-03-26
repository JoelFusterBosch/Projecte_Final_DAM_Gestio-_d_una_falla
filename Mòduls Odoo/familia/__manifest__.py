{
    'name': 'Familia',
    'version': '1.0',
    'summary': 'Gestiona clientes como familias y miembros de la familia.',
    'author': 'JB Talens',
    'category': 'Sales',
    'images': ['static/description/icon.png'],
    'depends': ['base', 'contacts', 'saldo_favor'],
    'data': [
        'security/familia_security.xml',
        'security/ir.model.access.csv',
        'views/familia_views.xml',
        'views/miembro_familia_views.xml',
        'views/familia_menu.xml',
    ],
    'installable': True,
    'application': True,
    'auto_install': False,
}
