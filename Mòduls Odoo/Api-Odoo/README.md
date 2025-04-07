# Api-Odoo

Este projecte permet interactuar amb l'API d'Odoo mitjançant XML-RPC. La següent documentació explica com generar una clau d'API al teu compte d'Odoo. Esta clau és necessària per a connectar eines externes a Odoo sense utilitzar una contrasenya.

---

## Compatibilitat

Este projecte ha estat provat amb Odoo 16.0.

---

## 1. Accedeix al teu perfil
Primer, inicia sessió al teu compte d'Odoo. Fes clic a la teua foto o icona de perfil al cantó superior dret i selecciona **"El meu perfil"**.

![El meu perfil](img/elmeuperfil.png)

---

## 2. Ves a la secció de seguretat del compte
Una vegada dins del teu perfil, selecciona la pestanya **"Seguretat del compte"**. Ací trobaràs l'opció per gestionar les teues claus d'API.

![Seguretat del compte](img/seguretat.png)

---

## 3. Crea una nova clau
Fes clic al botó **"Nova clau API"**. Apareixerà una finestra per a introduir una descripció de la clau.

![Nova clau](img/NomClau.png)

### 3.1. Escriu una descripció
Introdueix una descripció clara per a identificar l'ús de la clau. Per exemple: *"Clau per a la connexió API"*.

---

## 4. Confirma la contrasenya
Per motius de seguretat, hauràs d'introduir la teua contrasenya d'Odoo per a confirmar la creació de la clau.

![Confirma contrasenya](img/password.png)

---

## 5. Guarda la clau generada
Una vegada creada, Odoo et mostrarà la clau de l'API. **És important guardar-la en un lloc segur**, ja que no es podrà recuperar més endavant. Utilitza aquesta clau en lloc de la teua contrasenya per a accedir a l'API d'Odoo.

![Clau generada](img/NovaClauCreada.png)

---

## 6. Visualitza les claus existents
Pots veure totes les claus creades a la secció **"Claus API"** del teu perfil. Des d'ací també pots suprimir les claus que ja no necessites.

![Gestió de claus](img/clausAPi.png)

---

## Notes finals
- Utilitza la clau API per a connexions segures.
- No compartisques la teua clau amb altres persones.
- En cas de compromís, elimina la clau immediatament i genera una nova.


## Configuració

Assegurat de configurar correctament el fitxer `config.yml` amb les dades de connexió adequades per als entorns de producció i desenvolupament.
```yaml
production:    
    connection:
        url: http://localhost o http://IPMàquinaVirtual # localhost si Odoo està en la mateixa màquina i IP de la màquina virtual si està en un sistema diferent.
        port: 8069 # Port de l'Odoo
        db: nom_bd # Nom de la base de dades a través del següent enllaç 
        user: usuari # Correu electrònic configurat a l'usuari administrador d'Odoo
        password: **********47d1e3ac55********** # Api generada de l'Odoo

development:    
    connection:
        url: http://localhost o http://IPMàquinaVirtual # localhost si Odoo està en la mateixa màquina i IP de la màquina virtual si està en un sistema diferent.
        port: 8069 # Port del Odoo
        db: nom_bd # Nom de la base de dades a través del següent enllaç 
        user: usuari # Correu electrònic configurat a l'usuari administrador d'Odoo
        password: **********47d1e3ac55********** # Api generada de l'Odoo
```
## Obtindre la IP de la màquina virtual
- Si no saps o si no recordes de la IP de la teua màquina virtual executa el següent:
  ```plaintext
  ip a
  ``` 
## Obtindre el nom de la base de dades

Si no recordes el nom de la teua base de dades, pots trobar-lo a la secció de configuració del teu compte d'Odoo. Pots accedir a la pàgina de gestió de bases de dades d'Odoo per veure totes les bases de dades disponibles. Ves a la següent URL i inicia sessió si és necessari:

- Si el teu domini és `http://localhost:NumPort` o `http://IPMàquinaVirtual:NumPort`, l'URL completa serà:
  ```plaintext
  http://localhost:8069/web/database/manager
  ```
  Això si és en localhost, però si és en la IP de la màquina virtual:
  ```plaintext
  http://IPMàquinaVirtual:8069/web/database/manager
  ```
---
## Obtindre el correu
Si no et recordes del correu electrònic pel motiu que siga fixat en esta icona<img src="../Api-Odoo/img/icona.png" alt="Icona"/> i prems on diu `Contactes` i veuràs el següent:
<img src="../Api-Odoo/img/PantallaContactes.png" alt="Pantalla de contactes"/><br>
I allí seleccionaràs al usuari administrador:<br>
<img src="../Api-Odoo/img/UsuariAdmin.png"><br>
Quan el selecciones veuràs el següent:
<img src="../Api-Odoo/img/PantallaUsuariAdmin.png"><br>
I ens fixarem on diu `Correu electrònic`, si té valor ja hem acabat, si no posa-li un correu electrònic.<br>
<img src="../Api-Odoo/img/CorreuElectrònic.png">

## Configuració de l'entorn

El fitxer `main.py` està configurat per defecte per a utilitzar l'entorn de producció. Si vols usar l'entorn de desenvolupament, has de canviar la variable `env` a `development`.

### Canviar l'entorn

1. Obri el fitxer `main.py`.
2. Busca la línia següent:
   ```python
   env = "production"  # Canviar a 'development' per a entorns locals
   ```
3. Canvia "production" a "development": 
   ```python
   env = "development"  # Canviar a 'production' per a entorns en producció
   ```
Això farà que el script utilitze les propietats de connexió definides per a l'entorn de desenvolupament en el fitxer config.yml.

## Executar el script

Per a executar el script `main.py`, assegurat d'estar en un entorn de Python 3.5 o superior. Pots seguir estos passos:

1. Instal·la les dependències necessàries:
   ```sh
   pip install pyyaml
   ```
2. Executa el script:
   ```sh
   python3 main.py
   ```

Això llegirà les propietats de connexió des del fitxer `config.yml` i construirà l'URL base per a XML-RPC.

## Contribuir

Si vols contribuir a este projecte, si us plau, fes un fork del repositori i envia una pull request amb les teues millores.

## Llicència

Este projecte està llicenciat baix la [Llicència MIT](LICENSE).