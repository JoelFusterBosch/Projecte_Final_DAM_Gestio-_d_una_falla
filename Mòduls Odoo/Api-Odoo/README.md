# Api-Odoo

Aquest projecte permet interactuar amb l'API d'Odoo mitjançant XML-RPC. La següent documentació explica com generar una clau d'API al teu compte d'Odoo. Aquesta clau és necessària per connectar eines externes a Odoo sense utilitzar una contrasenya.

---

## Compatibilitat

Aquest projecte ha estat provat amb Odoo 16.0.

---

## 1. Accedeix al teu perfil
Primer, inicia sessió al teu compte d'Odoo. Fes clic a la teva foto o icona de perfil a la cantonada superior dreta i selecciona **"El meu perfil"**.

![El meu perfil](img/elmeuperfil.png)

---

## 2. Ves a la secció de seguretat del compte
Un cop dins del teu perfil, selecciona la pestanya **"Seguretat del compte"**. Aquí trobaràs l'opció per gestionar les teves claus d'API.

![Seguretat del compte](img/seguretat.png)

---

## 3. Crea una nova clau
Fes clic al botó **"Nova clau API"**. Apareixerà una finestra per introduir una descripció de la clau.

![Nova clau](img/NomClau.png)

### 3.1. Escriu una descripció
Introdueix una descripció clara per identificar l'ús de la clau. Per exemple: *"Clau per a connexió API"*.

---

## 4. Confirma la contrasenya
Per motius de seguretat, hauràs d'introduir la teva contrasenya d'Odoo per confirmar la creació de la clau.

![Confirma contrasenya](img/password.png)

---

## 5. Guarda la clau generada
Un cop creada, Odoo et mostrarà la clau d'API. **És important guardar-la en un lloc segur**, ja que no es podrà recuperar més endavant. Utilitza aquesta clau en lloc de la teva contrasenya per accedir a l'API d'Odoo.

![Clau generada](img/NovaClauCreada.png)

---

## 6. Visualitza les claus existents
Pots veure totes les claus creades a la secció **"Claus API"** del teu perfil. Des d'aquí també pots suprimir les claus que ja no necessitis.

![Gestió de claus](img/clausAPi.png)

---

## Notes finals
- Utilitza la clau API per a connexions segures.
- No comparteixis la teva clau amb altres persones.
- En cas de compromís, elimina la clau immediatament i genera una de nova.


## Configuració

Assegura't de configurar correctament el fitxer `config.yml` amb les dades de connexió adequades per als entorns de producció i desenvolupament.
```yaml
production:    
    connection:
        url: https://dominiodoo.es
        port: 443
        db: nom_bd
        user: usuari
        password: **********47d1e3ac55**********

development:    
    connection:
        url: http://localhost
        port: 8069
        db: nom_bd
        user: usuari
        password: **********47d1e3ac55**********
```
## Obtenir el nom de la base de dades

Si no recordes el nom de la teva base de dades, pots trobar-lo a la secció de configuració del teu compte d'Odoo. Pots accedir a la pàgina de gestió de bases de dades d'Odoo per veure totes les bases de dades disponibles. Ves a la següent URL i inicia sessió si és necessari:

- Si el teu domini és `https://www.dominiodoo.es`, l'URL completa serà:
  ```plaintext
  https://www.dominiodoo.es/web/database/manager
  ```
---

## Configuració de l'entorn

El fitxer `main.py` està configurat per defecte per utilitzar l'entorn de producció. Si vols utilitzar l'entorn de desenvolupament, has de canviar la variable `env` a `development`.

### Canviar l'entorn

1. Obre el fitxer `main.py`.
2. Cerca la línia següent:
   ```python
   env = "production"  # Canviar a 'development' per a entorns locals
   ```
3. Canvia "production" a "development": 
   ```python
   env = "development"  # Canviar a 'production' per a entorns en producció
   ```
Això farà que el script utilitze les propietats de connexió definides per a l'entorn de desenvolupament en el fitxer config.yml.

## Executar el script

Per executar el script `main.py`, assegura't d'estar en un entorn Python 3.5 o superior. Pots seguir aquests passos:

1. Instal·la les dependències necessàries:
   ```sh
   pip install pyyaml
   ```
2. Executa el script:
   ```sh
   python3 main.py
   ```

Això llegirà les propietats de connexió des del fitxer `config.yml` i construirà la URL base per a XML-RPC.

## Contribuir

Si vols contribuir a aquest projecte, si us plau, fes un fork del repositori i envia una pull request amb les teves millores.

## Llicència

Aquest projecte està llicenciat sota la [Llicència MIT](LICENSE).