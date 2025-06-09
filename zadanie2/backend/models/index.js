const { Sequelize } = require('sequelize');

const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage: './database.sqlite'
});

const Product = require('./product')(sequelize);
const Category = require('./category')(sequelize);

Product.belongsTo(Category);
Category.hasMany(Product);

sequelize.sync(); 

module.exports = {
  sequelize,
  Product,
  Category
};

