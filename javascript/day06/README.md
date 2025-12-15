# Async/Await

## Obiettivo

Padroneggiare **async/await** per scrivere codice asincrono che sembra sincrono. Async/await è syntactic sugar sopra le Promise che rende il codice asincrono più leggibile e facile da debuggare.

### Contesto Pratico

Async/await è essenziale per:
- **API integration**: REST, GraphQL calls
- **Database operations**: queries, transactions
- **File operations**: read, write, process
- **Complex async flows**: multi-step operations
- **Error handling**: try/catch naturale

Vantaggi:
- **Leggibilità**: codice lineare, top-to-bottom
- **Error handling**: try/catch standard
- **Debugging**: stack traces migliori
- **Control flow**: if/else, loops naturali

### Async Function Basics

```javascript
// Promise way
function fetchUser() {
  return fetch('/api/user')
    .then(response => response.json())
    .then(data => {
      console.log(data);
      return data;
    });
}

// Async/await way
async function fetchUser() {
  const response = await fetch('/api/user');
  const data = await response.json();
  console.log(data);
  return data;
}

// Arrow function
const fetchUser = async () => {
  const response = await fetch('/api/user');
  return response.json();
};

// Note: async function sempre ritorna una Promise
const result = fetchUser();  // Returns Promise
result.then(data => console.log(data));
```

### Await Keyword

```javascript
// await can only be used inside async function
async function example() {
  // Wait for promise to resolve
  const result = await somePromise();
  console.log(result);
  
  // Multiple awaits (sequential)
  const user = await fetchUser();
  const posts = await fetchPosts(user.id);
  const comments = await fetchComments(posts[0].id);
  
  return { user, posts, comments };
}

// Top-level await (ES2022, in modules only)
// const data = await fetchData();
```

### Error Handling

```javascript
// try/catch for error handling
async function fetchUserData(id) {
  try {
    const user = await fetchUser(id);
    const posts = await fetchPosts(user.id);
    return { user, posts };
  } catch (error) {
    console.error('Error:', error.message);
    throw error;  // Re-throw if needed
  }
}

// Multiple try/catch
async function complexOperation() {
  let user;
  
  try {
    user = await fetchUser(1);
  } catch (error) {
    console.error('User fetch failed:', error);
    return null;
  }
  
  try {
    const posts = await fetchPosts(user.id);
    return { user, posts };
  } catch (error) {
    console.error('Posts fetch failed:', error);
    return { user, posts: [] };  // Partial data
  }
}

// finally for cleanup
async function withCleanup() {
  const connection = await openConnection();
  
  try {
    const data = await fetchData(connection);
    return data;
  } catch (error) {
    console.error('Error:', error);
    throw error;
  } finally {
    await closeConnection(connection);  // Always runs
  }
}
```

### Sequential vs Parallel

```javascript
// Sequential (slow) - one after another
async function sequential() {
  const user1 = await fetchUser(1);    // Wait 500ms
  const user2 = await fetchUser(2);    // Wait 500ms
  const user3 = await fetchUser(3);    // Wait 500ms
  return [user1, user2, user3];        // Total: 1500ms
}

// Parallel (fast) - all at once
async function parallel() {
  const [user1, user2, user3] = await Promise.all([
    fetchUser(1),
    fetchUser(2),
    fetchUser(3)
  ]);
  return [user1, user2, user3];  // Total: 500ms
}

// Mixed approach
async function mixed() {
  // Parallel fetch users
  const users = await Promise.all([
    fetchUser(1),
    fetchUser(2),
    fetchUser(3)
  ]);
  
  // Sequential process (depends on previous result)
  const allPosts = [];
  for (const user of users) {
    const posts = await fetchPosts(user.id);
    allPosts.push(...posts);
  }
  
  return { users, allPosts };
}
```

### Async Loops

