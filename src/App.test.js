import { render, screen } from '@testing-library/react';
import App from './App';

test('renders product items', () => {
  render(<App />);
  
  const product1 = screen.getByText(/Product 1/i);
  const product2 = screen.getByText(/Product 2/i);

  expect(product1).toBeInTheDocument();
  expect(product2).toBeInTheDocument();
});
