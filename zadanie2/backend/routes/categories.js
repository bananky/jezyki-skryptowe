const express = require('express');
const router = express.Router();
const { Category } = require('../models');

router.get('/', async (req, res) => {
  const categories = await Category.findAll();
  res.json(categories);
});

router.post('/', async (req, res) => {
  const { name } = req.body;
  const category = await Category.create({ name });
  res.status(201).json(category);
});

module.exports = router;
