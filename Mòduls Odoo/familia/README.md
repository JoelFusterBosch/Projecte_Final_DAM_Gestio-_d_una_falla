# Módulo de Odoo: Gestión de Familias

<p align="center">
  <img src="static/description/icon.png" alt="Icono del Módulo">
</p>

## Descripción

El módulo **Familia** para Odoo 16, desarrollado por **JB Talens**, permite gestionar clientes como unidades familiares, facilitando la administración de sus saldos y relaciones. Este módulo es ideal para negocios que manejan grupos de clientes como familias y requieren un control centralizado de los saldos familiares.

### Características principales

- **Gestión de Familias**: Agrupa a varios clientes como miembros de una familia, permitiendo la gestión conjunta de sus saldos.
- **Control de Saldo Total**: El saldo total de la familia se gestiona automáticamente, sumando el saldo de cada miembro al añadirse y ajustando el saldo al eliminar un miembro.
- **Restricciones de Membresía**: Un cliente solo puede pertenecer a una familia a la vez, garantizando la coherencia en la gestión de saldos.
- **Interfaz de Usuario Personalizada**: Incluye vistas y menús específicos para facilitar la gestión de familias y miembros dentro de Odoo.
- **Seguridad**: Configuración de seguridad específica para gestionar el acceso y los permisos dentro del módulo.

## Requisitos Previos

