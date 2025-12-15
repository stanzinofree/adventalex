# Promises

## Obiettivo

Comprendere le **Promises** in JavaScript per gestire operazioni asincrone in modo elegante. Le Promise rappresentano il risultato futuro di un'operazione asincrona e risolvono il problema del "callback hell".

### Contesto Pratico

Promises sono essenziali per:
- **API calls**: fetch, HTTP requests
- **File I/O**: read/write operazioni
- **Database queries**: async database operations
- **Timers**: setTimeout, setInterval async
- **User interactions**: async validations

Vantaggi:
- **Chaining**: `.then()` sequenziale e leggibile
- **Error handling**: `.catch()` centralizzato
- **Composizione**: `Promise.all()`, `Promise.race()`
- **Evita callback hell**: codice lineare

### Promise States

```javascript
// Promise ha 3 stati:
// 1. pending: operazione in corso
// 2. fulfilled: operazione completata con successo
// 3. rejected: operazione fallita

// Creating a promise
const promise = new Promise((resolve, reject) => {
  const success = true;
  
  if (success) {
    resolve('Operation successful!');
  } else {
    reject('Operation failed!');
  }
});

// Using the promise
promise
  .then(result => console.log(result))
  .catch(error => console.error(error));
```

### Basic Promise Usage

```javascript
// Simulate async operation
const fetchUser = (id) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (id > 0) {
        resolve({ id, name: 'Alice', email: 'alice@example.com' });
      } else {
        reject(new Error('Invalid user ID'));
      }
    }, 1000);
  });
};

// Use promise
fetchUser(1)
  .then(user => {
    console.log('User:', user);
    return user.id;
  })
  .then(id => {
    console.log('User ID:', id);
  })
  .catch(error => {
    console.error('Error:', error.message);
  })
  .finally(() => {
    console.log('Operation complete');
  });
```

### Promise Chaining

```javascript
// Sequential operations
const step1 = () => {
  return new Promise(resolve => {
    setTimeout(() => resolve('Step 1 done'), 500);
  });
};

const step2 = (prev) => {
  return new Promise(resolve => {
    setTimeout(() => resolve(`${prev} -> Step 2 done`), 500);
  });
};

const step3 = (prev) => {
  return new Promise(resolve => {
    setTimeout(() => resolve(`${prev} -> Step 3 done`), 500);
  });
};

// Chain them
step1()
  .then(result1 => {
    console.log(result1);
    return step2(result1);
  })
  .then(result2 => {
    console.log(result2);
    return step3(result2);
  })
  .then(result3 => {
    console.log(result3);
  })
  .catch(error => {
    console.error('Error in chain:', error);
  });
```

### Error Handling

```javascript
// Multiple catch points
fetchData()
  .then(data => {
    return processData(data);
  })
  .catch(error => {
    console.error('Fetch error:', error);
    return null; // Recovery value
  })
  .then(processed => {
    return saveData(processed);
  })
  .catch(error => {
    console.error('Save error:', error);
  });

// Catch at end (catches all)
fetchData()
  .then(processData)
  .then(saveData)
  .catch(error => {
    console.error('Any error:', error);
  });

// Finally always runs
promise
  .then(result => console.log(result))
  .catch(error => console.error(error))
  .finally(() => {
    console.log('Cleanup');
  });
```

### Promise Combinators

```javascript
// Promise.all() - wait for all
const p1 = Promise.resolve(1);
const p2 = Promise.resolve(2);
const p3 = Promise.resolve(3);

Promise.all([p1, p2, p3])
  .then(results => {
    console.log(results);  // [1, 2, 3]
  });

// If one fails, all fails
Promise.all([
  Promise.resolve(1),
  Promise.reject('Error'),
  Promise.resolve(3)
])
  .catch(error => {
    console.log('Failed:', error);  // 'Error'
  });

// Promise.allSettled() - wait for all, never rejects
Promise.allSettled([
  Promise.resolve(1),
  Promise.reject('Error'),
  Promise.resolve(3)
])
  .then(results => {
    console.log(results);
    // [
    //   { status: 'fulfilled', value: 1 },
    //   { status: 'rejected', reason: 'Error' },
    //   { status: 'fulfilled', value: 3 }
    // ]
  });

// Promise.race() - first to settle wins
Promise.race([
  new Promise(resolve => setTimeout(() => resolve('slow'), 1000)),
  new Promise(resolve => setTimeout(() => resolve('fast'), 100))
])
  .then(result => {
    console.log(result);  // 'fast'
  });

// Promise.any() - first to fulfill wins
Promise.any([
  Promise.reject('Error 1'),
  new Promise(resolve => setTimeout(() => resolve('Success'), 100)),
  Promise.reject('Error 2')
])
  .then(result => {
    console.log(result);  // 'Success'
  });
```

### Promisifying Functions

```javascript
// Convert callback to promise
const wait = (ms) => {
  return new Promise(resolve => setTimeout(resolve, ms));
};

// Usage
wait(1000).then(() => console.log('1 second passed'));

// Promisify Node.js callback
const fs = require('fs');

const readFilePromise = (path) => {
  return new Promise((resolve, reject) => {
    fs.readFile(path, 'utf8', (err, data) => {
      if (err) reject(err);
      else resolve(data);
    });
  });
};

// Usage
readFilePromise('./file.txt')
  .then(content => console.log(content))
  .catch(error => console.error(error));
```

