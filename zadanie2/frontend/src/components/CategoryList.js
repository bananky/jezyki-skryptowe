import React, { useEffect, useState } from 'react';
import axios from 'axios';

function CategoryList() {
  const [categories, setCategories] = useState([]);

  useEffect(() => {
    axios.get('http://localhost:4000/api/categories')
      .then(res => setCategories(res.data))
      .catch(err => console.error('Błąd pobierania kategorii:', err));
  }, []);

  return (
    <div>
      <h2>📂 Kategorie</h2>
      <ul>
        {categories.map(c => (
          <li key={c.id}>{c.name}</li>
        ))}
      </ul>
    </div>
  );
}

export default CategoryList;