- **Odoo 16.0 o superior**
- **Módulos de CRM y Ventas**: Los módulos de CRM y ventas deben estar instalados.
- **Módulo saldo_favor**: Módulo personalizado para gestionar los saldos a favor de los clientes. Puedes encontrarlo en [saldo_favor](https://github.com/juatafe/saldo_favor).

## Instalación

Para instalar el módulo **Familia**, sigue estos pasos:

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/juatafe/familia.git


### Copiar el módulo en la carpeta de módulos de Odoo:

```bash
cp -R familia /ruta/a/odoo/addons/

```

## Actualizar la lista de aplicaciones

Ve a la interfaz de Odoo > `Apps` > `Actualizar la lista de módulos`.

## Instalar el módulo

Busca "Familia" en la lista de aplicaciones disponibles y haz clic en `Instalar`.

## Uso

### Configuración Inicial

- **Crear Familias**: Accede al menú `Familias` y crea nuevas familias.
- **Añadir Miembros**: Agrega miembros existentes (clientes) a las familias creadas.
- **Gestionar Saldos**: El saldo total de la familia se actualizará automáticamente al añadir nuevos miembros.

### Gestión de Familias

- **Ver Familias**: Consulta la lista de familias y sus detalles, incluidos los saldos y los miembros asociados.
- **Eliminar Miembros**: Al eliminar un miembro, su saldo se restablecerá a cero y se desvinculará de la familia.

## Seguridad

Este módulo incluye reglas de seguridad personalizadas definidas en:

- `security/familia_security.xml`
- `security/ir.model.access.csv`

Estas reglas controlan el acceso a las diferentes vistas y operaciones dentro del módulo, asegurando que solo los usuarios autorizados puedan gestionar familias y miembros.

En el módulo **Familia** de Odoo, se definen reglas de acceso y grupos de usuarios que controlan qué acciones pueden realizar ciertos usuarios en los modelos específicos del módulo. A continuación se explica cómo se configuran estos elementos.

### Grupos de Usuarios

Los grupos de usuarios en Odoo se utilizan para organizar y asignar permisos a los usuarios. En el módulo **Familia**, se ha creado un grupo específico llamado **Familia Manager**:

```xml
<record id="group_familia_manager" model="res.groups">
    <field name="name">Familia Manager</field>
    <field name="category_id" ref="base.module_category_sales"/>
</record>

```
### Grupo de Usuarios: Familia Manager

- **id**: `group_familia_manager` — Identificador único del grupo.
- **name**: `Familia Manager` — Nombre del grupo.
- **category_id**: `base.module_category_sales` — Categoría del grupo dentro de Odoo, en este caso se clasifica bajo la categoría de Ventas.

Este grupo se utilizará para asignar permisos específicos sobre los modelos del módulo **Familia**.

### Reglas de Acceso

Las reglas de acceso en Odoo determinan qué registros puede ver, crear, modificar o eliminar un usuario en un modelo específico. Aquí se muestran las reglas de acceso definidas para el módulo **Familia**.

#### Regla de Acceso para el Modelo `familia`


```xml
<record id="familia_familia_rule" model="ir.rule">
    <field name="name">Familia: ver todas</field>
    <field name="model_id" ref="familia.model_familia"/>
    <field name="groups" eval="[(4, ref('group_familia_manager'))]"/>
    <field name="domain_force">[(1, '=', 1)]</field>
</record>
```
- **id**: `familia_familia_rule` — Identificador único de la regla.
- **name**: `Familia: ver todas` — Nombre de la regla de acceso.
- **model_id**: `familia.model_familia` — Especifica que la regla se aplica al modelo `familia`.
- **groups**: `group_familia_manager` — Define que esta regla se aplica al grupo `Familia Manager`.
- **domain_force**: `[(1, '=', 1)]` — Permite el acceso a todos los registros del modelo `familia`.

Esta regla asegura que los usuarios del grupo **Familia Manager** puedan ver todos los registros del modelo `familia`.

#### Regla de Acceso para el Modelo `familia.miembro`

```xml
<record id="familia_miembro_rule" model="ir.rule">
    <field name="name">Miembro de Familia: ver todos</field>
    <field name="model_id" ref="familia.model_familia_miembro"/>
    <field name="groups" eval="[(4, ref('group_familia_manager'))]"/>
    <field name="domain_force">[(1, '=', 1)]</field>
</record>
```

- **id**: `familia_miembro_rule` — Identificador único de la regla.
- **name**: `Miembro de Familia: ver todos` — Nombre de la regla de acceso.
- **model_id**: `familia.model_familia_miembro` — Especifica que la regla se aplica al modelo `familia.miembro`.
- **groups**: `group_familia_manager` — Define que esta regla se aplica al grupo `Familia Manager`.
- **domain_force**: `[(1, '=', 1)]` — Permite el acceso a todos los registros del modelo `familia.miembro`.

Esta regla asegura que los usuarios del grupo **Familia Manager** puedan ver todos los registros del modelo `familia.miembro`.

### Accesos Definidos en el Archivo `ir.model.access.csv`

Además de las reglas de acceso, se definen permisos detallados en el archivo `ir.model.access.csv`:

```
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_familia_manager,familia.manager,familia.model_familia,group_familia_manager,1,1,1,1
access_miembro_familia_manager,miembro_familia.manager,familia.model_familia_miembro,group_familia_manager,1,1,1,1
access_miembro_familia_admin,miembro_familia.admin,familia.model_familia_miembro,base.group_system,1,1,1,1

```
- **access_familia_manager**: Permite al grupo `Familia Manager` leer, escribir, crear y eliminar registros en el modelo `familia`.
- **access_miembro_familia_manager**: Permite al grupo `Familia Manager` leer, escribir, crear y eliminar registros en el modelo `familia.miembro`.
- **access_miembro_familia_admin**: Permite al grupo de administración (`base.group_system`) realizar todas las operaciones en el modelo `familia.miembro`.

## Requisitos de Permisos

Para gestionar el módulo **Familia** correctamente, es necesario que el usuario administrador esté incluido en el grupo **Familia Manager**. Este grupo tiene permisos específicos que permiten la administración completa de las funcionalidades del módulo.

### Incluir al Usuario Administrador en el Grupo Familia Manager

1. **Accede a la Configuración de Usuarios**:
   - Ve a la interfaz de Odoo.
   - Navega a `Configuración` > `Usuarios y Compañías` > `Usuarios`.

2. **Selecciona el Usuario Administrador**:
   - Busca y selecciona el usuario `Administrador` o el usuario que desees añadir al grupo.

3. **Añadir el Usuario al Grupo Familia Manager**:
   - Dentro de la configuración del usuario, desplázate a la sección de `Grupos`.
   - Asegúrate de que el grupo **Familia Manager** esté seleccionado. Si no está, selecciónalo para añadir al usuario a este grupo.

### Importancia del Grupo Familia Manager

El grupo **Familia Manager** es crucial para el funcionamiento del módulo **Familia** porque otorga permisos para:

- **Leer**: Visualizar registros de familias y miembros.
- **Escribir**: Modificar registros existentes.
- **Crear**: Añadir nuevos registros de familias y miembros.
- **Eliminar**: Borrar registros de familias y miembros.

Solo los usuarios que formen parte de este grupo tendrán acceso completo a las funcionalidades administrativas del módulo **Familia**. Asegúrate de que el usuario administrador esté correctamente asignado a este grupo para evitar problemas de permisos.



## Datos del Módulo

- **Nombre**: Familia
- **Versión**: 1.0
- **Resumen**: Gestiona clientes como familias y miembros de la familia.
- **Autor**: JB Talens
- **Categoría**: Sales
- **Imágenes**: 
- **Dependencias**: `base`, `contacts`, `saldo_favor`
- **Datos incluidos**:
  - `security/familia_security.xml`
  - `security/ir.model.access.csv`
  - `views/familia_views.xml`
  - `views/miembro_familia_views.xml`
  - `views/familia_menu.xml`
- **Instalable**: True
- **Aplicación**: True
- **Auto Instalación**: False

## Contribuciones

Las contribuciones son bienvenidas. Si tienes ideas para mejoras, sugerencias o encuentras errores, por favor, abre un `issue` o envía un `pull request` en GitHub.
