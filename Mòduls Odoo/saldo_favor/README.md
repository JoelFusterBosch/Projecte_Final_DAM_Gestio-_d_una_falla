# Control de Saldo - Mòdul d'Odoo
<p align= "center">
   <img src="static/description/icon.png" alt="Logotip de Control de Saldo" width="400"/>
</p>

## Descripció
El mòdul **Control de Saldo** permet als usuaris gestionar els saldos a favor dels clients dins del sistema d'Odoo. Este mòdul afegix funcionalitats per a ingressar, visualitzar, i gestionar els saldos disponibles sense tindre el mòdul de **Comptabilitat** no disponible en la versió Community.<br>


## Característiques Clau
- Ingrés de saldo a favor dels clients.
- Visualització de saldos dels clients en una llista dedicada.
- Generació de rebuts de saldo a favor.
- Gestió i control de saldos directament des de la vista dels clients.

## Requisits Previs
- **Odoo 16.0** o superior.
- Els mòduls de **CRM** i **Vendes** han d'estar instal·lats.

## Instal·lació
1. Copia el mòdul en la carpeta `dev_addons` de la teua instal·lació d'Odoo.
2. Reinicia el servidor d'Odoo.
3. Activa el mòdul des de la interfície d'administració de mòduls en Odoo.

## Configuració del Idioma Valencià

Per a utilitzar el mòdul **Control de Saldo** en Valencià (Català), seguix estos passos:

1. **Activar l'Idioma Valencià en Odoo:**
   - Ves a **Configuració** > **Traduccions** > **Idiomes**.
   - Fes clic en **Activar un Idioma**.
   - Selecciona **Català / Valencià** (`ca_ES`) i fes clic en **Activar**.

2. **Canviar l'Idioma de l'Usuari:**
   - Ves a **Configuració** > **Usuaris i Companyies** > **Usuaris**.
   - Selecciona el teu usuari i canvia l'**Idioma** a **Català / Valencià**.

3. **Verificar les Traduccions:**
   - Navega pel mòdul i assegurat que les traduccions es mostren correctament.

El mòdul ara hauria d'estar completament funcional en Valencià.


```bash
# Clone the repository into your addons directory
git https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gesti-_d_una_falla/tree/main/M%C3%B2duls%20Odoo/saldo_favor /ruta/a/odoo/addons/saldo_favor




saldo_favor/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   ├── account_move.py
│   ├── res_partner.py
│   ├── saldo_favor_receipt.py
│   ├── saldo_favor_transaction.py
│   ├── saldo_favor_wizard.py
│   └── sale_order.py
├── views/
│   ├── account_move_views.xml
│   ├── res_partner_views.xml
│   ├── saldo_favor_menu.xml
│   ├── saldo_favor_receipt_views.xml
│   ├── saldo_favor_security.xml
│   ├── saldo_favor_transaction_views.xml
│   ├── saldo_favor_wizard_views.xml
│   └── sale_order_views.xml
├── security/
│   └── ir.model.access.csv
├── static/
│   └── description/
│       ├── icon.png
├── i18n/
│   ├── ca.po
│   └── ca.pot
├── generate_translations.sh
├── README.md
└── LICENSE
=======
```

```bash
# Clone the repository into your addons directory
git clone https://github.com/tu_usuario/tu_repositorio.git /ruta/a/odoo/addons/saldo_favor
```

## Dades del Mòdul

- **Nom**: Familia
- **Versió**: 1.0
- **Resum**: Este mòdul permet gestionar saldos a favor de clients en Odoo 16 Community Edition.
- **Autor**: JB Talens
- **Categoria**: Sales
- **Imagens**: 
- **Dependencies**: `CRM`, `Vendes`, 
- **Dades incluïdes**:
  - `security/ir.model.access.csv`
  - `views/account_move_views.xml`
  - `views/saldo_favor_menu.xml`
  - `views/saldo_favor_receipt_views.xml`
  - `views/saldo_favor_security.xml`
  - `views/saldo_favor_transaction_views.xml`
  - `views/saldo_favor_wizard_views.xml`
  - `views/sale_order_views.xml` 
- **Instal·lable**: True
- **Aplicació**: False
- **Auto Instal·lació**: False

## Contribucions

Les contribucions són benvingudes. Si tens idees per a millores, suggerències o trobes errors, per favor, obri un `issue` o envia un `pull request` en GitHub.



# A millorar:
- Al ingresar Saldo no s'actualitza l'entrada del client, els clients que no tenen saldo no apareixen en la vista. 