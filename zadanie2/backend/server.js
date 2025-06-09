const express = require('express');
const cors = require('cors');
const { sequelize } = require('./models');

const app = express();
const PORT = 4000;

app.use(cors());
app.use(express.json());


const productRoutes = require('./routes/products');
const categoryRoutes = require('./routes/categories');

app.use('/api/products', productRoutes);
app.use('/api/categories', categoryRoutes);

sequelize.sync()
  .then(() => {
    console.log("Baza danych połączona.");
    app.listen(PORT, () => {
      console.log(`API running on http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Błąd połączenia z bazą:", err);
  });
