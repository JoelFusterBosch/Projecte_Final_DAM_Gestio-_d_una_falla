require('dotenv').config(); 
const express = require('express');
const app = express();

const port = process.env.PORT || 3000;

app.use(express.json());

// Importar rutas
const familiesRoutes = require('./routes/families');
const fallersRoutes = require('./routes/fallers');
const cobradorRoutes = require('./routes/cobrador');
const eventsRoutes = require('./routes/events');
const ticketsRoutes = require('./routes/tickets');
const productesRoutes = require('./routes/productes');
const authRoutes = require('./routes/authRoutes');

app.use('/families', familiesRoutes);
app.use('/fallers', fallersRoutes);
app.use('/cobrador', cobradorRoutes);
app.use('/events', eventsRoutes);
app.use('/tickets', ticketsRoutes);
app.use('/productes', productesRoutes);
app.use('/verificar', authRoutes);

app.get('/', (req, res) => {
  res.json({ missatge: 'Hola des de Node.js i PostgreSQL' });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Servidor escoltant en http://0.0.0.0:${port}`);
});
