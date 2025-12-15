# Objects

## Obiettivo

Padroneggiare la **manipolazione degli oggetti** e il **destructuring** in JavaScript. Gli oggetti sono la struttura dati fondamentale di JavaScript per rappresentare entità complesse e raggruppare dati correlati.

### Contesto Pratico

Object manipulation è essenziale per:
- **API responses**: parsing e trasformazione JSON
- **Configuration**: gestione settings e options
- **Data modeling**: rappresentazione entità business
- **State management**: Redux, React state, Vuex

Vantaggi:
- **Flessibilità**: proprietà dinamiche
- **Destructuring**: extract values elegantemente
- **Spread operator**: merge e clone immutabili
- **Property shorthand**: sintassi concisa

### Object Basics

```javascript
// Object literal
const user = {
  name: 'Alice',
  age: 30,
  email: 'alice@example.com'
};

// Property access
console.log(user.name);        // 'Alice'
console.log(user['age']);      // 30

// Add/modify properties
user.city = 'NYC';
user.age = 31;

// Delete property
delete user.email;

// Check property existence
console.log('name' in user);           // true
console.log(user.hasOwnProperty('age')); // true

// Property shorthand
const name = 'Bob';
const age = 25;
const user2 = { name, age };  // { name: 'Bob', age: 25 }
```

### Object Destructuring

```javascript
// Basic destructuring
const user = { name: 'Alice', age: 30, city: 'NYC' };
const { name, age } = user;
console.log(name, age);  // 'Alice' 30

// Rename variables
const { name: userName, age: userAge } = user;

// Default values
const { name, country = 'USA' } = user;

// Rest properties
const { name, ...rest } = user;
console.log(rest);  // { age: 30, city: 'NYC' }

// Nested destructuring
const data = {
  user: {
    name: 'Alice',
    address: {
      city: 'NYC',
      zip: '10001'
    }
  }
};
const { user: { name, address: { city } } } = data;

// Function parameters
const greet = ({ name, age }) => {
  console.log(`${name} is ${age} years old`);
};
greet(user);
```

### Object Methods

```javascript
// Object.keys() - array of keys
const user = { name: 'Alice', age: 30, city: 'NYC' };
const keys = Object.keys(user);
console.log(keys);  // ['name', 'age', 'city']

// Object.values() - array of values
const values = Object.values(user);
console.log(values);  // ['Alice', 30, 'NYC']

// Object.entries() - array of [key, value] pairs
const entries = Object.entries(user);
console.log(entries);  // [['name', 'Alice'], ['age', 30], ['city', 'NYC']]

// Iterate with forEach
Object.entries(user).forEach(([key, value]) => {
  console.log(`${key}: ${value}`);
});

// Object.assign() - merge objects
const defaults = { theme: 'dark', lang: 'en' };
const settings = { theme: 'light' };
const merged = Object.assign({}, defaults, settings);
console.log(merged);  // { theme: 'light', lang: 'en' }

// Object.fromEntries() - convert entries to object
const entries2 = [['name', 'Bob'], ['age', 25]];
const obj = Object.fromEntries(entries2);
console.log(obj);  // { name: 'Bob', age: 25 }
```

### Spread Operator

```javascript
// Clone object
const user = { name: 'Alice', age: 30 };
const clone = { ...user };

// Merge objects
const person = { name: 'Alice', age: 30 };
const address = { city: 'NYC', country: 'USA' };
const full = { ...person, ...address };
// { name: 'Alice', age: 30, city: 'NYC', country: 'USA' }

// Override properties
const defaults = { theme: 'dark', lang: 'en', debug: false };
const custom = { theme: 'light', debug: true };
const config = { ...defaults, ...custom };
// { theme: 'light', lang: 'en', debug: true }

// Add properties
const user2 = { ...user, email: 'alice@example.com' };

// Update immutably
const updated = { ...user, age: 31 };
```

### Computed Property Names

```javascript
// Dynamic keys
const key = 'status';
const value = 'active';
const obj = { [key]: value };
console.log(obj);  // { status: 'active' }

// Function result as key
const getKey = () => 'timestamp';
const data = { [getKey()]: Date.now() };

// Complex expressions
const prefix = 'user';
const user = {
  [`${prefix}Name`]: 'Alice',
  [`${prefix}Age`]: 30
};
// { userName: 'Alice', userAge: 30 }
```

### Method Shorthand

```javascript
// Old way
const user = {
  name: 'Alice',
  greet: function() {
    return `Hello, I'm ${this.name}`;
  }
};

