# Mòdul d'Odoo: Gestió de Famílies

<p align="center">
  <img src="static/description/icon.png" alt="Icona del Módulo Família" width="400">
</p>

## Descripció

El mòdul **Família** per a Odoo 16, desenvolupat per **JB Talens**, permet gestionar clients com a unitats familiars, facilitant l'administració dels seus saldos i relacions. Este mòdul és ideal per a negocis que manegen grups de clients com famílies i requerixen un control centralitzat dels saldos familiars.

### Característiques principals

- **Gestió de Famílies**: Agrupa a diversos clients com a membres d'una família, permitent la gestió conjunta dels seus saldos.
- **Control de Saldo Total**: El saldo total de la família es gestiona automàticament, sumant el saldo de cada membre a l'afegir-se i ajustant el saldo a l'eliminar un membre.
- **Restriccions de Membresia**: Un client sols pot pertànyer a una família a la vegada, garantint la coherència en la gestió de saldos.
- **Interfície d'Usuari Personalitzada**: Inclou vistes i menús específics per a facilitar la gestió de famílies i membres dins d'Odoo.
- **Seguretat**: Configuració de seguretat específica per a gestionar l'accés i els permisos dins del mòdul.

## Requisits Previs

- **Odoo 16.0 o superior**
- **Mòduls de CRM y Vendes**: Els mòduls de CRM i vendes han d'estar instal·lats.
- **Mòdul Saldo a Favor**: Mòdul personalitzat per a gestionar els saldos a favor dels clients. Pots trobar-lo en [saldo_favor](https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gestio-_d_una_falla/tree/main/M%C3%B2duls%20Odoo/saldo_favor /ruta/a/odoo/addons/saldo_favor).

## Instal·lació

Per a instal·lar el mòdul **Família**, seguix estos passos:

1. **Clonar el repositori**:
   ```bash
   git clone https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gesti-_d_una_falla/tree/main/M%C3%B2duls%20Odoo/saldo_favor /ruta/a/odoo/addons/familia


### Copiar el mòdul en la carpeta de mòduls d'Odoo:

```bash
cp -R familia /ruta/a/odoo/dev_addons/

```

## Actualitzar la llista de aplicacions

Ves a la interfície d'Odoo > `Apps` > `Actualitzar la llista de mòduls`.

## Instal·lar el mòdul

Busca "Familia" en la llista d'aplicacions disponibles i fes clic en `Instal·lar`.

## Ús

### Configuració Inicial

- **Crear Famílies**: Accedix al menú `Famílies` i crea noves famílies.
- **Afegir Membres**: Afegix membres existents (clients) a les famílies creades.
- **Gestionar Saldos**: El saldo total de la família s'actualitzara automàticament a l'afegir nous membres.

### Gestió de Famílies

- **Vore Famílies**: Consulta la llista de famílies i els seus detalls, inclosos els saldos i els membres associats.
- **Eliminar Membres**: A l'eliminar un membre, el seu saldo es restablira a zero i es desvinculara de la família.

## Seguretat

Este mòdul inclou regles de seguretat personalitzades definides en:

- `security/familia_security.xml`
- `security/ir.model.access.csv`

Estes regles controlen l'accés a les diferents vistes i operacions dins del mòdul, assegurant que sols els usuaris autoritzats puguen gestionar famílies i membres.

En el mòdul **Família** d'Odoo, es definixen regles d'accés i grups d'usuaris que controlen que accions poden realitzar certs usuaris en els models específics del mòdul. A continuació s'explica com es configuren estos elements.

### Grups d'Usuaris

Els grups d'usuaris en Odoo s'utilitzen per a organitzar i assignar permisos als usuaris. En el mòdul **Família**, s'ha creat un grup específic anomenat **Família Manager**:

```xml
<record id="group_familia_manager" model="res.groups">
    <field name="name">Familia Manager</field>
    <field name="category_id" ref="base.module_category_sales"/>
</record>

```
### Grups d'Usuaris: Família Manager

- **id**: `group_familia_manager` — Identificador únic del grup.
- **name**: `Familia Manager` — Nom del grup.
- **category_id**: `base.module_category_sales` — Categoria del grup dins d'Odoo, en este cas es classifica baix la categoria de Vendes.

Este grup s'utilitzara per a assignar permisos específics sobre els models del mòdul **Família**.

### Regles d'Accés

Les regles d'accés en Odoo determinen que registres es poden veure, crear, modificar o eliminar d'un usuari en un model específic. Ací es mostren les regles d'accés definides per al mòdul **Família**.

#### Regla d'Accés per al Model `familia`


```xml
<record id="familia_familia_rule" model="ir.rule">
    <field name="name">Familia: ver todas</field>
    <field name="model_id" ref="familia.model_familia"/>
    <field name="groups" eval="[(4, ref('group_familia_manager'))]"/>
    <field name="domain_force">[(1, '=', 1)]</field>
