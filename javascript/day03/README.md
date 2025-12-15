# Arrays

## Obiettivo

Padroneggiare le **array methods** fondamentali di JavaScript: **map**, **filter**, **reduce**. Questi metodi functional permettono di trasformare e processare dati in modo elegante e conciso.

### Contesto Pratico

Array methods sono essenziali per:
- **Data transformation**: API responses, database queries
- **Filtering**: search, validation
- **Aggregation**: statistics, reporting
- **Functional programming**: immutable operations

### map: Transform Elements

```javascript
// Trasforma ogni elemento
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(x => x * 2);
console.log(doubled);  // [2, 4, 6, 8, 10]

// Con indice
const indexed = numbers.map((x, i) => `${i}: ${x}`);
console.log(indexed);  // ['0: 1', '1: 2', ...]

// Objects
const users = [
  { name: 'Alice', age: 30 },
  { name: 'Bob', age: 25 }
];
const names = users.map(u => u.name);
console.log(names);  // ['Alice', 'Bob']
```

### filter: Select Elements

```javascript
// Filtra elementi che passano test
const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const evens = numbers.filter(x => x % 2 === 0);
console.log(evens);  // [2, 4, 6, 8, 10]

// Filtra objects
const users = [
  { name: 'Alice', age: 30, active: true },
  { name: 'Bob', age: 17, active: false },
  { name: 'Charlie', age: 25, active: true }
];

const adults = users.filter(u => u.age >= 18);
const activeUsers = users.filter(u => u.active);
const activeAdults = users.filter(u => u.age >= 18 && u.active);
```

### reduce: Aggregate to Single Value

```javascript
// Sum
const numbers = [1, 2, 3, 4, 5];
const sum = numbers.reduce((acc, x) => acc + x, 0);
console.log(sum);  // 15

// Product
const product = numbers.reduce((acc, x) => acc * x, 1);

// Max
const max = numbers.reduce((acc, x) => Math.max(acc, x));

// Grouping
const users = [
  { name: 'Alice', city: 'NYC' },
  { name: 'Bob', city: 'LA' },
  { name: 'Charlie', city: 'NYC' }
];

const byCity = users.reduce((acc, user) => {
  if (!acc[user.city]) acc[user.city] = [];
  acc[user.city].push(user);
  return acc;
}, {});
console.log(byCity);
// { NYC: [{Alice}, {Charlie}], LA: [{Bob}] }
```

### Chaining Methods

```javascript
const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

const result = numbers
  .filter(x => x % 2 === 0)      // [2, 4, 6, 8, 10]
  .map(x => x * x)               // [4, 16, 36, 64, 100]
  .reduce((acc, x) => acc + x, 0);  // 220

console.log(result);

// Real-world example
const users = [
  { name: 'Alice', age: 30, score: 85 },
  { name: 'Bob', age: 17, score: 92 },
  { name: 'Charlie', age: 25, score: 78 }
];

const avgAdultScore = users
  .filter(u => u.age >= 18)
  .map(u => u.score)
  .reduce((sum, score, _, arr) => sum + score / arr.length, 0);
```

### Other Useful Methods

```javascript
const arr = [1, 2, 3, 4, 5];

// find: first matching element
const first = arr.find(x => x > 3);  // 4

// findIndex: index of first match
const idx = arr.findIndex(x => x > 3);  // 3

// some: at least one matches
const hasEven = arr.some(x => x % 2 === 0);  // true

// every: all match
const allPositive = arr.every(x => x > 0);  // true

// includes: contains value
const has3 = arr.includes(3);  // true

// forEach: iterate (no return)
arr.forEach((x, i) => console.log(`${i}: ${x}`));

// sort: in-place sort
const sorted = [...arr].sort((a, b) => b - a);  // descending

// slice: extract portion (immutable)
const part = arr.slice(1, 4);  // [2, 3, 4]

// concat: merge arrays
const merged = arr.concat([6, 7, 8]);
```

### Esempio Completo

```javascript
#!/usr/bin/env node

function main() {
  console.log('=== Array Methods Demo ===\n');
  
  // Dataset
  const sales = [
    { product: 'Laptop', price: 999, quantity: 2, category: 'Electronics' },
    { product: 'Mouse', price: 25, quantity: 5, category: 'Electronics' },
    { product: 'Desk', price: 299, quantity: 1, category: 'Furniture' },
    { product: 'Chair', price: 199, quantity: 2, category: 'Furniture' },
    { product: 'Monitor', price: 350, quantity: 1, category: 'Electronics' }
  ];
  
  // 1. map: Calculate totals
  const totals = sales.map(s => ({
    product: s.product,
    total: s.price * s.quantity
  }));
  console.log('=== Totals ===');
  totals.forEach(t => console.log(`${t.product}: $${t.total}`));
  
  // 2. filter: Electronics only
  const electronics = sales.filter(s => s.category === 'Electronics');
  console.log('\n=== Electronics ===');
  console.log(electronics.map(e => e.product));
  
  // 3. reduce: Total revenue
  const revenue = sales.reduce((sum, s) => sum + (s.price * s.quantity), 0);
  console.log(`\n=== Revenue ===`);
  console.log(`Total: $${revenue}`);
  
  // 4. Chain: Average price of expensive items
  const avgExpensive = sales
    .filter(s => s.price > 100)
    .map(s => s.price)
    .reduce((sum, price, _, arr) => sum + price / arr.length, 0);
  console.log(`\nAverage price (>$100): $${avgExpensive.toFixed(2)}`);
  
  // 5. Group by category
  const byCategory = sales.reduce((acc, s) => {
    if (!acc[s.category]) acc[s.category] = [];
    acc[s.category].push(s);
    return acc;
  }, {});
  console.log('\n=== By Category ===');
  Object.entries(byCategory).forEach(([cat, items]) => {
    console.log(`${cat}: ${items.length} items`);
  });
  
  // 6. Find most expensive
  const mostExpensive = sales.reduce((max, s) => 
    s.price > max.price ? s : max
  );
  console.log(`\nMost expensive: ${mostExpensive.product} ($${mostExpensive.price})`);
  
  console.log('\n✓ Complete!');
}

main();
```

## Requisiti
- [ ] Usa `map()` per transformation
- [ ] Usa `filter()` per filtering
- [ ] Usa `reduce()` per aggregation
- [ ] Chain methods insieme
- [ ] Codice eseguibile

## Risorse
- [MDN - Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)
- [MDN - map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map)
- [MDN - filter](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter)
- [MDN - reduce](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)

## Note
Tutti questi metodi sono **immutable** (non modificano array originale). Usa spread operator `[...arr]` per copiare prima di `sort()`.

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
