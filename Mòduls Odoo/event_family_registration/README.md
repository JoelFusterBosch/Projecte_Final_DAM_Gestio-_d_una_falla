# event_family_registration
<p align= "center">
   <img src="static/description/icon.png" alt="Logotip de Event Family Registration" width="400"/>
</p>

## Descripció
Mòdul per tal de registrar-se als diferents events.

## Requisits Previs
- **Odoo 16.0** o superior.
- Els mòduls de **CRM** i **Vendes**, **Events**, **Website_event** han d'estar instal·lats.
- Mòdul personalitzat per a gestionar clients com a unitats familiars, facilitant l'administració dels seus saldos i relacions. Pots trobar-lo en [familia](https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gestio-_d_una_falla/tree/main/M%C3%B2duls%20Odoo/familia /ruta/a/odoo/addons/familia).

```bash
# Clone the repository into your addons directory
git https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gestio-_d_una_falla/tree/main/M%C3%B2duls%20Odoo/event_family_registration /ruta/a/odoo/addons/event_family_registration

event_family_registration/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   ├── allow_family_registration.py
│   ├── event_event_copia.py
│   ├── event_event_ticket.py
│   ├── event_event.py
│   ├── event_registration.py
│   ├── sale_order.py
├── views/
│   ├── event_event_ticket_views.xml
│   ├── event_event_views.xml
│   ├── event_registration_views.xml
│   ├── sale_portal_templates.xml
│   ├── website_event_registration_templates.xml
├── security/
│   └── ir.model.access.csv
├── controllers/
│   ├── __init__.py
│   ├── main.py
├── static/
│   └── description/
│       ├── icon.png
│   └── src/
│       └── js/
│           ├── custom_registration.js
├── README.md
└── LICENSE
=======
```

```bash
# Clone the repository into your addons directory
git clone https://github.com/tu_usuario/tu_repositorio.git /ruta/a/odoo/addons/event_family_registration
```

## Dades del Mòdul

- **Nom**: Event Family Registration
- **Versió**: 1.0
- **Resum**: Permet l'inscripció de families en events i maneig de pagues amb saldo a favor.
- **Autor**: JB Talens
- **Categoria**: Events
- **Imagens**: 
- **Dependencies**: `base`, `event`, `sale`, `familia`, `website_event` 
- **Dades incluïdes**:
  - `security/ir.model.access.csv`
  - `views/event_event_ticket_views.xml`
  - `views/event_event_views.xml`
  - `views/event_registration_views.xml`
  - `views/sale_portal_templates.xml`
  - `views/website_event_registration_templates.xml`
- **Instal·lable**: True
- **Aplicació**: True
- **Auto Instal·lació**: False

## Contribucions

Les contribucions són benvingudes. Si tens idees per a millores, suggerències o trobes errors, per favor, obri un `issue` o envia un `pull request` en GitHub.
