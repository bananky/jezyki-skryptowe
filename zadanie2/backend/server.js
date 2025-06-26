const express = require('express');
const cors = require('cors');
const { sequelize } = require('./models');

const app = express();
const PORT = 4000;

app.use(cors({
  origin: 'http://localhost:3000',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  credentials: true
}));

app.use(express.json());
app.use('/api/products', require('./routes/products'));
app.use('/api/categories', require('./routes/categories'));

sequelize.sync().then(() => {
  console.log("Baza danych połączona.");
  app.listen(PORT, () => {
    console.log(`API running on http://localhost:${PORT}`);
  });
});
