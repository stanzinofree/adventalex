# File Read/Write

## Obiettivo

Padroneggiare le operazioni di **file I/O** con **fs.promises** per leggere e scrivere file in modo asincrono. Il file system è essenziale per gestire dati persistenti, configurazioni, log e molto altro.

### Contesto Pratico

File operations sono essenziali per:
- **Configuration files**: JSON, YAML, ENV
- **Data persistence**: save/load application data
- **Logging**: write logs to files
- **File processing**: ETL, data transformation
- **Static assets**: templates, images, documents

Vantaggi fs.promises:
- **Async/await**: sintassi moderna
- **Non-blocking**: performance migliori
- **Error handling**: try/catch naturale
- **Promise-based**: composable con altre APIs

### Setup

```javascript
// Import fs.promises
import { promises as fs } from 'fs';
// or
import fs from 'fs/promises';

// Alternative: destructure specific methods
import { readFile, writeFile } from 'fs/promises';
```

### Reading Files

```javascript
import fs from 'fs/promises';

// Read text file
async function readTextFile() {
  try {
    const content = await fs.readFile('./file.txt', 'utf8');
    console.log(content);
    return content;
  } catch (error) {
    console.error('Error reading file:', error.message);
    throw error;
  }
}

// Read JSON file
async function readJSONFile(path) {
  const content = await fs.readFile(path, 'utf8');
  return JSON.parse(content);
}

// Read binary file
async function readBinaryFile(path) {
  const buffer = await fs.readFile(path);  // No encoding = Buffer
  return buffer;
}

// Check if file exists
async function fileExists(path) {
  try {
    await fs.access(path);
    return true;
  } catch {
    return false;
  }
}
```

### Writing Files

```javascript
import fs from 'fs/promises';

// Write text file
async function writeTextFile(path, content) {
  try {
    await fs.writeFile(path, content, 'utf8');
    console.log('File written successfully');
  } catch (error) {
    console.error('Error writing file:', error.message);
    throw error;
  }
}

// Write JSON file
async function writeJSONFile(path, data) {
  const json = JSON.stringify(data, null, 2);
  await fs.writeFile(path, json, 'utf8');
}

// Append to file
async function appendToFile(path, content) {
  await fs.appendFile(path, content, 'utf8');
}

// Write with options
async function writeWithOptions(path, content) {
  await fs.writeFile(path, content, {
    encoding: 'utf8',
    mode: 0o644,      // File permissions
    flag: 'w'         // Write mode
  });
}
```

### Directory Operations

```javascript
import fs from 'fs/promises';

// Create directory
async function createDir(path) {
  await fs.mkdir(path, { recursive: true });
  // recursive: true creates parent directories if needed
}

// Read directory contents
async function listFiles(path) {
  const files = await fs.readdir(path);
  return files;
}

// Read directory with file types
async function listFilesWithTypes(path) {
  const entries = await fs.readdir(path, { withFileTypes: true });
  
  const files = entries
    .filter(entry => entry.isFile())
    .map(entry => entry.name);
  
  const dirs = entries
    .filter(entry => entry.isDirectory())
    .map(entry => entry.name);
  
  return { files, dirs };
}

// Remove directory
async function removeDir(path) {
  await fs.rmdir(path);  // Only if empty
}

// Remove directory recursively
async function removeDirRecursive(path) {
  await fs.rm(path, { recursive: true, force: true });
}
```

### File Stats

```javascript
import fs from 'fs/promises';

// Get file info
async function getFileStats(path) {
  const stats = await fs.stat(path);
  
  return {
    size: stats.size,                    // bytes
    created: stats.birthtime,            // creation date
    modified: stats.mtime,               // modification date
    isFile: stats.isFile(),
    isDirectory: stats.isDirectory(),
    permissions: stats.mode.toString(8)
  };
}

// Check file age
async function isFileOlderThan(path, days) {
  const stats = await fs.stat(path);
  const ageMs = Date.now() - stats.mtime.getTime();
  const ageDays = ageMs / (1000 * 60 * 60 * 24);
  return ageDays > days;
}
```

### File Operations

```javascript
import fs from 'fs/promises';

// Copy file
async function copyFile(source, destination) {
  await fs.copyFile(source, destination);
}

// Move/rename file
async function moveFile(oldPath, newPath) {
  await fs.rename(oldPath, newPath);
}

// Delete file
async function deleteFile(path) {
  await fs.unlink(path);
}

// Delete if exists
async function deleteIfExists(path) {
  try {
    await fs.unlink(path);
    return true;
  } catch (error) {
    if (error.code === 'ENOENT') {
      return false;  // File didn't exist
    }
    throw error;  // Other error
  }
}
```

