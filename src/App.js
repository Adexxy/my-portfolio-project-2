import React, { useState } from 'react';
import Product from './components/Product';
import ShoppingCart from './components/ShoppingCart';

const App = () => {
  const [cart, setCart] = useState([]);
  const products = [
    { id: 1, name: 'Product 1', price: 10 },
    { id: 2, name: 'Product 2', price: 15 },
    // Add more products as needed
  ];

  const handleAddToCart = (product) => {
    setCart([...cart, product]);
  };

  return (
    <div className="App">
      <h1>Commerce App</h1>
      <div className="products">
        {products.map((product) => (
          <Product key={product.id} product={product} onAddToCart={handleAddToCart} />
        ))}
      </div>
      <ShoppingCart cart={cart} />
    </div>
  );
};

export default App;
