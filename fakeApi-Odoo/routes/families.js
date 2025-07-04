const express = require('express');
const router = express.Router();
const pool = require('../db');

router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
      f.id, f.nom, f.saldo_total 
      FROM familia f
    `);
    const familia = result.rows.map(row =>({
      id: row.id,
      nom: row.nom,
      saldo_total: parseFloat(row.saldo_total) || 0
      })
    );
  res.json(familia);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora d'obtindre a les families" });
  }
});
/*
Funcions amb POST
*/
//Pantalla afegir families?: Afegir families 
router.post('/insertar', async (req,res) =>{
  const {nom} = req.body;
  try{
    const result= await pool.query('INSERT INTO familia (nom) VALUES ($1) RETURNING *',[nom]);
    res.status(201).json(result.rows[0]);
  }catch(err){
    res.status(500).json({ error: "Error a l'hora d'insertar una familia"});
  }
});
/*
Funcions amb DELETE
*/
//Pantalla admin?; Borrar families
router.delete('/borrar/:nom', async (req,res) =>{
  const {nom} = req.params;
  try{
    await pool.query('DELETE FROM familia WHERE nom=$1',[nom]);
    res.json({missatge: "Familia borrada"});
  }catch(err){
    res.staus(500).json({error: "Error a l'hora de borrar a la familia"});
  }
});

module.exports = router;