### Error Handling

```javascript
import fs from 'fs/promises';

// Handle specific errors
async function safeReadFile(path) {
  try {
    return await fs.readFile(path, 'utf8');
  } catch (error) {
    switch (error.code) {
      case 'ENOENT':
        console.log('File not found');
        return null;
      case 'EACCES':
        console.log('Permission denied');
        return null;
      case 'EISDIR':
        console.log('Path is a directory');
        return null;
      default:
        throw error;
    }
  }
}

// With default value
async function readWithDefault(path, defaultValue = '') {
  try {
    return await fs.readFile(path, 'utf8');
  } catch {
    return defaultValue;
  }
}
```

### Practical Patterns

```javascript
import fs from 'fs/promises';

// Load config with fallback
async function loadConfig(path = './config.json') {
  try {
    const content = await fs.readFile(path, 'utf8');
    return JSON.parse(content);
  } catch (error) {
    console.log('Using default config');
    return { debug: false, port: 3000 };
  }
}

// Save config
async function saveConfig(config, path = './config.json') {
  const json = JSON.stringify(config, null, 2);
  await fs.writeFile(path, json, 'utf8');
}

// Atomic write (write to temp, then rename)
async function atomicWrite(path, content) {
  const tempPath = `${path}.tmp`;
  await fs.writeFile(tempPath, content, 'utf8');
  await fs.rename(tempPath, path);
}

// Backup before write
async function writeWithBackup(path, content) {
  const exists = await fileExists(path);
  
  if (exists) {
    const backupPath = `${path}.backup`;
    await fs.copyFile(path, backupPath);
  }
  
  await fs.writeFile(path, content, 'utf8');
}

// Process files in directory
async function processDirectory(dirPath, processFn) {
  const files = await fs.readdir(dirPath);
  
  for (const file of files) {
    const filePath = `${dirPath}/${file}`;
    const stats = await fs.stat(filePath);
    
    if (stats.isFile()) {
      await processFn(filePath);
    }
  }
}
```

### Esempio Completo

