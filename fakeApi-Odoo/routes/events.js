const express = require('express');
const router = express.Router();
const pool = require('../db');

router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM events');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora d'obtindre als events" });
  }
});
/*
Funcions amb GET
*/

//Event detallat: un SELECT amb id,nom,descripcio,imatgeURL
router.get('/detallat/:id', async (req, res) => {
  const {id} = req.params;
  try{
    const result = await pool.query('SELECT nom, descripcio, urlimatge FROM events WHERE id=$1',[id]);
    res.json(result.rows)
  }catch (err){
    res.status(500).json({ error: "Error a l'hora de mostrar els events detallats"});
  }
});
//Escaner? i pantalla d'events: Un SELECT amb id,nom,dataInici,dataFi
router.get('/llista', async (req, res) => {
  try{
    const result = await pool.query('SELECT id, nom, datainici, datafi FROM events');
    res.json(result.rows);
  }catch (err){
    res.status(500).json({error:"Error a l'hora d'obtindre la llista d'events"});
  }
});
/*
Funcions amb POST
*/
//Pantalla admin? : Publicar un event amb el id,nom,descripcio,dataInici,dataFi,imatgeURL
router.post('/insertar', async (req,res) =>{
  const {id,nom,dataInici,dataFi} = req.body;
  try{
    const result = await populate.query('INSERT INTO events(id,nom,datainici,datafi) VALUES ($1,$2,$3,$4)',[id,nom,dataInici,dataFi]);
    res.status(201).json(result.rows[0]);
  }catch (err){
    res.json({error: "Error a l'hoora d'insertar un event"});
  }
});
/*
Funcions amb DELETE
*/
//Pantalla admin?: Borrar un event
router.delete('/borrar/:nom', async (req,res) =>{
  const {nom} = req.params;
  try{
    await pool.query("DELETE FROM events WHERE nom = $1",[nom]);
    res.json({missatge:"Missatge borrat"});
  }catch (err){
    res.json({error: "Error a l'hora de borrar un event"});
  }
});

module.exports = router;
