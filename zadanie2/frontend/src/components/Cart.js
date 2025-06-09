import React from 'react';

function Cart({ cart, onClearCart, onRemoveFromCart }) {
  const total = cart.reduce((sum, item) => sum + item.price, 0);

  const handleOrder = () => {
    alert("✅ Płatność przyjęta! Dziękujemy za zakupy.");
    onClearCart();
  };

  return (
    <div>
      <h2>🧺 Koszyk</h2>
      {cart.length === 0 ? (
        <p>Twój koszyk jest pusty.</p>
      ) : (
        <div>
          <ul>
            {cart.map((item, index) => (
              <li key={index}>
                {item.name} - {item.price} zł
                <button
                  onClick={() => onRemoveFromCart(index)}
                  style={{ marginLeft: 10, color: 'red' }}
                >
                  🗑️ Usuń
                </button>
              </li>
            ))}
          </ul>
          <p><strong>Razem:</strong> {total.toFixed(2)} zł</p>
          <button onClick={handleOrder}>💳 Zamów</button>
        </div>
      )}
    </div>
  );
}

export default Cart;