```javascript
#!/usr/bin/env node

import fs from 'fs/promises';
import path from 'path';

// Constants
const DATA_DIR = './data';
const USERS_FILE = path.join(DATA_DIR, 'users.json');
const LOG_FILE = path.join(DATA_DIR, 'app.log');

// Initialize data directory
async function initDataDir() {
  try {
    await fs.mkdir(DATA_DIR, { recursive: true });
    console.log('✓ Data directory ready');
  } catch (error) {
    console.error('Error creating data directory:', error.message);
    throw error;
  }
}

// Logger
async function log(message) {
  const timestamp = new Date().toISOString();
  const logEntry = `[${timestamp}] ${message}\n`;
  
  try {
    await fs.appendFile(LOG_FILE, logEntry, 'utf8');
  } catch (error) {
    console.error('Error writing log:', error.message);
  }
}

// Load users
async function loadUsers() {
  try {
    const content = await fs.readFile(USERS_FILE, 'utf8');
    const users = JSON.parse(content);
    await log(`Loaded ${users.length} users`);
    return users;
  } catch (error) {
    if (error.code === 'ENOENT') {
      await log('No users file found, creating new');
      return [];
    }
    throw error;
  }
}

// Save users
async function saveUsers(users) {
  const json = JSON.stringify(users, null, 2);
  
  // Atomic write with backup
  const tempFile = `${USERS_FILE}.tmp`;
  
  try {
    // Write to temp file
    await fs.writeFile(tempFile, json, 'utf8');
    
    // Backup existing file
    try {
      await fs.access(USERS_FILE);
      const backupFile = `${USERS_FILE}.backup`;
      await fs.copyFile(USERS_FILE, backupFile);
    } catch {
      // No existing file, skip backup
    }
    
    // Rename temp to actual file
    await fs.rename(tempFile, USERS_FILE);
    await log(`Saved ${users.length} users`);
  } catch (error) {
    // Clean up temp file on error
    try {
      await fs.unlink(tempFile);
    } catch {}
    throw error;
  }
}

// Add user
async function addUser(name, email) {
  const users = await loadUsers();
  
  const newUser = {
    id: users.length + 1,
    name,
    email,
    createdAt: new Date().toISOString()
  };
  
  users.push(newUser);
  await saveUsers(users);
  await log(`Added user: ${name} (${email})`);
  
  return newUser;
}

// Get user by ID
async function getUser(id) {
  const users = await loadUsers();
  return users.find(u => u.id === id);
}

// Get all users
async function getAllUsers() {
  return await loadUsers();
}

// Delete user
async function deleteUser(id) {
  const users = await loadUsers();
  const index = users.findIndex(u => u.id === id);
  
  if (index === -1) {
    throw new Error(`User ${id} not found`);
  }
  
  const deleted = users.splice(index, 1)[0];
  await saveUsers(users);
  await log(`Deleted user: ${deleted.name}`);
  
  return deleted;
}

// Get file info
async function getFileInfo(filePath) {
  try {
    const stats = await fs.stat(filePath);
    return {
      path: filePath,
      size: stats.size,
      created: stats.birthtime,
      modified: stats.mtime,
      isFile: stats.isFile(),
      isDirectory: stats.isDirectory()
    };
  } catch (error) {
    return null;
  }
}

// List data files
async function listDataFiles() {
  try {
    const files = await fs.readdir(DATA_DIR);
    const fileInfos = [];
    
    for (const file of files) {
      const filePath = path.join(DATA_DIR, file);
      const info = await getFileInfo(filePath);
      if (info && info.isFile) {
        fileInfos.push({ name: file, ...info });
      }
    }
    
    return fileInfos;
  } catch (error) {
    return [];
  }
}

// Clean old backups
async function cleanBackups(maxAge = 7) {
  const files = await fs.readdir(DATA_DIR);
  const backupFiles = files.filter(f => f.endsWith('.backup'));
  
  for (const file of backupFiles) {
    const filePath = path.join(DATA_DIR, file);
    const stats = await fs.stat(filePath);
    const ageDays = (Date.now() - stats.mtime.getTime()) / (1000 * 60 * 60 * 24);
    
    if (ageDays > maxAge) {
      await fs.unlink(filePath);
      await log(`Deleted old backup: ${file}`);
    }
  }
}

// Main demo
async function main() {
  console.log('=== File Read/Write Demo ===\n');
  
  try {
    // 1. Initialize
    console.log('=== Initialization ===');
    await initDataDir();
    
    // 2. Add users
    console.log('\n=== Adding Users ===');
    await addUser('Alice Smith', 'alice@example.com');
    await addUser('Bob Jones', 'bob@example.com');
    await addUser('Charlie Brown', 'charlie@example.com');
    console.log('✓ Users added');
    
    // 3. List users
    console.log('\n=== All Users ===');
    const users = await getAllUsers();
    users.forEach(u => {
      console.log(`${u.id}. ${u.name} (${u.email})`);
    });
    
    // 4. Get specific user
    console.log('\n=== Get User ===');
    const user = await getUser(2);
    console.log('Found:', user);
    
    // 5. File info
    console.log('\n=== File Info ===');
    const usersInfo = await getFileInfo(USERS_FILE);
    if (usersInfo) {
      console.log('Users file:');
      console.log(`  Size: ${usersInfo.size} bytes`);
      console.log(`  Modified: ${usersInfo.modified.toISOString()}`);
    }
    
    // 6. List all data files
    console.log('\n=== Data Files ===');
    const dataFiles = await listDataFiles();
    dataFiles.forEach(f => {
      console.log(`  ${f.name} (${f.size} bytes)`);
    });
    
    // 7. Delete user
    console.log('\n=== Delete User ===');
    const deleted = await deleteUser(2);
    console.log('Deleted:', deleted.name);
    
    // 8. Verify deletion
    const remaining = await getAllUsers();
    console.log(`Remaining users: ${remaining.length}`);
    
    // 9. Clean old backups
    console.log('\n=== Cleanup ===');
    await cleanBackups(7);
    console.log('✓ Cleanup complete');
    
    console.log('\n✓ Complete!');
  } catch (error) {
    console.error('\n✗ Error:', error.message);
    await log(`Error: ${error.message}`);
    process.exit(1);
  }
}

main();
```

## Requisiti
- [ ] Usa `fs.promises` o `fs/promises`
- [ ] Leggi file con `readFile()`
- [ ] Scrivi file con `writeFile()`
- [ ] Gestisci directory con `mkdir()`, `readdir()`
- [ ] Error handling con try/catch
- [ ] Codice eseguibile

## Risorse
- [Node.js - fs.promises](https://nodejs.org/api/fs.html#promises-api)
- [MDN - File System](https://developer.mozilla.org/en-US/docs/Web/API/File_System_Access_API)
- [Node.js - Path](https://nodejs.org/api/path.html)

## Note
Usa sempre **fs.promises** per async operations. Gestisci errori comuni: `ENOENT` (file not found), `EACCES` (permission denied), `EISDIR` (is directory). Use `path.join()` per cross-platform paths. Implementa backup strategy per write operations critiche.

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
