const express = require('express');
const router = express.Router();
const pool = require('../db');
/*
Funcions amb GET
*/
//Get bàsic
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM faller');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora d'obtindre als fallers" });
  }
});

//Pantalla perfil: Un SELECT amb id, nom,familia, rol,teLimit?, limit?,saldo?
router.get('/perfil/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT * FROM faller WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Perfil no trobat" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Error a l'hora de mostrar el perfil" });
  }
});

//Pantalla mostraQR: Un SELECT amb id, nom, valorPulsera
router.get('/mostraQR/:id', async (req,res) =>{
  const { id } = req.params;
  try{
    const result = await pool.query('SELECT nom,valor_pulsera from faller WHERE id=$1',[id] );
    if(result.rows.length === 0){
      return res.status(404).json({ error: "Faller no trobat" });
    }
    res.json(result.rows[0]);
  }catch (err){
    res.status(500).json({ error: "Error a l'hora de mostar el perfil amb el valor de la pulsera"});
  }
});

//Pantalla mostrar membres?
router.get('/mostraMembres/:idFamilia', async (req,res)=>{
  const {idFamilia} = req.params;
  try{
    const result= await pool.query('SELECT nom from faller WHERE id_familia=$1',[idFamilia]);
    if(result.rows.length===0){
      return res.status(404).json({error: "No n'hi han membres en esta familia"});
    }
    res.json(result.rows[0]);
  }catch (err){
    res.status(500).json({error:"Error a l'hora de mostrar els membres de la familia"});
  }
});
/*
Funcions amb POST
*/
//Pantalla admin?: Insertar un faller amb el id,nom,rol,valorPulsera
router.post('/insertar', async(req,res) =>{
  const {nom,rol,valorPulsera} = req.body;
  try{
    const result = await pool.query('INSERT faller(nom,rol,valor_pulsera) VALUES ($1,$2,$3) RETURNING *',
      [nom,rol,valorPulsera]
    );
    res.status(201).json(result.rows[0]);
  }catch(err){
    res.status(500).json({error: "No s'ha pogut insertar al faller"});
  }
});
/*
Funcions amb PUT
*/
//Pantalla editaUsuari cambia el nom d'usuari
router.put('/canviaNom/:id', async (req,res) =>{
  const {id} = req.params;
  const {nom} = req.body;
  try{
    const result = await pool.query('UPDATE faller SET nom = $1 WHERE id = $2 RETURNING *', [nom,id]);
    res.json(result.rows[0]);
  }catch (err){
    res.status(500).json({error: err.message});
  }
});

//Pantalla afegir membre: Assigna una familia al usuari(sols familia no sera null, tindra el id de la familia)
router.put('/familia/:idFamilia', async (req, res) => {
  const { id } = req.params;
  const { idFamilia } = req.body;
  try {
    const result = await pool.query(
      'UPDATE faller SET familia_id = $1 WHERE id = $2 RETURNING *',
      [idFamilia, id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

//Pantalla cambiarol?: Cambia el rol de Cap de familia del usuari a un altre de la mateixa familia, i quan acaba perd el rol de cap de familia i es transforma en faller
// /pantalla registraUsuari per a transformar a un noFaller a Faller,cobrador o Administrador
router.put('/cambiaRol/:id', async (req, res) =>{
  const {id}= req.params;
  const {rol}= req.body;
  try{
    const result = await pool.query('UPDATE faller SET rol=$1 WHERE id=$2 RETURNING *', [rol,id])
  }catch (err){
    res.status(500).json({error: err.message});
  }
});
/*
Funcions amb DELETE
*/
//Pantalla admin?: Borrar un faller
router.delete('/borrar/:valorPulsera', async (req,res) => {
  const {id} =req.params;
  try{
    await pool.query('DELETE FROM faller WHERE valorpulsera = $1'[valorPulsera]);
    res.json({missatge: 'Faller borrat'});
  }catch (err){
    res.status(500).json({error: err.message});
  }
});

module.exports = router;
