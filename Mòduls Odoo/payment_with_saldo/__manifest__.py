{
    'name': 'Payment with Saldo',
    'version': '1.0',
    'category': 'Accounting',
    'summary': 'Method of payment that checks client saldo before payment',
    'description': 'Adds a payment method that only processes the payment if the client has enough saldo.',
    'depends': ['payment', 'account', 'saldo_favor', 'familia', 'point_of_sale','l10n_es'],

'data': [
    'data/account_journal_data.xml',                      # defineix el diari -> PRIMER
    'data/payment_provider.xml',                          # defineix el payment.provider
    'data/payment_method_data.xml',                       # defineix el payment.method
    'data/payment_method_line_data.xml',                  # referència als dos anteriors -> ha d’anar després
    'data/pos_payment_method.xml',
    'data/pos_payment_method_cash.xml',
    'data/default_pos_config_payment_method.xml',
    'security/sale_order_security.xml',
    'security/ir.model.access.csv',
    'views/account_payment_view.xml',
    'views/payment_provider_view.xml',
    'views/saldo_insufficient.xml',
    'views/payment_success.xml',
    'views/payment_templates.xml',
    'views/payment_checkout_template.xml',
    'views/sale_order_view.xml',
    'views/qr_templates.xml',
    'views/report_saleorder_document.xml',
],

    'qweb': [
    'views/assets.xml',
    ],
    'assets': {
        'web.assets_frontend': [
            'payment_with_saldo/static/src/js/payment_with_saldo.js',
            'payment_with_saldo/static/src/js/payment_saldo_error.js',
            ],
        },


    'installable': True,
    'application': False,
    'license': 'LGPL-3',
    'post_load': None,
    'pre_init_hook': None,
    'post_init_hook': 'archive_default_shop',
}
