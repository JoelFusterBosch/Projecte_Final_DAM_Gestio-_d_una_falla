# Projecte_Final_DAM_Gestió-_d_una_falla
# Memòria del projecte

## 1. Introducció

Aquest projecte naix com a resultat final del cicle formatiu de Desenvolupament d'Aplicacions Multiplataforma. Té com a objectiu aplicar tots els coneixements adquirits durant aquests dos anys, combinant el desenvolupament d'una aplicació mòbil amb la connexió a una base de dades, API REST i tecnologia NFC/QR.

## 2. Tecnologies utilitzades

### 2.1 Entorn de desenvolupament

- **Flutter**: framework per al desenvolupament d'aplicacions multiplataforma.
- **Visual Studio Code**: entorn de programació utilitzat.
- **PostgreSQL**: base de dades relacional.
- **Node.js + Express**: servidor backend amb API REST.
- **GitHub**: repositori per al codi font.
- **Figma**: prototipat de la interfície.
- **Draw.io**: creació de diagrames tècnics.

## 3. Disseny de la solució

### 3.1 Anàlisi de possibles solucions

#### 3.1.1 Plataformes de programació

##### 3.1.1.1 Solucions natives

**Avantatges:**
- Accés directe al hardware.
- Alta compatibilitat.
- Millor rendiment.

**Desavantatges:**
- Cal aprendre diversos llenguatges.
- Desenvolupament més lent.
- Més costós.

##### 3.1.1.2 Solucions multiplataforma

**Avantatges:**
- Un únic codi per a diverses plataformes.
- Compilació nativa.
- Aprenentatge ràpid.

**Desavantatges:**
- Dependència de plugins.
- Accés limitat al hardware.
- Proves més complicades.

#### 3.1.2 Persistència de dades

##### 3.1.2.1 Odoo

**Avantatges:**
- Interfície intuïtiva.
- Mòduls personalitzables.
- Versió gratuïta.

**Desavantatges:**
- Instal·lació complexa.
- Dificultat d'integració amb Flutter.

##### 3.1.2.2 Node.js + PostgreSQL

**Avantatges:**
- Totalment personalitzable.
- Escalable.
- Control complet.

**Desavantatges:**
- Més cost de desenvolupament.
- Requereix manteniment tècnic.
- Consum de temps alt.

### 3.2 Solució escollida

Es tria **Flutter** per al frontend i **Node.js + PostgreSQL** per al backend per l'eficiència, flexibilitat i domini de les tecnologies.

### 3.3 Prototips

#### 3.3.1 Prototip de baixa fidelitat

Primera versió de l’app amb idees inicials sobre login, NFC i pantalles bàsiques. Sense divisió de rols.

#### 3.3.2 Prototip d'alta fidelitat

Dissenyat en **Figma**, amb:

- Separació per rols (faller, cobrador, administrador).
- Eliminació de contrasenya.
- Disseny responsive i net.

## 4. Desenvolupament de la solució

### 4.1 Consideracions prèvies

- Desenvolupament únicament per a Android per limitació de dispositius.
- Elecció de Flutter per coneixement previ.
- API pròpia per major control.
- Arquitectura CLEAN.
- Prototipat previ.
- Rols des del principi com a base de la interfície.

### 4.2 Arquitectura CLEAN

El projecte segueix el patró **CLEAN architecture** dividint el codi en:

- `lib/presentation/`: Vista i interfície.
- `lib/domain/`: Models i cas d’ús.
- `lib/data/`: Accés a dades.

Separació clara de responsabilitats i escalabilitat futura.

### 4.3 API REST

Rutes implementades al backend:

- `GET /fallers`
- `POST /fallers`
- `GET /productes`
- `POST /productes`
- `GET /events`
- `POST /events`
- `GET /tickets`
- `POST /tickets`
- `POST /cobrador/validar`

Respostes en format JSON. Validacions bàsiques a nivell de backend.

### 4.4 Funcionalitats segons el rol

#### Faller

- Consulta d’esdeveniments.
- Consulta del perfil.

#### Cobrador

- Lector NFC.
- Lector de codi QR.
- Validació de pagament.

#### Administrador

- Alta i baixa d’usuaris.
- Gestió d’esdeveniments i productes.
- Consulta d’estadístiques.

### 4.5 NFC i codi QR

- El sistema detecta si s'ha llegit una polsera NFC o escanejat un QR.
- L’enllaç porta l’usuari a la pàgina de validació si tot és correcte.

## 5. Proves i desplegament

### 5.1 Proves manuals

- Proves amb diversos escenaris d'usuari.
- Validació de funcionalitats bàsiques per rol.

### 5.2 Proves d'integració

- API provada amb Postman.
- Validació de respostes, errors i dades mal formades.

### 5.3 Desplegament

Backend desplegat en un servidor Linux amb IP pública.

- PostgreSQL configurat.
- API funcional en port 3000.
- Aplicació usable des de qualsevol dispositiu Android.

## 6. Conclusions

Aquest projecte ha suposat un repte personal i tècnic. He aplicat coneixements de tot el cicle: disseny, programació, APIs, gestió de dades, desplegament i validació. També he après a buscar solucions quan he tingut problemes.

## 7. Millores futures

- Afegir autenticació JWT.
- Aplicar testos automatitzats.
- Desplegament automatitzat.
- Millorar l’accessibilitat i disseny UI.
- Adaptació a iOS.

## 8. Annexos

### 8.1 Repositori GitHub

[https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gestio-_d_una_falla](https://github.com/JoelFusterBosch/Projecte_Final_DAM_Gestio-_d_una_falla)

### 8.2 Prototips Figma

Enllaç a prototip: *[Afegir si és públic]*

### 8.3 Diagrames visuals

- Arquitectura CLEAN
- Diagrama de rutes API
- (Opcional: E/R base de dades)

### 8.4 Tancament personal

Aquest projecte és una mostra del meu progrés durant els dos anys de cicle. M’he superat en molts aspectes i he consolidat la meua vocació per la programació. Independentment de la nota, estic orgullós del que he aconseguit.


