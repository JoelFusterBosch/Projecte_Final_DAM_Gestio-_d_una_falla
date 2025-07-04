const express = require("express");
const router = express.Router();
const pool = require('../db');
/*
Funcions amb GET:
*/
//GET bàsic
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
      p.id, p.nom, p.preu, p.stock, p.urlimatge, p.eventespecific
      FROM producte p
    `);
    const productes = result.rows.map(row => ({
      id: row.id,
      nom: row.nom,
      preu: parseFloat(row.preu),
      stock: row.stock,
      urlimatge: row.urlimatge,
      eventespecific: row.eventespecific
      })
    );
    res.json(productes);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora d'obtindre els productes"});
  }
});
//Barra: SELECT amb id,nom,preu,stock,imatgeURL
router.get('/barra', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
      p.id, p.nom, p.preu, p.stock, p.urlimatge
      FROM p WHERE prodespecific = false
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora d'obtindre la llista de productes" });
  }
});

/*
Funcions amb POST:
*/
//Pantalla de admin?: Publicar un producte amb id,nom,preu,stock,imatgeURL
router.post('/insertar', async (req,res) =>{
  const {nom,preu,stock, imatgeUrl} = req.body;
  try{
    const result = await pool.query('INSERT INTO producte(nom,preu,stock,imatgeurl) VALUES ($1,$2,$3,$4)',[nom,preu,stock,imatgeUrl]);
    res.json(result.rows[0]);
  }catch (err){
    res.tatus(500).json({error:"Error a l'hora d'insertar un producte"});
  }
});
/*
Funcions amb DELETE
*/
//Pantalla de admin: Borrar un producte
router.delete('/borrar/:nom', async (req,res) =>{
  const {nom} = req.params;
  try{
    await pool.query('DELETE FROM producte WHERE nom=$1',[nom]);
    res.json({missatge:"Producte borrat"});
  }catch (err){
    res.status(500).json({error:"Error a l'hora de borrar un producte"});
  }
});

module.exports = router; 
