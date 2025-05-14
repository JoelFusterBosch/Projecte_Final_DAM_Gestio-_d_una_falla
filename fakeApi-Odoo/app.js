const express = require('express');
const app = express();
const port = 3000;
const pool = require('./db');

app.use(express.json());

//Importar ruts
const familiesRoutes = require('./routes/families');
const fallersRoutes = require('./routes/fallers');
const cobradorRoutes = require('./routes/cobrador')
const eventsRoutes = require('./routes/events');
const ticketsRoutes = require('./routes/tickets');


app.get('/', (req, res) => {
  res.json({missatge: 'Hola des de Node.js i PostgresSQL'})
});

app.get('/saluda', (req, res) => {
  res.json({ missatge: 'Hola des de Node.js!' });
});

app.use('/families', familiesRoutes);
app.use('/fallers', fallersRoutes);
app.use('/cobrador', cobradorRoutes)
app.use('/event', eventsRoutes);
app.use('/tickets', ticketsRoutes);



app.listen(port, '0.0.0.0', () => {
  console.log(`Servidor escoltant en http://0.0.0.0:${port}`);
});