</record>
```
- **id**: `familia_familia_rule` — Identificador únic de la regla.
- **name**: `Familia: ver todas` — Nom de la regla d'accés.
- **model_id**: `familia.model_familia` — Específica que la regla s'aplica al model `familia`.
- **groups**: `group_familia_manager` — Defineix que esta regla s'aplica al grup `Familia Manager`.
- **domain_force**: `[(1, '=', 1)]` — Permet l'accés a tots els registres del model `familia`.

Esta regla assegura que els usuaris del grup **Família Manager** puguen veure tots els registres del model `familia`.

#### Regla d'Accés per al Model `familia.miembro`

```xml
<record id="familia_miembro_rule" model="ir.rule">
    <field name="name">Miembro de Familia: ver todos</field>
    <field name="model_id" ref="familia.model_familia_miembro"/>
    <field name="groups" eval="[(4, ref('group_familia_manager'))]"/>
    <field name="domain_force">[(1, '=', 1)]</field>
</record>
```

- **id**: `familia_miembro_rule` — Identificador únic de la regla.
- **name**: `Miembro de Familia: ver todos` — Nom de la regla d'accés.
- **model_id**: `familia.model_familia_miembro` — Específica que la regla s'aplica al model `familia.miembro`.
- **groups**: `group_familia_manager` — Definix que esta regla s'aplica al grup `Familia Manager`.
- **domain_force**: `[(1, '=', 1)]` — Permet l'accés a tots els registres del model `familia.miembro`.

Esta regla assegura que els usuaris del grup **Familia Manager** puguen veure tots els registres del model `familia.miembro`.

### Accessos Definits en el Fitxer `ir.model.access.csv`

A més de les regles d'accés, es definixen permisos detallats en el fitxer `ir.model.access.csv`:

```
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_familia_manager,familia.manager,familia.model_familia,group_familia_manager,1,1,1,1
access_miembro_familia_manager,miembro_familia.manager,familia.model_familia_miembro,group_familia_manager,1,1,1,1
access_miembro_familia_admin,miembro_familia.admin,familia.model_familia_miembro,base.group_system,1,1,1,1

```
- **access_familia_manager**: Permet al grup `Familia Manager` llegir, escriure, crear i eliminar registres en el model `familia`.
- **access_miembro_familia_manager**: Permet al grup `Familia Manager` llegir, escriure, crear i eliminar registres en el model `familia.miembro`.
- **access_miembro_familia_admin**: Permet al grup d'administració (`base.group_system`) fer totes les operacions en el model `familia.miembro`.

## Requisits de Permisos

Per a gestionar el mòdul **Familia** correctament, és necessari que l'usuari administrador estiga inclòs en el grup **Familia Manager**. Este grup té permisos específics que permitixen l'administració completa de les funcionalitats del mòdul.

### Incloure a l'Usuari Administrador en el Grup Familia Manager

1. **Accedix a la Configuració d'Usuaris**:
   - Ves a la interfície d'Odoo.
   - Navega a `Configuració` > `Usuaris i Companyies` > `Usuaris`.

2. **Selecciona a l'Usuari Administrador**:
   - Busca i selecciona al usuari `Administrador` o a l'usuari que desitges afegir al grup.

3. **Afegir a l'Usuari al Grup Familia Manager**:
   - Dins de la configuració de l'usuari, desplaçat a la secció de `Grups`.
   - Assegurat que el grup **Familia Manager** estiga seleccionat. Si no està, selecciona'l per a afegir a l'usuari a este grup.

### Importància del Grup Familia Manager

El grup **Familia Manager** és crucial per al funcionament del mòdul **Família** perquè atorga permisos per a:

- **Llegir**: Visualitzar registres de famílies i membres.
- **Escriure**: Modificar registres existents.
- **Crear**: Afegir nous registres de famílies i membres.
- **Eliminar**: Borrar registres de famílies i membres.

Sols els usuaris que formen part d'este grup tindran accés complet a les funcionalitats administratives del mòdul **Família**. Assegurat que l'usuari administrador estiga correctament assignat a este grup per a evitar problemes de permisos.

```bash
# Clone the repository into your addons directory
git https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gesti-_d_una_falla/tree/main/M%C3%B2duls%20Odoo/familia /ruta/a/odoo/addons/familia




familia/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   ├── familia.py
│   ├── miembro_familia.py
│   ├── res_partner_familia.py
├── migrations/
│   └── 10.0.1.0/
│       ├── post-migration.xml
├── views/
│   ├── familia_menu.xml
│   ├── familia_views.xml
│   ├── miembro_familia_views.xml

├── security/
│   ├── familia_security.xml
│   └── ir.model.access.csv
├── static/
│   └── description/
│       ├── icon.png
├── i18n/
│   └── ca.po
├── README.md
└── LICENSE
=======
```

```bash
# Clone the repository into your addons directory
git clone https://github.com/tu_usuario/tu_repositorio.git /ruta/a/odoo/addons/familia
```

## Dades del Mòdul

- **Nom**: Familia
- **Versió**: 1.0
- **Resum**: Gestiona clients com families i membres de la família.
- **Autor**: JB Talens
- **Categoria**: Sales
- **Imagens**: 
- **Dependencies**: `base`, `contacts`, `saldo_favor`
- **Dades incluïdes**:
  - `security/familia_security.xml`
  - `security/ir.model.access.csv`
  - `views/familia_views.xml`
  - `views/miembro_familia_views.xml`
  - `views/familia_menu.xml`
- **Instal·lable**: True
- **Aplicació**: True
- **Auto Instal·lació**: False

## Contribucions

Les contribucions són benvingudes. Si tens idees per a millores, suggerències o trobes errors, per favor, obri un `issue` o envia un `pull request` en GitHub.
