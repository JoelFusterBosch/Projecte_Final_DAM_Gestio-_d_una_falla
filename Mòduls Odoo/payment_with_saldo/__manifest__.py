{
    'name': 'Payment with Saldo',
    'version': '1.0',
    'category': 'Accounting',
    'summary': 'Method of payment that checks client saldo before payment',
    'description': 'Adds a payment method that only processes the payment if the client has enough saldo.',
    'depends': ['payment', 'account', 'saldo_favor', 'familia'],
    'data': [
    'views/account_payment_view.xml',
    'views/payment_provider_view.xml',
    'views/saldo_insufficient.xml',
    'views/payment_success.xml',
    'views/payment_templates.xml',
    'views/payment_checkout_template.xml',
    'data/account_journal_data.xml',
    'data/payment_provider.xml',
    'data/payment_method_data.xml',  # 🔹 Afegit nou
    'data/payment_method_line_data.xml',  # 🔹 Afegit nou
    'security/sale_order_security.xml',
    'views/sale_order_view.xml',
    'views/qr_templates.xml',
    'views/report_saleorder_document.xml',
    'security/ir.model.access.csv',
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
}
