# Diagrames de casos d'ús i de classes en Umbrello
## Com instal·lar `Umbrello UML`
- Linux:
  - ```plaintext
    sudo apt install umbrello
    ```
- Windows:
  - Aneu a la següent url https://download.kde.org/stable/umbrello/latest/ i us descarregueu el que cregueu que siga els bits del processador del vostre sistema i després us descarregueu el que tinga la extensió .exe:
 <img src="../static/description/Diagrames casos d_ús i classes/Rama de directoris per a instal·lar umbrello.png"><br>
 <img src="../static/description/Diagrames casos d_ús i classes/Executable.png"><br>
I quan ja tingau instal·lat `Umbrello UML` obri el xml del repositori i s'obrira amb tots els diagrames.<br>
<img src="../static/description/Diagrames casos d_ús i classes/Diagrama de casos d_ús.png"><br>
<img src="../static/description/Diagrames casos d_ús i classes/Diagrama de classes.png"><br>
## Informació dels diagrames
Estes són les classes amb els següents atributs:<br>
- **Família:** 
  - `ID_familia`
  - `Nom_familia`
  - `Saldo_total`<br>
- **Cap_de_familia:**<br>
  - `Administrar saldo`<br>
- **Membre:**<br>
  - `ID_membre`
  - `Nom_membre`
  - `Saldo`
  - `Es_cap`
  - `Familia_que_pertany`<br>
- **Begudes:**<br>
  - `ID_beguda`
  - `Nom_beguda`
  - `Preu_beguda`
  - `Tipus_beguda`<br>
- **Menjar:**<br>
  - `ID_menjar`
  - `Nom_menjar`
  - `Preu_menjar`
  - `Tipus_menjar`<br>
- **Cadires:**<br>
  - `ID_cadires`
  - `Preu_cadires`
  - `Tipus_cadires`<br>
- **Stock:**<br>
  - `Stock_cadires`
  - `Stock_begudes`
  - `Stock_menjar`<br>
