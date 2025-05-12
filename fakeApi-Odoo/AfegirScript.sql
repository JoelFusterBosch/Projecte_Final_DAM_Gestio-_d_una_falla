/*
Fitxer per a copiar i pegar en una base de dades PostgresSQL
*/
-- Eliminar taules si existeixen
DROP TABLE IF EXISTS faller CASCADE;
DROP TABLE IF EXISTS familia CASCADE;
DROP TABLE IF EXISTS cobrador CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS ticket CASCADE

-- Crea la taula 'familia'
CREATE TABLE familia (
  id BIGSERIAL PRIMARY KEY,
  nom TEXT NOT NULL,
  saldo_total NUMERIC
  
);

-- Crea la taula 'cobrador' 
CREATE TABLE cobrador (
  id BIGSERIAL PRIMARY KEY,
  rolCobrador TEXT NOT NULL CHECK (rolCobrador IN ('Cadires', 'Barra', 'Escudellar'))
);

-- Insertar un exemple
INSERT INTO cobrador (rolCobrador)
VALUES ('Cadires');
VALUES ('Escudellar');
VALUES ('Barra');

-- Crea la taula 'faller'
CREATE TABLE faller (
  id BIGSERIAL PRIMARY KEY,
  nom TEXT NOT NULL,
  rol TEXT NOT NULL CHECK (rol IN ('Faller', 'Cobrador', 'Cap de familia', 'Administrador', 'SuperAdmin')),
  valorPulsera TEXT NOT NULL,

  teLimit BOOLEAN,
  limit NUMERIC,
  CHECK (
    -- Si es Cap de familia → teLimit = false i limit = NULL
    (rol = 'Cap de familia' AND teLimit = FALSE AND limit IS NULL)

    OR

    -- Si no es Cap de familia → validar relació entre teLimit y limit
    (rol != 'Cap de familia' AND (
      (teLimit = TRUE AND limit IS NOT NULL) OR
      (teLimit = FALSE AND limit IS NULL)
    ))
  )

  saldo NUMERIC,

  familia_id BIGINT,
  cobrador_id BIGINT,
  FOREIGN KEY (familia_id) REFERENCES familia(id),
  FOREIGN KEY (cobrador_id) REFERENCES cobrador(id),

  -- Condició: si el rol es 'Cobrador', cobrador_id deu ser NOT NULL
  CHECK (
    rol != 'Cobrador' OR cobrador_id IS NOT NULL
  )
);


-- Insertar un exemple
INSERT INTO faller (nom, rol, valorPulsera, teLimit, limit, saldo) 
VALUES ('Joel', 'Faller', '1', true, 100.0, 50.0);
VALUES ('Juan', 'Administrador', '2', false, NULL, 500.0);
VALUES ('Alexis', 'Faller', '3', true, 25.0, 20.0);

INSERT INTO faller (nom, rol, cobrador_id, valorPulsera, teLimit, limit, saldo)
VALUES ('José Maria', 'Cobrador', 1, '4', false, NULL, 25.0);
VALUES ('Maria José', 'Cobrador', 2, '5', false, NULL, 55.5);
VALUES ('Josefina', 'Cobrador', 3, '6', false, NULL, 114.0)

-- Crea la taula 'events'
CREATE TABLE events(
  nom TEXT NOT NULL,
  ticket_id BIGINT,
  dataInici TEXT,
  dataFi TIMESTAMP,
  urlImatge TIMESTAMP,
  FOREIGN KEY (ticket_id) REFERENCES ticket(id)
);
INSERT INTO events (nom, dataInici, dataFi)
VALUES ('Paella', '2025-3-16 14:00:00', '2025-3-16 17:00:00');
VALUES ('Cremà', '2025-3-20 20:00:00', '2025-3-21 2:00:00');
VALUES ('Jocs', '2025-3-15 9:00:00', '2025-3-16 19:00:00');
VALUES ('Despedida', '2025-3-19 16:00:00', '2025-3-19 18:00:00');
VALUES ('Caminata', '2025-3-19 16:00:00', '2025-3-19 18:00:00');

-- Crea la taula 'ticket'
CREATE TABLE ticket(
 id BIGSERIAL PRIMARY KEY NOT NULL,
 quantitat INT,
 preu BIGINT NOT NULL,
 maxim BOOLEAN NOT NULL 
);
SELECT *, (quantitat=0) AS maxim FROM ticket
INSERT INTO ticket (quantitat, preu, maxim)
VALUES (0, 1000, (0 = 0));
VALUES (20, 1, (20=0));
