/*
Fitxer per a copiar i pegar en una base de dades PostgreSQL
*/

-- Sols la primera vegada (comprova que no existeixen abans de crear-los si ho vas a executar múltiples vegades)
CREATE USER joel WITH PASSWORD '1234';
CREATE DATABASE gestio_falla;
GRANT ALL PRIVILEGES ON DATABASE gestio_falla TO joel;

-- Eliminar taules si existeixen
DROP TABLE IF EXISTS faller CASCADE;
DROP TABLE IF EXISTS familia CASCADE;
DROP TABLE IF EXISTS cobrador CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS ticket CASCADE;
DROP TABLE IF EXISTS producte CASCADE;

-- Crea la taula 'familia'
CREATE TABLE familia (
  id BIGSERIAL PRIMARY KEY,
  nom TEXT NOT NULL,
  saldo_total NUMERIC DEFAULT 0
);

INSERT INTO familia(id, nom)
VALUES 
(1,'Familia de Joel'),
(2,'Familia de Juan'); 

-- Crea la taula 'cobrador' 
CREATE TABLE cobrador (
  id BIGSERIAL PRIMARY KEY,
  rolCobrador TEXT NOT NULL CHECK (rolCobrador IN ('Cadires', 'Barra', 'Escudellar'))
);

INSERT INTO cobrador (rolCobrador)
VALUES 
('Cadires'),
('Escudellar'),
('Barra');

-- Crea la taula 'ticket'
CREATE TABLE ticket(
 id BIGSERIAL PRIMARY KEY NOT NULL,
 quantitat INT NOT NULL DEFAULT 1,
 preu NUMERIC(5,2) NOT NULL,
 maxim BOOLEAN NOT NULL DEFAULT FALSE 
);

INSERT INTO ticket (id, quantitat, preu, maxim)
VALUES (1, 20, 1.00, false);

-- Crea la taula 'faller'
CREATE TABLE faller (
  id BIGSERIAL PRIMARY KEY,
  nom TEXT NOT NULL,
  rol TEXT NOT NULL CHECK (rol IN ('Faller', 'Cobrador', 'Cap de familia', 'Administrador', 'SuperAdmin')),
  valorPulsera TEXT NOT NULL,
  imatgeUrl TEXT,
  teLimit BOOLEAN,
  llimit NUMERIC,
  saldo NUMERIC,
  familia_id BIGINT,
  cobrador_id BIGINT,
  estaLoguejat BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (familia_id) REFERENCES familia(id),
  FOREIGN KEY (cobrador_id) REFERENCES cobrador(id),
  CHECK (
    (rol = 'Cap de familia' AND teLimit = FALSE AND llimit IS NULL)
    OR
    (rol != 'Cap de familia' AND (
      (teLimit = TRUE AND llimit IS NOT NULL) OR
      (teLimit = FALSE AND llimit IS NULL)
    ))
  ),
  CHECK (
    rol != 'Cobrador' OR cobrador_id IS NOT NULL
  )
);

-- Insertar fallers AMB familia i foto de perfil
INSERT INTO faller (nom, rol, cobrador_id, valorPulsera, imatgeUrl, teLimit, llimit, saldo, familia_id, estaLoguejat) 
VALUES 
('Joel', 'SuperAdmin', 3, '8430001000017', '/img/Perfil/perfil.jpg', false, NULL, 50.0, 1, false);
INSERT INTO faller (nom, rol, valorPulsera, teLimit, llimit, saldo, familia_id, estaLoguejat) 
VALUES
('Juan', 'Administrador', '2', false, NULL, 500.0, 2, false),
('Alexis', 'Faller', '3', true, 25.0, 20.0, 1, false);

-- Insertar fallers SENSE familia
INSERT INTO faller (nom, rol, valorPulsera, teLimit, llimit, saldo, estaLoguejat)
VALUES ('José', 'Faller', '7', false, NULL, 200.0, false);

