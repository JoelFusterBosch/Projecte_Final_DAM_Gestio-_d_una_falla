const express = require('express');
const app = express();
const port = 3000;


app.use(express.json());

app.get('/', (req, res) => {
  res.json({missatge: 'Hola des de Node.js i PostgresSQL'})
});

app.get('/saluda', (req, res) => {
  res.json({ missatge: 'Hola des de Node.js!' });
});
app.get('/families', async (req, res) => {
  try{
    const result= await pool.query('SELECT * FROM familia')
    res.json(result.rows)
  }catch (err){
    res.status(500).json({error: "Error a l'hora d'obtindre a les families"});
  }
});
app.get('/fallers', async (req, res) => {
  try{
    const result = await pool.query('SELECT * FROM faller');
    res.json(result.rows)
  }catch (err){
    res.status(500).json({error: "Error a l'hora d'obtindre als fallers"});
  }
});
app.get('/events', async (req, res) => {
  try{
    const result = await pool.query('SELECT * FROM events')
    res.json(result.rows)
  }catch(err){
    res.status(500).json({error: "Error a l'hora d'obtindre als events"});
  }
});

app.get('/tickets', async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM ticket");
    res.json(result.rows);
  } catch (err) {
    console.error('Error al obtindre tickets:', err);
    res.status(500).json({ error: "Error a l'hora d'obtindre els tickets" });
  }
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Servidor escoltant en http://0.0.0.0:${port}`);
});