```javascript
// for...of loop (sequential)
async function processSequential(items) {
  for (const item of items) {
    const result = await processItem(item);
    console.log(result);
  }
}

// map with Promise.all (parallel)
async function processParallel(items) {
  const results = await Promise.all(
    items.map(item => processItem(item))
  );
  return results;
}

// forEach doesn't work with async!
// ❌ Wrong
items.forEach(async item => {
  await processItem(item);  // Won't wait!
});

// ✅ Correct
for (const item of items) {
  await processItem(item);
}
```

### Async Patterns

```javascript
// Retry with async/await
async function retry(fn, maxRetries = 3, delay = 1000) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      console.log(`Retry ${i + 1}/${maxRetries}...`);
      await wait(delay);
    }
  }
}

// Timeout
async function withTimeout(promise, ms) {
  const timeout = new Promise((_, reject) => {
    setTimeout(() => reject(new Error('Timeout')), ms);
  });
  return Promise.race([promise, timeout]);
}

// Rate limiting
async function rateLimit(tasks, limit, delayMs) {
  const results = [];
  for (let i = 0; i < tasks.length; i += limit) {
    const batch = tasks.slice(i, i + limit);
    const batchResults = await Promise.all(batch.map(t => t()));
    results.push(...batchResults);
    if (i + limit < tasks.length) {
      await wait(delayMs);
    }
  }
  return results;
}

// Helper
const wait = (ms) => new Promise(resolve => setTimeout(resolve, ms));
```

### Esempio Completo

