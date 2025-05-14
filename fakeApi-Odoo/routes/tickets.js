const express = require('express');
const router = express.Router();
const pool = require('../db');

router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM ticket');
    res.json(result.rows);
  } catch (err) {
    console.error('Error al obtindre tickets:', err);
    res.status(500).json({ error: "Error a l'hora d'obtindre els tickets" });
  }
});

module.exports = router;
