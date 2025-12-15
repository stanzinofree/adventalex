# Modules

## Obiettivo

Padroneggiare **ES Modules** (ESM) con **import/export** per organizzare codice in file separati. I moduli permettono di creare codice riutilizzabile, manutenibile e scalabile.

### Contesto Pratico

ES Modules sono essenziali per:
- **Code organization**: separare responsabilità
- **Reusability**: condividere utilities tra progetti
- **Maintainability**: modifiche isolate
- **Dependency management**: import solo ciò che serve
- **Tree shaking**: bundlers rimuovono unused code

Vantaggi:
- **Static imports**: analisi build-time
- **Explicit dependencies**: chiaro cosa viene usato
- **Scoped**: no global namespace pollution
- **Standard**: supportato nativamente in Node.js 14+

### Enabling ES Modules

```json
// package.json
{
  "type": "module"
}

// OR use .mjs extension:
// - file.mjs (ES Module)
// - file.cjs (CommonJS)
```

### Named Exports

```javascript
// math.js
export const PI = 3.14159;
export const E = 2.71828;

export function add(a, b) {
  return a + b;
}

export function multiply(a, b) {
  return a * b;
}

export class Calculator {
  add(a, b) { return a + b; }
  subtract(a, b) { return a - b; }
}

// Alternative: export at end
const PI = 3.14159;
function add(a, b) { return a + b; }
export { PI, add };
```

```javascript
// main.js - import named exports
import { PI, add, multiply } from './math.js';

console.log(PI);           // 3.14159
console.log(add(2, 3));    // 5
console.log(multiply(4, 5)); // 20

// Import all as namespace
import * as math from './math.js';
console.log(math.PI);
console.log(math.add(2, 3));

// Rename imports
import { add as sum, multiply as mult } from './math.js';
```

### Default Exports

```javascript
// user.js - one default export per file
export default class User {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }
  
  greet() {
    return `Hello, I'm ${this.name}`;
  }
}

// Alternative styles
export default function User() { }
const User = class { };
export default User;
```

```javascript
// main.js - import default
import User from './user.js';

const user = new User('Alice', 30);
console.log(user.greet());

// Can name it anything
import MyUser from './user.js';
```

### Mixed Exports

```javascript
// api.js
export default class API {
  constructor(baseUrl) {
    this.baseUrl = baseUrl;
  }
  
  async get(path) {
    return fetch(`${this.baseUrl}${path}`);
  }
}

export const API_VERSION = '1.0';
export const API_TIMEOUT = 5000;
```

```javascript
// main.js
import API, { API_VERSION, API_TIMEOUT } from './api.js';

const api = new API('https://api.example.com');
console.log(`API v${API_VERSION}, timeout: ${API_TIMEOUT}ms`);
```

### Re-exporting

```javascript
// utils/index.js - barrel export
export { add, multiply } from './math.js';
export { formatDate } from './date.js';
export { default as User } from './user.js';

// Re-export all
export * from './validators.js';

// Re-export with rename
export { validateEmail as checkEmail } from './validators.js';
```

```javascript
// main.js
import { add, formatDate, User } from './utils/index.js';
```

### Dynamic Imports

```javascript
// Lazy loading (async)
async function loadModule() {
  const module = await import('./heavy-module.js');
  module.doSomething();
}

// Conditional loading
if (condition) {
  const { feature } = await import('./feature.js');
  feature();
}

// Dynamic path
const language = 'en';
const translations = await import(`./i18n/${language}.js`);

// Error handling
try {
  const module = await import('./optional-module.js');
} catch (error) {
  console.log('Module not found');
}
```

### Module Patterns

```javascript
// config.js - configuration
export const config = {
  apiUrl: process.env.API_URL || 'http://localhost:3000',
  timeout: 5000,
  retries: 3
};

// logger.js - singleton
class Logger {
  log(message) {
    console.log(`[${new Date().toISOString()}] ${message}`);
  }
  
  error(message) {
    console.error(`[ERROR] ${message}`);
  }
}

export default new Logger();

// validators.js - utilities
export const isEmail = (str) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(str);
export const isUrl = (str) => /^https?:\/\/.+/.test(str);
export const isEmpty = (str) => !str || str.trim().length === 0;

// user-service.js - service class
import { config } from './config.js';
import logger from './logger.js';

export class UserService {
  async getUser(id) {
    logger.log(`Fetching user ${id}`);
    const response = await fetch(`${config.apiUrl}/users/${id}`);
    return response.json();
  }
}
```

### Esempio Completo

```javascript
// models/user.js
export class User {
  constructor(id, name, email) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.createdAt = new Date();
  }
  
  toJSON() {
    return {
      id: this.id,
      name: this.name,
      email: this.email,
      createdAt: this.createdAt.toISOString()
    };
  }
}

export class Admin extends User {
  constructor(id, name, email, permissions) {
    super(id, name, email);
    this.permissions = permissions;
  }
}

// utils/validators.js
export const isEmail = (str) => {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(str);
};

export const isValidName = (str) => {
  return str && str.trim().length >= 2;
};