```javascript
#!/usr/bin/env node

// Simulate async operations
const wait = (ms) => new Promise(resolve => setTimeout(resolve, ms));

const fetchUser = async (id) => {
  await wait(300);
  if (id <= 0) throw new Error('Invalid user ID');
  return { id, name: `User ${id}`, email: `user${id}@example.com` };
};

const fetchPosts = async (userId) => {
  await wait(300);
  return [
    { id: 1, userId, title: 'First Post', likes: 10 },
    { id: 2, userId, title: 'Second Post', likes: 25 },
    { id: 3, userId, title: 'Third Post', likes: 5 }
  ];
};

const fetchComments = async (postId) => {
  await wait(300);
  return [
    { id: 1, postId, text: 'Great!' },
    { id: 2, postId, text: 'Thanks!' }
  ];
};

// Load complete user profile
async function loadUserProfile(userId) {
  try {
    console.log(`Loading profile for user ${userId}...`);
    
    const user = await fetchUser(userId);
    console.log(`✓ User: ${user.name}`);
    
    const posts = await fetchPosts(user.id);
    console.log(`✓ Posts: ${posts.length}`);
    
    // Load comments for first post
    if (posts.length > 0) {
      const comments = await fetchComments(posts[0].id);
      console.log(`✓ Comments: ${comments.length}`);
      return { user, posts, comments };
    }
    
    return { user, posts, comments: [] };
  } catch (error) {
    console.error(`✗ Error loading profile: ${error.message}`);
    throw error;
  }
}

// Load multiple users in parallel
async function loadMultipleUsers(userIds) {
  console.log('Loading multiple users in parallel...');
  
  try {
    const users = await Promise.all(
      userIds.map(id => fetchUser(id))
    );
    console.log(`✓ Loaded ${users.length} users`);
    return users;
  } catch (error) {
    console.error('✗ Error loading users:', error.message);
    throw error;
  }
}

// Process items sequentially
async function processSequential(userIds) {
  console.log('Processing sequentially...');
  const results = [];
  
  for (const id of userIds) {
    try {
      const user = await fetchUser(id);
      const posts = await fetchPosts(user.id);
      results.push({ user, postCount: posts.length });
      console.log(`✓ Processed ${user.name}: ${posts.length} posts`);
    } catch (error) {
      console.error(`✗ Failed to process user ${id}`);
    }
  }
  
  return results;
}

// Retry mechanism
async function retryOperation(fn, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxRetries) {
        throw new Error(`Failed after ${maxRetries} attempts: ${error.message}`);
      }
      console.log(`Attempt ${attempt} failed, retrying...`);
      await wait(500);
    }
  }
}

// With timeout
async function withTimeout(promise, timeoutMs) {
  const timeout = new Promise((_, reject) => {
    setTimeout(() => reject(new Error('Operation timeout')), timeoutMs);
  });
  return Promise.race([promise, timeout]);
}

// Rate-limited batch processing
async function processBatch(items, batchSize = 2) {
  console.log(`Processing ${items.length} items in batches of ${batchSize}...`);
  const results = [];
  
  for (let i = 0; i < items.length; i += batchSize) {
    const batch = items.slice(i, i + batchSize);
    console.log(`Batch ${Math.floor(i / batchSize) + 1}...`);
    
    const batchResults = await Promise.all(
      batch.map(id => fetchUser(id))
    );
    
    results.push(...batchResults);
    
    // Delay between batches
    if (i + batchSize < items.length) {
      await wait(200);
    }
  }
  
  return results;
}

// Main execution
async function main() {
  console.log('=== Async/Await Demo ===\n');
  
  try {
    // 1. Single user profile
    console.log('=== Single User Profile ===');
    const profile = await loadUserProfile(1);
    console.log(`Profile loaded: ${profile.user.name}\n`);
    
    // 2. Multiple users (parallel)
    console.log('=== Parallel Loading ===');
    const users = await loadMultipleUsers([1, 2, 3]);
    console.log(`Users: ${users.map(u => u.name).join(', ')}\n`);
    
    // 3. Sequential processing
    console.log('=== Sequential Processing ===');
    const results = await processSequential([1, 2, 3]);
    console.log(`Processed ${results.length} users\n`);
    
    // 4. Error handling
    console.log('=== Error Handling ===');
    try {
      await fetchUser(-1);
    } catch (error) {
      console.log(`Caught error: ${error.message}\n`);
    }
    
    // 5. Retry mechanism
    console.log('=== Retry Mechanism ===');
    let attemptCount = 0;
    const unreliable = async () => {
      attemptCount++;
      if (attemptCount < 3) throw new Error('Temporary failure');
      return 'Success!';
    };
    const retried = await retryOperation(unreliable);
    console.log(`Result: ${retried}\n`);
    
    // 6. With timeout
    console.log('=== With Timeout ===');
    const fast = await withTimeout(fetchUser(1), 1000);
    console.log(`Completed within timeout: ${fast.name}\n`);
    
    // 7. Batch processing
    console.log('=== Batch Processing ===');
    const batched = await processBatch([1, 2, 3, 4, 5], 2);
    console.log(`Batched results: ${batched.length} users\n`);
    
    // 8. Promise.allSettled
    console.log('=== Promise.allSettled ===');
    const settled = await Promise.allSettled([
      fetchUser(1),
      fetchUser(-1),  // Will fail
      fetchUser(2)
    ]);
    
    settled.forEach((result, i) => {
      if (result.status === 'fulfilled') {
        console.log(`✓ User ${i + 1}: ${result.value.name}`);
      } else {
        console.log(`✗ User ${i + 1}: ${result.reason.message}`);
      }
    });
    
    console.log('\n✓ Complete!');
  } catch (error) {
    console.error('\n✗ Fatal error:', error.message);
    process.exit(1);
  }
}

main();
```

## Requisiti
- [ ] Definisci `async` functions
- [ ] Usa `await` per wait promises
- [ ] Usa `try/catch` per error handling
- [ ] Combina con `Promise.all()` per parallelo
- [ ] Gestisci loops async correttamente
- [ ] Codice eseguibile

## Risorse
- [MDN - async function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)
- [MDN - await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await)
- [JavaScript.info - Async/await](https://javascript.info/async-await)

## Note
`async` function ritorna sempre una Promise. `await` pausa execution fino a Promise resolution. Usa `Promise.all()` per parallelismo, `await` in loop per sequenziale. `try/catch` è più naturale di `.catch()`.

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
