const express = require('express');
const router = express.Router();
const pool = require('../db');

router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
      c.id, c.rolcobrador 
      FROM cobrador c
    `);
    const cobradors = result.rows.map(row =>({
      id: row.id,
      rolcobrador: row.rolcobrador
      })
    );
    res.json(cobradors);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora d'obtindre als cobradors" });
  }
});
/*
Funcions amb POST 
*/
//Pantalla de admin: Insertar cobradors
router.post('/insertar', async (req,res) =>{
 const {rolCobrador} = req.body;
 try{
  const result = await pool.query('INSERT INTO cobrador(rolcobrador) VALUES ($1)',[rolCobrador])
  res.status(201).json({missatge: result.rows[0]});
 }catch (err){
  res.status(500).json({error: "Error a l'hora d'afegir un cobrador"});
 }
});
/*
Funcions amb DELETE 
*/
//Pantalla de admin: Borrar cobradors
router.delete('/borrar/:rolCobrador', async (req,res) =>{
  const {nom: rolCobrador} = req.params;
  try{
    pool.query('DELETE cobrador WHERE rolcobrador=$1',[rolCobrador]);
    res.json({missatge:"Cobrador borrat"});
  }catch (err){
    res.status(500).json({error: "Error a l'hora de borrar un cobrador"});
  }
});
module.exports = router;
