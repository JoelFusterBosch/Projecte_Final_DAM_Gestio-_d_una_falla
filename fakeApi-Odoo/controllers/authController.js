const pool = require('../db');

const verificarUsuari = async (req, res) => {
  const { nom, valorPulsera } = req.body;

  try {
    const result = await pool.query(
      'SELECT * FROM faller WHERE nom = $1 AND valorpulsera = $2',
      [nom, valorPulsera]
    );

    if (result.rows.length > 0) {
      res.status(200).json({ faller: result.rows[0] });
    } else {
      res.status(401).json({ error: 'Nom o pulsera incorrectes' });
    }
  } catch (err) {
    console.error('Error verificant:', err);
    res.status(500).json({ error: 'Error intern del servidor' });
  }
};

module.exports = { verificarUsuari };
