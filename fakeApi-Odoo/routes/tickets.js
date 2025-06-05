const express = require('express');
const router = express.Router();
const pool = require('../db');

router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
      t.id, t.quantitat, t.preu, t.maxim
      FROM ticket t
    `);
    const tickets = result.rows.map(row => ({
      id: row.id,
      quantitat: row.quantitat,
      preu: parseFloat(row.preu),
      maxim: row.maxim
      })
    );
    res.json(tickets);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora d'obtindre els tickets" });
  }
});
/*
Funcions amb POST
*/
//Pantalla de admin?: Afegir tickets
router.post('/insertar', async (req,res)=>{
  const {quantitat,preu} =  req.body;
  try{
    const result = await pool.query('INSERT INTO ticket (quantitat,preu) VALUES ($1,$2) ', [quantitat,preu]);
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