// Method shorthand
const user2 = {
  name: 'Alice',
  greet() {
    return `Hello, I'm ${this.name}`;
  },
  sayAge() {
    return `I'm ${this.age} years old`;
  }
};

console.log(user2.greet());
```

### Esempio Completo

```javascript
#!/usr/bin/env node

// User factory with defaults
const createUser = (data) => {
  const defaults = {
    role: 'user',
    active: true,
    createdAt: new Date().toISOString()
  };
  
  return { ...defaults, ...data };
};

// User methods
const userMethods = {
  getFullName() {
    return `${this.firstName} ${this.lastName}`;
  },
  
  getInfo() {
    const { firstName, lastName, email, role } = this;
    return `${firstName} ${lastName} (${email}) - ${role}`;
  },
  
  toJSON() {
    const { password, ...safe } = this;
    return safe;
  }
};

// Create user with methods
const createUserWithMethods = (data) => {
  const user = createUser(data);
  return { ...user, ...userMethods };
};

// Transform object
const transformUser = (user) => {
  // Rename keys
  const { firstName: first, lastName: last, ...rest } = user;
  return { first, last, ...rest };
};

// Filter object properties
const filterObject = (obj, keys) => {
  return Object.fromEntries(
    Object.entries(obj).filter(([key]) => keys.includes(key))
  );
};

// Map object values
const mapValues = (obj, fn) => {
  return Object.fromEntries(
    Object.entries(obj).map(([key, value]) => [key, fn(value)])
  );
};

function main() {
  console.log('=== Objects Demo ===\n');
  
  // Create users
  const user1 = createUserWithMethods({
    firstName: 'Alice',
    lastName: 'Smith',
    email: 'alice@example.com',
    age: 30,
    role: 'admin',
    password: 'secret123'
  });
  
  const user2 = createUserWithMethods({
    firstName: 'Bob',
    lastName: 'Jones',
    email: 'bob@example.com',
    age: 25
  });
  
  console.log('=== User Info ===');
  console.log(user1.getInfo());
  console.log(user2.getInfo());
  console.log(`Full name: ${user1.getFullName()}`);
  
  // Destructuring
  console.log('\n=== Destructuring ===');
  const { firstName, lastName, email } = user1;
  console.log(`Extracted: ${firstName}, ${lastName}, ${email}`);
  
  // Object.keys/values/entries
  console.log('\n=== Object Methods ===');
  console.log('Keys:', Object.keys(user1).slice(0, 5));
  console.log('Entry count:', Object.entries(user1).length);
  
  // Transform
  console.log('\n=== Transform ===');
  const transformed = transformUser(user1);
  console.log('Transformed:', transformed.first, transformed.last);
  
  // Filter (safe JSON)
  console.log('\n=== Safe JSON ===');
  const safe = user1.toJSON();
  console.log('Safe user:', safe);
  console.log('Has password:', 'password' in safe);
  
  // Filter specific keys
  const publicInfo = filterObject(user1, ['firstName', 'email', 'role']);
  console.log('\nPublic info:', publicInfo);
  
  // Map values
  const uppercased = mapValues(
    { name: 'alice', city: 'nyc' },
    v => typeof v === 'string' ? v.toUpperCase() : v
  );
  console.log('\nUppercased:', uppercased);
  
  // Merge multiple users
  console.log('\n=== Merge ===');
  const stats = { loginCount: 42, lastLogin: new Date().toISOString() };
  const enriched = { ...user2, ...stats };
  console.log('Enriched user:', enriched.firstName, `(${enriched.loginCount} logins)`);
  
  // Group users
  const users = [user1, user2];
  const byRole = users.reduce((acc, user) => {
    const { role } = user;
    if (!acc[role]) acc[role] = [];
    acc[role].push(user.getFullName());
    return acc;
  }, {});
  console.log('\n=== By Role ===');
  Object.entries(byRole).forEach(([role, names]) => {
    console.log(`${role}: ${names.join(', ')}`);
  });
  
  console.log('\n✓ Complete!');
}

main();
```

## Requisiti
- [ ] Crea e manipola oggetti
- [ ] Usa destructuring per extract values
- [ ] Usa spread operator per merge/clone
- [ ] Usa Object.keys/values/entries
- [ ] Codice eseguibile

## Risorse
- [MDN - Objects](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object)
- [MDN - Destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
- [MDN - Spread syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax)
- [JavaScript.info - Objects](https://javascript.info/object)

## Note
Oggetti in JavaScript sono **mutable**. Usa spread operator `{...obj}` per operazioni immutabili. Destructuring è potente per extract values e function parameters.

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
