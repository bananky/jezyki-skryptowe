const express = require('express');
const app = express();

const productsRouter = require('./routes/products');
const categoriesRouter = require('./routes/categories');

app.use(express.json());

app.use('/api/products', productsRouter);
app.use('/api/categories', categoriesRouter);

const PORT = 4000;
app.listen(PORT, () => {
  console.log(`API running on http://localhost:${PORT}`);
});


