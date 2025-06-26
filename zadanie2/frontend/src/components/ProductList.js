import React, { useEffect, useState } from 'react';
import axios from 'axios';

function ProductList({ onAddToCart }) {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    axios.get('http://localhost:4000/api/products')
      .then(res => setProducts(res.data))
      .catch(err => console.error('Błąd pobierania produktów:', err));
  }, []);

  return (
    <div>
      <h2>📦 Produkty</h2>
      <ul>
        {products.map(p => (
          <li key={p.id}>
            {p.name} - {p.price} zł
            {p.Category ? ` (kategoria: ${p.Category.name})` : ''}
            <button onClick={() => onAddToCart(p)} style={{ marginLeft: 10 }}>
              ➕ Do koszyka
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default ProductList;
