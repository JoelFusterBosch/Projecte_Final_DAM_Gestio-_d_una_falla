# Control de Saldo - Módulo Odoo

## Descripción
El módulo **Control de Saldo** permite a los usuarios gestionar los saldos a favor de los clientes dentro del sistema Odoo. Este módulo añade funcionalidades para ingresar, visualizar, y gestionar los saldos disponibles sin tener el módulo de **contabilidad** no dispobible en la versión Community.
<img src="static/description/icon.png" alt="Logo de Control de Saldo" width="150"/>


## Características Clave
- Ingreso de saldo a favor de clientes.
- Visualización de saldos de clientes en una lista dedicada.
- Generación de recibos de saldo a favor.
- Gestión y control de saldos directamente desde la vista de clientes.

## Requisitos Previos
- **Odoo 16.0** o superior.
- Los módulos de **CRM** y **ventas** deben estar instalados.

## Instalación
1. Copia el módulo en la carpeta `addons` de tu instalación de Odoo.
2. Reinicia el servidor Odoo.
3. Activa el módulo desde la interfaz de administración de módulos en Odoo.

## Configuración del Idioma Valenciano

Para utilizar el módulo **Control de Saldo** en Valenciano (Catalán), sigue estos pasos:

1. **Activar el Idioma Valenciano en Odoo:**
   - Ve a **Configuración** > **Traducciones** > **Idiomas**.
   - Haz clic en **Activar un Idioma**.
   - Selecciona **Catalán / Valenciano** (`ca_ES`) y haz clic en **Activar**.

2. **Cambiar el Idioma del Usuario:**
   - Ve a **Configuración** > **Usuarios y Compañías** > **Usuarios**.
   - Selecciona tu usuario y cambia el **Idioma** a **Catalán / Valenciano**.

3. **Verificar las Traducciones:**
   - Navega por el módulo y asegúrate de que las traducciones se muestran correctamente.

El módulo ahora debería estar completamente funcional en Valenciano.


```bash
# Clone the repository into your addons directory
git clone https://github.com/juatafe/saldo_favor.git /ruta/a/odoo/addons/saldo_favor




saldo_favor/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   ├── account_move.py
│   ├── res_partner.py
│   ├── saldo_favor_receipt.py
│   ├── saldo_favor_wizard.py
│   └── sale_order.py
├── views/
│   ├── account_move_views.xml
│   ├── res_partner_views.xml
│   ├── saldo_favor_menu.xml
│   ├── saldo_favor_receipt_views.xml
│   ├── saldo_favor_transaction_views.xml
│   ├── saldo_favor_wizard_views.xml
│   └── sale_order_views.xml
├── security/
│   ├── saldo_favor_security.xml
│   └── ir.model.access.csv
├── static/
│   └── description/
│       ├── icon.png
├── i18n/
│   └── ca.po
├── README.md
└── LICENSE
=======

```bash
# Clone the repository into your addons directory
git clone https://github.com/tu_usuario/tu_repositorio.git /ruta/a/odoo/addons/saldo_favor



# A mejorar:
- Tras ingresar Saldo no se actualiza la entra de cliente, los clientes que no tienen saldo no aparecen en la vista. 