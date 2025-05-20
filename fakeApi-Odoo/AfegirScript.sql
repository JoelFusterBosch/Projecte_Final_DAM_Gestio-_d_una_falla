/*
Fitxer per a copiar i pegar en una base de dades PostgresSQL
*/

-- Sols la primera vegada (comprova que no existeixen abans de crear-los si ho vas a executar múltiples vegades)
CREATE USER joel WITH PASSWORD '1234';
CREATE DATABASE gestio_falla;
GRANT ALL PRIVILEGES ON DATABASE gestio_falla TO joel;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO joel;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO joel;

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
  saldo_total NUMERIC
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
 quantitat INT NOT NULL,
 preu BIGINT NOT NULL,
 maxim BOOLEAN NOT NULL 
);

INSERT INTO ticket (id, quantitat, preu, maxim)
VALUES (1, 20, 1, false);

-- Crea la taula 'events'
CREATE TABLE events(
  id BIGSERIAL PRIMARY KEY,
  nom TEXT NOT NULL,
  descripcio TEXT,
  ticket_id BIGINT,
  dataInici TIMESTAMP,
  dataFi TIMESTAMP,
  urlImatge TEXT,
  FOREIGN KEY (ticket_id) REFERENCES ticket(id)
);

--Insertar events sense tickets
INSERT INTO events (nom, dataInici, dataFi, urlImatge)
VALUES 
('Cremà', '2025-03-20 20:00:00', '2025-03-21 02:00:00','/img/Events/Cremà.png'),
('Jocs', '2025-03-15 09:00:00', '2025-03-16 19:00:00','/img/Events/Castell_unflable.png'),
('Despedida', '2025-03-19 16:00:00', '2025-03-19 18:00:00','/img/Events/Despedida.png'),
('Caminata', '2025-03-19 16:00:00', '2025-03-19 18:00:00','/img/Events/Despedida.png');

--Insertar events AMB tickets
INSERT INTO events (nom, dataInici, dataFi, ticket_id, urlImatge)
VALUES ('Paella', '2025-03-16 14:00:00', '2025-03-16 17:00:00', 1, '/img/Events/Paella.png');

-- Crea la taula 'faller'
CREATE TABLE faller (
  id BIGSERIAL PRIMARY KEY,
  nom TEXT NOT NULL,
  rol TEXT NOT NULL CHECK (rol IN ('Faller', 'Cobrador', 'Cap de familia', 'Administrador', 'SuperAdmin')),
  valorPulsera TEXT NOT NULL,

  teLimit BOOLEAN,
  llimit NUMERIC,
  CHECK (
    (rol = 'Cap de familia' AND teLimit = FALSE AND llimit IS NULL)
    OR
    (rol != 'Cap de familia' AND (
      (teLimit = TRUE AND llimit IS NOT NULL) OR
      (teLimit = FALSE AND llimit IS NULL)
    ))
  ),

  saldo NUMERIC,

  familia_id BIGINT,
  cobrador_id BIGINT,
  FOREIGN KEY (familia_id) REFERENCES familia(id),
  FOREIGN KEY (cobrador_id) REFERENCES cobrador(id),

  CHECK (
    rol != 'Cobrador' OR cobrador_id IS NOT NULL
  )
);

-- Insertar fallers AMB familia
INSERT INTO faller (nom, rol, valorPulsera, teLimit, llimit, saldo, familia_id) 
VALUES 
('Joel', 'SuperAdmin', '1', false, NULL, 50.0, 1),
('Juan', 'Administrador', '2', false, NULL, 500.0, 2),
('Alexis', 'Faller', '3', true, 25.0, 20.0, 1);

--Insertar fallers SENSE familia
INSERT INTO faller (nom, rol, valorPulsera, teLimit, llimit, saldo)
VALUES ('José', 'Faller', '7', false, NULL, 200.0);

--Insertar fallers amb rols de cobrador
INSERT INTO faller (nom, rol, cobrador_id, valorPulsera, teLimit, llimit, saldo)
VALUES 
('José Maria', 'Cobrador', 1, '4', false, NULL, 25.0),
('Maria José', 'Cobrador', 2, '5', false, NULL, 55.5),
('Josefina', 'Cobrador', 3, '6', false, NULL, 114.0);

-- Crea la taula 'producte'
CREATE TABLE producte(
 id BIGSERIAL PRIMARY KEY,
 nom TEXT NOT NULL,
 descripcio TEXT,
 preu BIGINT,
 stock INTEGER NOT NULL,
 urlImatge TEXT
);

INSERT INTO producte(nom,preu,stock,urlImatge)
VALUES
('Aigua 500ml', 1, 20, 'img/Productes/Aigua.png'),
('Cervesa 33cl', 1.5, 33, 'img/Productes/Cervesa.png'),
('Coca-Cola', 1.30, 0, 'img/Productes/Coca-Cola.png'),
('Pepsi', 1.25, 77, 'img/Productes/Pepsi.png');
