// routes/auth.js o controllers/authController.js

const express = require('express');
const router = express.Router();
const pool = require('../db'); // Tu conexión a la DB

// Verificación de usuario + pulsera
router.post('/verificar', async (req, res) => {
  const { nom, valorPulsera } = req.body;

  try {
    const result = await pool.query(
      'SELECT * FROM fallers WHERE nom = $1 AND valorPulsera = $2',
      [nom, valorPulsera]
    );

    if (result.rows.length > 0) {
      res.status(200).json({ valid: true });
    } else {
      res.status(401).json({ valid: false, message: 'Nom o pulsera incorrectes' });
    }
  } catch (err) {
    console.error('Error verificando:', err);
    res.status(500).json({ error: 'Error intern del servidor' });
  }
});

module.exports = router;
