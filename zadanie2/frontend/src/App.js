import React from 'react';
import ProductList from './components/ProductList';
import CategoryList from './components/CategoryList';

function App() {
  return (
    <div style={{ padding: "20px" }}>
      <h1>🛒 Mój Sklep</h1>
      <CategoryList />
      <hr />
      <ProductList />
    </div>
  );
}

export default App;
