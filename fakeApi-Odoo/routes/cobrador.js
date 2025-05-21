const express = require('express');
const router = express.Router();
const pool = require('../db');

router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM cobrador');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora d'obtindre als cobradors" });
  }
});
/*
Funcions amb POST 
*/
//Pantalla de admin: Insertar cobradors
router.post('/insertar', async (req,res) =>{
 const {id,rolCobrador} = req.body;
 try{
  const result = await pool.query('INSERT INTO cobrador(id, rol_cobrador) VALUES ($1,$2)',[id,rolCobrador])
  res.status(201).json({missatge: result.rows[0]});
 }catch (err){
  res.status(500).json({error: "Error a l'hora d'afegir un cobrador"});
 }
});
/*
Funcions amb PUT 
*/
//?: Actualitzara el nom dels rols de cobrador
/*Pendent
router.put('/actualitza', async (req,res) =>{
  const {id} = req.body;
  const {rolCobrador} = req.params;
  try{  
    const result = await pool.query('UPDATE cobrador ')
  }catch (err){
    res.status(500).json({error: "Error a l'hora d'actualitzar als cobradors"});
  }
});
*/
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
