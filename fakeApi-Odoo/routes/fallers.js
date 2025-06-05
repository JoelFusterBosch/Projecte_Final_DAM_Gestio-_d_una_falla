const express = require('express');
const router = express.Router();
const pool = require('../db');

/*
Funcions amb GET
*/

// Get bàsic, sense filtrar per família (retorna tots els fallers)
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        f.id, f.nom, f.telimit, f.llimit, f.saldo,
        f.rol, f.valorpulsera, f.estaloguejat, f.imatgeurl,
        fam.id AS familia_id, fam.nom AS familia_nom, fam.saldo_total,
        cob.id AS cobrador_id, cob.rolcobrador AS cobrador_rol
      FROM faller f
      LEFT JOIN familia fam ON f.familia_id = fam.id
      LEFT JOIN cobrador cob ON f.cobrador_id = cob.id
    `);

    const fallers = result.rows.map(row => ({
      id: row.id,
      nom: row.nom,
      telimit: row.telimit,
      llimit: row.llimit,
      saldo: parseFloat(row.saldo) || 0,
      rol: row.rol,
      valorpulsera: row.valorpulsera,
      estaloguejat: row.estaloguejat,
      imatgeurl: row.imatgeurl,
      familia: row.familia_id ? {
        id: row.familia_id,
        nom: row.familia_nom,
        saldoTotal: row.saldo_total,
        membres: null
      } : null,
      cobrador: row.cobrador_id ? {
        id: row.cobrador_id,
        rol: row.cobrador_rol
      } : null
    }));

    res.json(fallers);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error a l'hora d'obtenir els fallers" });
  }
});


// Get faller per id (perfil)
router.get('/perfil/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(`
      SELECT 
        f.id, f.nom, f.teLimit, f.llimit AS limit, f.saldo,
        f.rol, f.valorpulsera, f.estaloguejat, f.imatgeurl,
        fam.id AS familia_id, fam.nom AS familia_nom, fam.saldo_total
      FROM faller f
      LEFT JOIN familia fam ON f.familia_id = fam.id
      WHERE f.id = $1
    `, [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Perfil no trobat" });
    }

    const row = result.rows[0];
    const faller = {
      id: row.id,
      nom: row.nom,
      teLimit: row.teLimit,
      limit: row.limit,
      saldo: row.saldo,
      rol: row.rol,
      valorPulsera: row.valorpulsera,
      estaLoguejat: row.estaloguejat,
      imatgeUrl: row.imatgeurl,
      familia: row.familia_id ? {
        id: row.familia_id,
        nom: row.familia_nom,
        saldoTotal: row.saldo_total,
        membres: null
      } : null
    };

    res.json(faller);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error a l'hora de mostrar el perfil" });
  }
});

// Mostra membres d'una família concreta (requereix idFamilia)
router.get('/mostraMembres/:idFamilia', async (req, res) => {
  const { idFamilia } = req.params;
  try {
    const result = await pool.query('SELECT id, nom FROM faller WHERE familia_id = $1', [idFamilia]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "No n'hi han membres en esta família" });
    }
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora de mostrar els membres de la família" });
  }
});

// Buscar faller per nom (sense filtrar per família)
router.get('/buscarNom/:nom', async (req, res) => {
  const { nom } = req.params;
  try {
    const result = await pool.query(`
      SELECT 
        f.id AS faller_id, f.nom AS faller_nom, f.te_limit, f.limit, f.saldo,
        f.rol, f.valorpulsera, f.imatgeurl,
        f.familia_id, 
        fam.nom AS familia_nom, fam.saldo_total
      FROM faller f
      LEFT JOIN familia fam ON f.familia_id = fam.id
      WHERE f.nom = $1
    `, [nom]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Faller no trobat" });
    }

    const row = result.rows[0];
    const faller = {
      id: row.faller_id,
      nom: row.faller_nom,
      teLimit: row.te_limit,
      limit: row.limit,
      saldo: row.saldo,
      rol: row.rol,
      valorPulsera: row.valorpulsera,
      imatgeUrl: row.imatgeurl,
      estaLoguejat: true, // pots canviar segons la teva lògica
      familia: row.familia_id ? {
        id: row.familia_id,
        nom: row.familia_nom,
        saldoTotal: row.saldo_total,
        membres: []
      } : null
    };

    res.json(faller);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora de buscar el faller" });
  }
});

// Buscar faller per valor de pulsera
router.get('/buscarPerPulsera/:valorPulsera', async (req, res) =>{
  const { valorPulsera } = req.params
  try{
    const result = await pool.query('SELECT id, nom FROM faller WHERE valorpulsera = $1', {valorPulsera})
    res.json(result.rows)
  }catch(err){
    res.status(500).json({ error: "Error a l'hora de buscar el valor de la pulsera del faller" });
  }
});

/*
Funcions amb POST
*/

// Insertar faller (sense família)
router.post('/insertar', async (req, res) => {
  const { nom, rol, valorPulsera } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO faller (nom, rol, valorpulsera) VALUES ($1, $2, $3) RETURNING *',
      [nom, rol, valorPulsera]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "No s'ha pogut insertar al faller" });
  }
});

/*
Funcions amb PUT
*/

// Canviar nom d'usuari
router.put('/canviaNom/:id', async (req, res) => {
  const { id } = req.params;
  const { nom } = req.body;
  try {
    const result = await pool.query(
      'UPDATE faller SET nom = $1 WHERE id = $2 RETURNING *',
      [nom, id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Assignar família a un faller (requerit: id i idFamilia)
router.put('/familia/:idFamilia', async (req, res) => {
  const { id, idFamilia } = req.body;
  try {
    const result = await pool.query(
      'UPDATE faller SET familia_id = $1 WHERE id = $2 RETURNING *',
      [id, idFamilia]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Canviar rol d'un faller
router.put('/canviaRol/:id', async (req, res) => {
  const { id } = req.params;
  const { rol } = req.body;
  try {
    const result = await pool.query(
      'UPDATE faller SET rol = $1 WHERE id = $2 RETURNING *',
      [rol, id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/*
Funcions amb DELETE
*/

// Borrar un faller per valorPulsera
router.delete('/borrar/:valorPulsera', async (req, res) => {
  const { valorPulsera } = req.params;
  try {
    await pool.query('DELETE FROM faller WHERE valorpulsera = $1', [valorPulsera]);
    res.json({ missatge: 'Faller borrat' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
