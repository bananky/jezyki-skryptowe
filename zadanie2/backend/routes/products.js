const express = require('express');
const router = express.Router();
const { Product, Category } = require('../models');

router.get('/', async (req, res) => {
  const products = await Product.findAll({ include: Category });
  res.json(products);
});

router.post('/', async (req, res) => {
  const { name, price, categoryId } = req.body;
  const product = await Product.create({ name, price, CategoryId: categoryId });
  res.status(201).json(product);
});

module.exports = router;
