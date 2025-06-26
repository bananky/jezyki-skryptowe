import React, { useState } from 'react';
import ProductList from './components/ProductList';
import CategoryList from './components/CategoryList';
import Cart from './components/Cart';

function App() {
  const [cart, setCart] = useState([]);

  const addToCart = (product) => {
    setCart(prev => [...prev, product]);
  };

  const removeFromCart = (indexToRemove) => {
    setCart(prev => prev.filter((_, index) => index !== indexToRemove));
  };

  const clearCart = () => {
    setCart([]);
  };

  return (
    <div style={{ padding: "20px" }}>
      <h1>🛒 Mój Sklep <span style={{ fontSize: '16px' }}>Koszyk ({cart.length})</span></h1>
      <CategoryList />
      <hr />
      <ProductList onAddToCart={addToCart} />
      <hr />
      <Cart cart={cart} onClearCart={clearCart} onRemoveFromCart={removeFromCart} />
    </div>
  );
}

export default App;
