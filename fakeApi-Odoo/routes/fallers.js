const express = require('express');
const router = express.Router();
const pool = require('../db');

router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM faller');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora d'obtindre als fallers" });
  }
});

module.exports = router;
