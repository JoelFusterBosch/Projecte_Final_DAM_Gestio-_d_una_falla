const express = require('express');
const app = express();
const port = 3000;
const pool= require('./db')

app.use(express.json());

app.get('/', (req, res)=>{
  res.json({missatge: 'Hola des de Node.js i PostgresSQL'})
});

app.get('/saluda', (req, res) => {
  res.json({ missatge: 'Hola des de Node.js!' });
});
app.get('/fallers',async (req, res) => {
  try{
    const result = await pool.query('SELECT * FROM faller');
    res.json(result.rows)
  }catch (err){
    res.status(500).json({error: "Error a l'hora d'obtindre als fallers"});
    
  }
});
app.get('/events',async (req, res) => {
  try{
    const result = await pool.query('SELECT * FROM events')
    res.json(result.rows)
  }catch(err){
    res.status(500).json({error: "Error a l'hora d'obtindre els events"});
  }
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Servidor escuchando en http://0.0.0.0:${port}`);
});