-- Insertar fallers amb rols de cobrador
INSERT INTO faller (nom, rol, cobrador_id, valorPulsera, teLimit, llimit, saldo, estaLoguejat)
VALUES 
('José Maria', 'Cobrador', 1, '4', false, NULL, 25.0, true),
('Maria José', 'Cobrador', 2, '5', false, NULL, 55.5, true),
('Josefina', 'Cobrador', 3, '6', false, NULL, 114.0, true);

-- Crea la taula 'producte'
CREATE TABLE producte(
 id BIGSERIAL PRIMARY KEY,
 nom TEXT NOT NULL,
 preu NUMERIC(5,2) NOT NULL,
 stock INTEGER NOT NULL,
 urlImatge TEXT,
 eventEspecific BOOLEAN DEFAULT FALSE
);

INSERT INTO producte (nom, preu, stock, urlImatge)
VALUES
('Aigua 500ml', 1.00, 20, 'img/Productes/Aigua.png'),
('Cervesa 33cl', 1.50, 33, 'img/Productes/Cervesa.png'),
('Coca-Cola', 1.30, 0, 'img/Productes/Coca-Cola.png'),
('Pepsi', 1.25, 77, 'img/Productes/Pepsi.png');

INSERT INTO producte (nom, preu, stock, urlImatge, eventEspecific)
VALUES
('Paella', 3.75, 50, 'img/Events/Paella.png', true);

-- Crea la taula 'events'
CREATE TABLE events(
  id BIGSERIAL PRIMARY KEY,
  nom TEXT NOT NULL,
  descripcio TEXT DEFAULT 'No hi ha descripció per a este event',
  ticket_id BIGINT,
  numCadires INT NOT NULL,
  dataInici TIMESTAMP,
  dataFi TIMESTAMP,
  urlImatge TEXT,
  prodEspecific BOOLEAN NOT NULL,
  producte_id BIGINT,
  FOREIGN KEY (producte_id) REFERENCES producte(id),
  FOREIGN KEY (ticket_id) REFERENCES ticket(id)
);

-- Insertar events sense tickets
INSERT INTO events (nom, dataInici, dataFi, numCadires, urlImatge, prodEspecific)
VALUES 
('Cremà', '2025-03-20 20:00:00', '2025-03-21 02:00:00',10,'/img/Events/Cremà.png', false),
('Jocs', '2025-03-15 09:00:00', '2025-03-16 19:00:00',10,'/img/Events/Castell_unflable.png', false),
('Despedida', '2025-03-19 16:00:00', '2025-03-19 18:00:00',10,'/img/Events/Despedida.png', false),
('Caminata', '2025-03-19 16:00:00', '2025-03-19 18:00:00',10,'/img/Events/Despedida.png', false);

-- Insertar events AMB tickets
INSERT INTO events (nom, dataInici, dataFi, numCadires, ticket_id, urlImatge, prodEspecific, producte_id)
VALUES ('Paella', '2025-03-16 14:00:00', '2025-03-16 17:00:00',10, 1, '/img/Events/Paella.png', true, 5);

-- Vista per obtenir famílies amb membres (fallers)
CREATE OR REPLACE VIEW familias_amb_fallers AS
SELECT 
  fam.id AS familia_id,
  fam.nom AS familia_nom,
  COALESCE(ARRAY_AGG(f.nom) FILTER (WHERE f.nom IS NOT NULL), ARRAY[]::text[]) AS membres
FROM familia fam
LEFT JOIN faller f ON f.familia_id = fam.id
GROUP BY fam.id, fam.nom
ORDER BY fam.nom;

-- GRANT després de crear les taules i seqüències
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO joel;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO joel;

-- Crear vista membres que mostra les famílies amb la llista de fallers (membres)
CREATE OR REPLACE VIEW membres AS
SELECT 
  fam.*,
  COALESCE(ARRAY_AGG(f.nom) FILTER (WHERE f.nom IS NOT NULL), ARRAY[]::text[]) AS membres
FROM familia fam
LEFT JOIN faller f ON f.familia_id = fam.id
GROUP BY fam.id;
