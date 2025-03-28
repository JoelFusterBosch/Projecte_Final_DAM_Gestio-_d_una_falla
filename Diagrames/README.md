# Diagrames de casos d'ús i de classes en Umbrello
## Com instal·lar `Umbrello UML`
- Linux:
 - ```plaintext
   sudo apt install umbrello
   ```
- Windows:
 - Aneu a la següent url https://download.kde.org/stable/umbrello/latest/ i vos descarregeu el que cregeu que siga el vostre sistema i després vos descarregeu el que tinga la extensió .exe:
 <img src="../static/description/Diagrames casos d_ús i classes/Rama de directoris per a instal·lar umbrello.png"><br>
 <img src="../static/description/Diagrames casos d_ús i classes/Executable.png"><br>
I quan ja tingau instal·lat `Umbrello UML` obris el xml del repositori i s'obrira amb tots els diagrames.<br>
<img src="../static/description/Diagrames casos d_ús i classes/Diagrama de casos d_ús.png"><br>
<img src="../static/description/Diagrames casos d_ús i classes/Diagrama de classes.png"><br>
## Informació dels diagrames
Té les classes:<br>
**Família:** 
- `ID_familia`
- `Nom_familia`
- `Saldo_total`
**Cap_de_familia:**
**Membre:**
- `ID_membre`
- `Nom_membre`
- `Saldo`
- `Es_cap`
- `Familia_que pertany`
**Begudes:**
- `ID_beguda`
- `Nom_beguda`
- `Preu_beguda`
- `Tipus_beguda`
**Menjar:**
- `ID_menjar`
- `Nom_menjar`
- `Preu_menjar`
- `Tipus_menjar`
**Cadires:**
- `ID_cadires`
- `Preu_cadires`
- `Tipus_cadires`
**Stock:**
- `Stock_cadires`
- `Stock_begudes`
- `Saldo_menjar`