### Exemplo Completo

```javascript
#!/usr/bin/env node

// Simulate API calls
const fetchUser = (id) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (id > 0) {
        resolve({ id, name: `User ${id}`, role: 'user' });
      } else {
        reject(new Error('Invalid user ID'));
      }
    }, 500);
  });
};

const fetchPosts = (userId) => {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve([
        { id: 1, userId, title: 'Post 1', likes: 10 },
        { id: 2, userId, title: 'Post 2', likes: 25 },
        { id: 3, userId, title: 'Post 3', likes: 5 }
      ]);
    }, 500);
  });
};

const fetchComments = (postId) => {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve([
        { id: 1, postId, text: 'Great post!' },
        { id: 2, postId, text: 'Thanks for sharing' }
      ]);
    }, 500);
  });
};

// Helper: wait function
const wait = (ms) => {
  return new Promise(resolve => setTimeout(resolve, ms));
};

// Sequential loading
const loadUserData = (userId) => {
  console.log(`Loading user ${userId}...`);
  
  return fetchUser(userId)
    .then(user => {
      console.log('User loaded:', user.name);
      return fetchPosts(user.id);
    })
    .then(posts => {
      console.log(`Found ${posts.length} posts`);
      return posts;
    })
    .catch(error => {
      console.error('Error loading user data:', error.message);
      throw error;
    });
};

// Parallel loading
const loadMultipleUsers = (userIds) => {
  console.log('Loading multiple users...');
  
  const promises = userIds.map(id => fetchUser(id));
  
  return Promise.all(promises)
    .then(users => {
      console.log(`Loaded ${users.length} users`);
      return users;
    });
};

// Race condition example
const fetchWithTimeout = (promise, timeout) => {
  const timeoutPromise = wait(timeout).then(() => {
    throw new Error('Request timeout');
  });
  
  return Promise.race([promise, timeoutPromise]);
};

// Retry logic
const retry = (fn, maxRetries = 3) => {
  return fn().catch(error => {
    if (maxRetries <= 1) {
      throw error;
    }
    console.log(`Retrying... (${maxRetries - 1} attempts left)`);
    return wait(1000).then(() => retry(fn, maxRetries - 1));
  });
};

function main() {
  console.log('=== Promises Demo ===\n');
  
  // 1. Sequential operations
  console.log('=== Sequential Loading ===');
  loadUserData(1)
    .then(posts => {
      console.log('Posts:', posts.map(p => p.title));
      
      // 2. Parallel loading
      console.log('\n=== Parallel Loading ===');
      return loadMultipleUsers([1, 2, 3]);
    })
    .then(users => {
      console.log('Users:', users.map(u => u.name));
      
      // 3. Promise.all with posts
      console.log('\n=== Promise.all ===');
      const postPromises = [1, 2, 3].map(id => fetchPosts(id));
      return Promise.all(postPromises);
    })
    .then(allPosts => {
      const total = allPosts.reduce((sum, posts) => sum + posts.length, 0);
      console.log(`Total posts: ${total}`);
      
      // 4. Promise.race
      console.log('\n=== Promise.race ===');
      return Promise.race([
        wait(100).then(() => 'Fast'),
        wait(500).then(() => 'Slow')
      ]);
    })
    .then(winner => {
      console.log('Winner:', winner);
      
      // 5. With timeout
      console.log('\n=== With Timeout ===');
      return fetchWithTimeout(fetchUser(1), 2000);
    })
    .then(user => {
      console.log('User within timeout:', user.name);
      
      // 6. Error handling
      console.log('\n=== Error Handling ===');
      return fetchUser(-1);  // Invalid ID
    })
    .catch(error => {
      console.log('Caught error:', error.message);
      
      // 7. Promise.allSettled
      console.log('\n=== Promise.allSettled ===');
      return Promise.allSettled([
        fetchUser(1),
        fetchUser(-1),  // Will fail
        fetchUser(2)
      ]);
    })
    .then(results => {
      results.forEach((result, i) => {
        if (result.status === 'fulfilled') {
          console.log(`User ${i + 1}: ${result.value.name}`);
        } else {
          console.log(`User ${i + 1}: Failed - ${result.reason.message}`);
        }
      });
    })
    .finally(() => {
      console.log('\n✓ Complete!');
    });
}

main();
```

## Requisiti
- [ ] Crea Promise con `new Promise()`
- [ ] Usa `.then()` per success handling
- [ ] Usa `.catch()` per error handling
- [ ] Chain multiple promises
- [ ] Usa `Promise.all()` o altri combinators
- [ ] Codice eseguibile

## Risorse
- [MDN - Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
- [MDN - Using Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises)
- [JavaScript.info - Promises](https://javascript.info/promise-basics)
- [Promises/A+ Spec](https://promisesaplus.com/)

## Note
Promises sono **chainable**: `.then()` ritorna sempre una nuova Promise. Usa `Promise.all()` per parallelo, chain `.then()` per sequenziale. `.catch()` cattura errori da tutte le promise precedenti.

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
