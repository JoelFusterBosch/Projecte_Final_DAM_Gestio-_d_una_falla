# payment_with_saldo
<p align= "center">
   <img src="static/description/icon.png" alt="Logotip de Payment with Saldo" width="400"/>
</p>

## Descripció
Mòdul per poder fer pagaments amb saldo.

## Requisits Previs
- **Odoo 16.0** o superior.
- Els mòdulos de **CRM**, **Vendes** i **Comerç electrònic** han d'estar instal·lats.
- Mòdul personalitzat per a gestionar els saldos a favor dels clients. Pots trobar-lo en [saldo_favor](https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gestio-_d_una_falla/tree/main/M%C3%B2duls%20Odoo/saldo_favor /ruta/a/odoo/addons/saldo_favor).

```bash
# Clone the repository into your addons directory
git https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gestio-_d_una_falla/tree/main/M%C3%B2duls%20Odoo/payment_with_saldo /ruta/a/odoo/addons/payment_with_saldo

payment_with_saldo/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   ├── account_payment_method_line.py
│   ├── account_payment.py
│   ├── payment_provider.py
│   ├── payment_transaction_inherit.py
│   ├── payment_transaction.py
│   ├── pos_payment.py
│   └── sale_order.py
├── views/
│   ├── account_payment_view.xml
│   ├── assets.xml
│   ├── payment_checkout_template.xml
│   ├── payment_provider_view.xml
│   ├── payment_success.xml
│   ├── payment_templates.xml
│   ├── qr_templates.xml
│   ├── report_saleorder_document.xml
│   ├── saldo_insufficient.xml
│   └── sale_order_view.xml
├── security/
│   └── ir.model.access.csv
├── controllers/
│   ├── __init__.py
│   ├── account_payment_controller.py
│   ├── main.py
│   ├── qr_scan.py
│   └── sale_portal_extend.py
├── data/
│   ├── account_journal_data.xml
│   ├── pdefault_pos_config_payment_method.xml
│   ├── payment_method_line.xml
│   ├── apayment_method_line_data.xml
│   ├── payment_provider.xml
│   ├── pos_payment_method_cash.xml
│   └── pos_payment_method.xml
├── static/
│   ├── description/
│   │    └── icon.png
│   └── src/
│       └── js/
│           ├── disable_native_redirect.js
│           ├── override_native_payment.js
│           ├── payment_saldo_error.js
│           ├── payment_with_saldo.js
│           └── remove_native_widget.js
├── hooks.py
├── payment_confirmation_summary.md
├── README.md
└── LICENSE
=======
```

```bash
# Clone the repository into your addons directory
git clone https://github.com/tu_usuario/tu_repositorio.git /ruta/a/odoo/addons/payment_with_saldo
```

## Dades del Mòdul

- **Nom**: Familia
- **Versió**: 1.0
- **Resum**: Afig un mètode de pagament que soles processa el pagament si el client té suficient saldo.
- **Autor**: JB Talens
- **Categoria**: Accounting
- **Imagens**: 
- **Dependencies**: `payment`, `account`, `saldo_favor`, `familia`, `sale_order` 
- **Dades incluïdes**:
  - `security/ir.model.access.csv`
  - `views/account_payment_view.xml`
  - `views/payment_checkout_template.xml`
  - `views/payment_provider_view.xml`
  - `views/payment_success.xml`
  - `views/payment_templates.xml`
  - `views/saldo_insufficient.xml`
- **Instal·lable**: True
- **Aplicació**: False
- **Auto Instal·lació**: False

## Contribucions

Les contribucions són benvingudes. Si tens idees per a millores, suggerències o trobes errors, per favor, obri un `issue` o envia un `pull request` en GitHub.
