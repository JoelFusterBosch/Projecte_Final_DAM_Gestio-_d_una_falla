const express = require('express');
const router = express.Router();
const pool = require('../db');

/*
  GET - Tots els events amb info detallada, inclòs producte i ticket (si n'hi ha)
*/
router.get('/', async (req, res) => {
  try {
    const query = `
      SELECT
        e.id, e.nom, e.descripcio, e.numcadires, e.datainici, e.datafi, e.urlimatge, e.prodespecific,
        p.id AS producte_id, p.nom AS producte_nom, p.preu AS producte_preu,
        t.id AS ticket_id, t.preu AS ticket_preu, t.quantitat AS ticket_quantitat, t.maxim AS ticket_maxim
      FROM events e
      LEFT JOIN producte p ON e.producte_id = p.id
      LEFT JOIN ticket t ON e.ticket_id = t.id
      ORDER BY e.datainici DESC
    `;
    const result = await pool.query(query);

    // Mappejar cada fila a un objecte amb estructura clara
    const events = result.rows.map(row => ({
      id: row.id,
      nom: row.nom,
      descripcio: row.descripcio,
      numcadires: row.numcadires,
      datainici: row.datainici,
      datafi: row.datafi,
      urlimatge: row.urlimatge,
      prodespecific: row.prodespecific,
      producte: row.producte_id ? {
        id: row.producte_id,
        nom: row.producte_nom,
        preu: row.producte_preu
      } : null,
      ticket: row.ticket_id ? {
        id: row.ticket_id,
        preu: row.ticket_preu,
        quantitat: row.ticket_quantitat,
        maxim: row.ticket_maxim
      } : null
    }));

    res.json(events);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error a l'hora d'obtindre els events" });
  }
});
/*
  POST - Insertar un event (sense producte ni ticket per ara)
*/
router.post('/insertar', async (req, res) => {
  const { nom, dataInici, dataFi, descripcio} = req.body;
  try {
    const query = `
      INSERT INTO events (nom, datainici, datafi, descripcio)
      VALUES ($1,$2,$3,$4)
      RETURNING *
    `;
    const values = [nom, dataInici, dataFi, descripcio];
    const result = await pool.query(query, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error a l'hora d'insertar un event" });
  }
});

/*
  DELETE - Borrar un event per nom (pot ser millor per id, però deixo com a tu)
*/
router.delete('/borrar/:nom', async (req, res) => {
  const { nom } = req.params;
  try {
    const result = await pool.query('DELETE FROM events WHERE nom = $1 RETURNING *', [nom]);
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Event no trobat per borrar' });
    }
    res.json({ missatge: "Event borrat", event: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error a l'hora de borrar un event" });
  }
});

module.exports = router;
