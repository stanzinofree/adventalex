# Variables & Types

## Obiettivo

Padroneggiare **const/let**, **arrow functions**, e i tipi base di JavaScript moderno (ES6+). JavaScript è dinamicamente tipato, ma comprendere i tipi e le best practices è fondamentale.

### Contesto Pratico

JavaScript moderno usa:
- **const**: default (immutabile reference)
- **let**: quando serve reassignment
- **var**: deprecato (evita!)
- **Arrow functions**: sintassi concisa

### Variables

```javascript
// const: cannot reassign (ma oggetti mutabili!)
const name = 'Alice';
const age = 30;
// name = 'Bob';  // ❌ Error!

// Objects/arrays sono mutabili
const user = { name: 'Alice' };
user.name = 'Bob';  // ✅ OK
user.age = 30;      // ✅ OK

// let: reassignable
let count = 0;
count = 1;  // ✅ OK

// var: don't use!
```

### Types

```javascript
// Primitives
const str = 'text';
const num = 42;
const bool = true;
const undef = undefined;
const nul = null;
const sym = Symbol('id');
const bigInt = 9007199254740991n;

// Objects
const obj = { key: 'value' };
const arr = [1, 2, 3];
const fn = function() {};

// Check type
console.log(typeof str);    // 'string'
console.log(typeof num);    // 'number'
console.log(typeof bool);   // 'boolean'
console.log(typeof obj);    // 'object'
console.log(typeof arr);    // 'object' (use Array.isArray)
console.log(Array.isArray(arr));  // true
```

### Arrow Functions

```javascript
// Traditional function
function add(a, b) {
  return a + b;
}

// Arrow function
const add = (a, b) => {
  return a + b;
};

// Concise (implicit return)
const add = (a, b) => a + b;

// Single param (no parens)
const double = x => x * 2;

// No params
const getTimestamp = () => Date.now();

// Examples
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(x => x * 2);
const evens = numbers.filter(x => x % 2 === 0);
const sum = numbers.reduce((acc, x) => acc + x, 0);

console.log('Doubled:', doubled);
console.log('Evens:', evens);
console.log('Sum:', sum);
```

### Template Literals

```javascript
const name = 'Alice';
const age = 30;

// Old way
console.log('Name: ' + name + ', Age: ' + age);

// Template literal (backticks)
console.log(`Name: ${name}, Age: ${age}`);

// Multiline
const message = `
  Hello ${name}!
  You are ${age} years old.
  Next year: ${age + 1}
`;
```

### Destructuring

```javascript
// Array destructuring
const [a, b, c] = [1, 2, 3];
const [first, ...rest] = [1, 2, 3, 4];

// Object destructuring
const user = { name: 'Alice', age: 30, city: 'NYC' };
const { name, age } = user;
const { name: userName, age: userAge } = user;  // Rename

// Function parameters
const greet = ({ name, age }) => {
  console.log(`${name} is ${age} years old`);
};
greet(user);
```

### Esempio Completo

```javascript
#!/usr/bin/env node

// Constants and variables
const APP_NAME = 'Demo App';
const VERSION = '1.0.0';
let requestCount = 0;

// Arrow functions
const incrementCounter = () => ++requestCount;
const getStats = () => ({ app: APP_NAME, version: VERSION, requests: requestCount });

// User object
const createUser = (name, age, email) => ({
  name,
  age,
  email,
  createdAt: new Date().toISOString(),
  greet() {
    return `Hello, I'm ${this.name}`;
  }
});

// Array operations
const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const evens = numbers.filter(n => n % 2 === 0);
const doubled = evens.map(n => n * 2);
const sum = doubled.reduce((acc, n) => acc + n, 0);

// Main
function main() {
  console.log('=== Variables & Types Demo ===\n');
  
  // User demo
  const user = createUser('Alice', 30, 'alice@example.com');
  console.log('User:', user);
  console.log(user.greet());
  
  // Arrow functions & operations
  console.log('\n=== Array Operations ===');
  console.log('Numbers:', numbers);
  console.log('Evens:', evens);
  console.log('Doubled:', doubled);
  console.log('Sum:', sum);
  
  // Increment counter
  incrementCounter();
  incrementCounter();
  incrementCounter();
  
  // Stats
  console.log('\n=== Stats ===');
  const stats = getStats();
  console.log(`${stats.app} v${stats.version}`);
  console.log(`Requests: ${stats.requests}`);
  
  // Destructuring
  const { name, age } = user;
  console.log(`\nDestructured: ${name}, ${age}`);
  
  console.log('\n✓ Complete!');
}

main();
```

## Requisiti
- [ ] Usa `const` e `let` (no `var`)
- [ ] Definisci arrow functions
- [ ] Template literals per string
- [ ] Destructuring (opzionale)
- [ ] Codice eseguibile

## Risorse
- [MDN - const](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const)
- [MDN - Arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)
- [JavaScript.info - Variables](https://javascript.info/variables)

## Note
Usa sempre `const` di default, `let` solo se serve reassignment. Evita `var` (function-scoped, problematico).

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
