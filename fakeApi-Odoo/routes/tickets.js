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
/*
Funcions amb POST
*/
//Pantalla de admin?: Afegir tickets
router.post('/insertar', async (req,res)=>{
  const {id,quantitat,preu,maxim} =  req.body;
  try{
    const result = await pool.query('INSERT INTO ticket(id,quantitat,preu,maxim) VALUES ($1,$2,$3,$4)'[id,quantitat,preu,maxim]);
    res.json(result.rows[0]);
  }catch(err){
    res.status(500).json({error:"Error a l'hora d'insertar tickets"});
  }
});
/*
Funcions amb DELETE
*/
//Pantalla de admin?: Borrar tickets
router.delete('/borrar/:id', async (req,res)=>{
  const {id} = req.params;
  try{
    await pool.query('DELETE FROM ticket WHERE id=$1',[id]);
    res.json({missatge:"Ticket borrat"});
  }catch (err){
    res.status(500).json({error:"Error a l'hora de borrar el ticket"})
  }
});

module.exports = router;