export const validate = (user) => {
  const errors = [];
  
  if (!isValidName(user.name)) {
    errors.push('Invalid name');
  }
  
  if (!isEmail(user.email)) {
    errors.push('Invalid email');
  }
  
  return errors.length === 0 ? null : errors;
};

// utils/logger.js
class Logger {
  constructor(prefix = 'APP') {
    this.prefix = prefix;
  }
  
  log(message) {
    console.log(`[${this.prefix}] ${message}`);
  }
  
  error(message) {
    console.error(`[${this.prefix}] ERROR: ${message}`);
  }
  
  info(message) {
    console.log(`[${this.prefix}] INFO: ${message}`);
  }
}

export default new Logger('UserService');

// services/user-service.js
import { User, Admin } from '../models/user.js';
import { validate } from '../utils/validators.js';
import logger from '../utils/logger.js';

export class UserService {
  constructor() {
    this.users = new Map();
    this.nextId = 1;
  }
  
  createUser(name, email, isAdmin = false) {
    logger.info(`Creating user: ${name}`);
    
    const userData = { name, email };
    const errors = validate(userData);
    
    if (errors) {
      logger.error(`Validation failed: ${errors.join(', ')}`);
      throw new Error(`Validation failed: ${errors.join(', ')}`);
    }
    
    const id = this.nextId++;
    const user = isAdmin
      ? new Admin(id, name, email, ['read', 'write', 'delete'])
      : new User(id, name, email);
    
    this.users.set(id, user);
    logger.log(`User created: ${id}`);
    
    return user;
  }
  
  getUser(id) {
    const user = this.users.get(id);
    if (!user) {
      throw new Error(`User not found: ${id}`);
    }
    return user;
  }
  
  getAllUsers() {
    return Array.from(this.users.values());
  }
  
  deleteUser(id) {
    logger.info(`Deleting user: ${id}`);
    return this.users.delete(id);
  }
}

export const userService = new UserService();

// utils/index.js - barrel export
export * from './validators.js';
export { default as logger } from './logger.js';

// config.js
export const config = {
  appName: 'User Management System',
  version: '1.0.0',
  maxUsers: 1000,
  features: {
    authentication: true,
    logging: true
  }
};

export default config;

// index.js - main entry point
#!/usr/bin/env node

import { userService } from './services/user-service.js';
import { isEmail, logger } from './utils/index.js';
import config from './config.js';

async function demonstrateStaticImports() {
  console.log('=== Static Imports Demo ===\n');
  
  console.log(`${config.appName} v${config.version}\n`);
  
  // Create users
  try {
    const user1 = userService.createUser('Alice Smith', 'alice@example.com');
    const user2 = userService.createUser('Bob Jones', 'bob@example.com', true);
    
    console.log('Created users:');
    console.log('- User:', user1.toJSON());
    console.log('- Admin:', user2.toJSON());
    
    // Validate email
    console.log('\nEmail validation:');
    console.log('alice@example.com:', isEmail('alice@example.com'));
    console.log('invalid-email:', isEmail('invalid-email'));
    
    // Get all users
    console.log('\nAll users:', userService.getAllUsers().length);
    
    // Invalid user
    console.log('\nTrying to create invalid user...');
    userService.createUser('A', 'invalid-email');
  } catch (error) {
    logger.error(error.message);
  }
}

async function demonstrateDynamicImports() {
  console.log('\n=== Dynamic Imports Demo ===\n');
  
  // Lazy load module
  console.log('Lazy loading stats module...');
  
  // Simulate conditional feature
  const enableStats = true;
  
  if (enableStats) {
    // Dynamic import (would be a separate file)
    const statsModule = {
      getStats: (users) => ({
        total: users.length,
        admins: users.filter(u => u.permissions).length,
        regular: users.filter(u => !u.permissions).length
      })
    };
    
    const users = userService.getAllUsers();
    const stats = statsModule.getStats(users);
    console.log('Stats:', stats);
  }
}

async function main() {
  console.log('=== ES Modules Demo ===\n');
  
  await demonstrateStaticImports();
  await demonstrateDynamicImports();
  
  console.log('\n✓ Complete!');
}

main().catch(console.error);
```

### File Structure Example

```
project/
├── package.json          (with "type": "module")
├── index.js             (main entry point)
├── config.js            (configuration)
├── models/
│   └── user.js          (User, Admin classes)
├── services/
│   └── user-service.js  (UserService)
└── utils/
    ├── index.js         (barrel export)
    ├── logger.js        (Logger singleton)
    └── validators.js    (validation functions)
```

## Requisiti
- [ ] Abilita ES Modules (`"type": "module"`)
- [ ] Usa `export` per esportare
- [ ] Usa `import` per importare
- [ ] Esporta named e default exports
- [ ] Organizza codice in file multipli
- [ ] Codice eseguibile

## Risorse
- [MDN - import](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import)
- [MDN - export](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export)
- [Node.js ESM](https://nodejs.org/api/esm.html)
- [JavaScript.info - Modules](https://javascript.info/modules-intro)

## Note
ES Modules richiedono `"type": "module"` in package.json o `.mjs` extension. Import paths devono includere `.js` extension. Static imports sono hoisted, dynamic imports sono async. Use barrel exports (`index.js`) per raggruppare exports.

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
