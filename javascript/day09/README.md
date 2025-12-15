# Path Manipulation

## Obiettivo

Padroneggiare il modulo **path** di Node.js per manipolare percorsi file/directory in modo cross-platform. Il modulo path garantisce che i tuoi percorsi funzionino su Windows, macOS e Linux.

### Contesto Pratico

Path manipulation è essenziale per:
- **Cross-platform code**: Windows usa `\`, Unix usa `/`
- **File operations**: costruire percorsi corretti
- **Module resolution**: import/require paths
- **Configuration**: gestire paths in config
- **Build tools**: webpack, bundlers, compilers

Vantaggi:
- **Platform-agnostic**: stesso codice su tutti OS
- **Path normalization**: risolve `.`, `..`, `/`
- **Safe joining**: previene path traversal
- **Extension handling**: extract, replace extensions

### Setup

```javascript
// Import path module
import path from 'path';

// Or destructure specific methods
import { join, resolve, basename, dirname, extname } from 'path';
```

### Basic Path Operations

```javascript
import path from 'path';

// Join paths
const joined = path.join('/users', 'alice', 'documents', 'file.txt');
// Unix: /users/alice/documents/file.txt
// Windows: \users\alice\documents\file.txt

// Resolve absolute path
const absolute = path.resolve('folder', 'file.txt');
// /current/working/directory/folder/file.txt

// Normalize path (fix .., ., multiple slashes)
const normalized = path.normalize('/users/alice/../bob/./file.txt');
// /users/bob/file.txt

// Get relative path
const relative = path.relative('/users/alice', '/users/bob/file.txt');
// ../bob/file.txt
```

### Path Components

```javascript
import path from 'path';

const filePath = '/users/alice/documents/report.pdf';

// Directory name
const dir = path.dirname(filePath);
// /users/alice/documents

// Base name (file name with extension)
const base = path.basename(filePath);
// report.pdf

// Base name without extension
const name = path.basename(filePath, '.pdf');
// report

// Extension
const ext = path.extname(filePath);
// .pdf

// Parse all components
const parsed = path.parse(filePath);
// {
//   root: '/',
//   dir: '/users/alice/documents',
//   base: 'report.pdf',
//   ext: '.pdf',
//   name: 'report'
// }

// Build from components
const formatted = path.format({
  dir: '/users/alice/documents',
  name: 'report',
  ext: '.pdf'
});
// /users/alice/documents/report.pdf
```

### Joining vs Resolving

```javascript
import path from 'path';

// join: concatenates segments
path.join('users', 'alice', 'file.txt');
// users/alice/file.txt (relative)

path.join('/users', 'alice', 'file.txt');
// /users/alice/file.txt (absolute if first segment is absolute)

// resolve: always returns absolute path
path.resolve('users', 'alice', 'file.txt');
// /current/working/dir/users/alice/file.txt

path.resolve('/users', 'alice', 'file.txt');
// /users/alice/file.txt

// resolve processes right-to-left until absolute
path.resolve('dir1', '/dir2', 'dir3');
// /dir2/dir3 (stops at /dir2)
```

### Path Separators

```javascript
import path from 'path';

// Platform-specific separator
console.log(path.sep);
// Unix: /
// Windows: \

// Delimiter for PATH environment variable
console.log(path.delimiter);
// Unix: :
// Windows: ;

// Build path with separator
const manual = ['users', 'alice', 'file.txt'].join(path.sep);

// Split path
const segments = '/users/alice/file.txt'.split(path.sep);
// ['', 'users', 'alice', 'file.txt']
```

### POSIX vs Windows

```javascript
import path from 'path';

// Use POSIX paths on any platform
import { posix } from 'path';
posix.join('users', 'alice', 'file.txt');
// Always: users/alice/file.txt

// Use Windows paths on any platform
import { win32 } from 'path';
win32.join('users', 'alice', 'file.txt');
// Always: users\alice\file.txt

// Platform detection
const isWindows = path.sep === '\\';
```

### Practical Patterns

```javascript
import path from 'path';
import { fileURLToPath } from 'url';

// Get current file directory (ES modules)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Build paths relative to current file
const configPath = path.join(__dirname, 'config.json');
const dataDir = path.join(__dirname, '..', 'data');

// Resolve from project root
const projectRoot = path.resolve(__dirname, '..');
const srcDir = path.join(projectRoot, 'src');

// Safe user input (prevent path traversal)
function safeJoin(base, userPath) {
  const result = path.join(base, userPath);
  const relative = path.relative(base, result);
  
  // Check if path escapes base directory
  if (relative.startsWith('..') || path.isAbsolute(relative)) {
    throw new Error('Invalid path');
  }
  
  return result;
}

// Change file extension
function changeExtension(filePath, newExt) {
  const parsed = path.parse(filePath);
  return path.format({
    ...parsed,
    base: undefined,  // Clear base to use name + ext
    ext: newExt.startsWith('.') ? newExt : `.${newExt}`
  });
}

// Get all parent directories
function getParents(filePath) {
  const parents = [];
  let current = path.dirname(filePath);
  
  while (current !== path.dirname(current)) {
    parents.push(current);
    current = path.dirname(current);
  }
  
  return parents;
}
```

### File Pattern Matching

```javascript
import path from 'path';

// Check extension
function hasExtension(filePath, ...exts) {
  const ext = path.extname(filePath).toLowerCase();
  return exts.some(e => ext === (e.startsWith('.') ? e : `.${e}`));
}

// Filter files by extension
function filterByExtension(files, ...exts) {
  return files.filter(file => hasExtension(file, ...exts));
}

// Get files with pattern
function matchPattern(files, pattern) {
  const regex = new RegExp(pattern);
  return files.filter(file => regex.test(path.basename(file)));
}

// Example usage
const files = [
  '/docs/report.pdf',
  '/docs/image.jpg',
  '/docs/data.json',
  '/docs/script.js'
];

const jsonFiles = filterByExtension(files, '.json', '.js');
const reportFiles = matchPattern(files, /^report/);
```

### Esempio Completo

```javascript
#!/usr/bin/env node

import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs/promises';

// Get current directory (ES modules)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Project structure helpers
class PathManager {
  constructor(projectRoot) {
    this.projectRoot = projectRoot;
  }
  
  // Get absolute path from project root
  resolve(...segments) {
    return path.join(this.projectRoot, ...segments);
  }
  
  // Get relative path from project root
  relative(absolutePath) {
    return path.relative(this.projectRoot, absolutePath);
  }
  
  // Check if path is inside project
  isInside(absolutePath) {
    const relative = this.relative(absolutePath);
    return !relative.startsWith('..') && !path.isAbsolute(relative);
  }
  
  // Get paths for common directories
  get srcDir() { return this.resolve('src'); }
  get dataDir() { return this.resolve('data'); }
  get configDir() { return this.resolve('config'); }
  get buildDir() { return this.resolve('build'); }
}

// File path utilities
class FilePathUtils {
  // Change extension
  static changeExtension(filePath, newExt) {
    const parsed = path.parse(filePath);
    return path.format({
      dir: parsed.dir,
      name: parsed.name,
      ext: newExt.startsWith('.') ? newExt : `.${newExt}`
    });
  }
  
  // Add suffix before extension
  static addSuffix(filePath, suffix) {
    const parsed = path.parse(filePath);
    return path.format({
      dir: parsed.dir,
      name: `${parsed.name}${suffix}`,
      ext: parsed.ext
    });
  }
  
  // Get file info
  static getInfo(filePath) {
    const parsed = path.parse(filePath);
    return {
      path: filePath,
      absolute: path.isAbsolute(filePath),
      directory: parsed.dir,
      name: parsed.name,
      extension: parsed.ext,
      basename: parsed.base,
      dirname: path.dirname(filePath)
    };
  }
  
  // Safe join (prevent path traversal)
  static safeJoin(base, ...segments) {
    const result = path.join(base, ...segments);
    const relative = path.relative(base, result);
    
    if (relative.startsWith('..') || path.isAbsolute(relative)) {
      throw new Error(`Path traversal detected: ${segments.join('/')}`);
    }
    
    return result;
  }
  
  // Get all ancestors
  static getAncestors(filePath) {
    const ancestors = [];
    let current = path.dirname(path.resolve(filePath));
    
    while (true) {
      const parent = path.dirname(current);
      if (parent === current) break;  // Reached root
      ancestors.push(parent);
      current = parent;
    }
    
    return ancestors;
  }
}

// Demo functions
async function demonstrateBasicOps() {
  console.log('=== Basic Operations ===\n');
  
  const filePath = '/users/alice/documents/report.pdf';
  
  console.log('Original path:', filePath);
  console.log('Directory:', path.dirname(filePath));
  console.log('Basename:', path.basename(filePath));
  console.log('Extension:', path.extname(filePath));
  console.log('Name:', path.basename(filePath, path.extname(filePath)));
  
  // Parsed
  console.log('\nParsed:');
  const parsed = path.parse(filePath);
  Object.entries(parsed).forEach(([key, value]) => {
    console.log(`  ${key}: ${value}`);
  });
}

async function demonstrateJoinResolve() {
  console.log('\n=== Join vs Resolve ===\n');
  
  console.log('Current directory:', process.cwd());
  
  const joined = path.join('data', 'users', 'alice.json');
  const resolved = path.resolve('data', 'users', 'alice.json');
  
  console.log('join:', joined);
  console.log('resolve:', resolved);
  
  // With absolute path
  const absJoined = path.join('/data', 'users', 'alice.json');
  const absResolved = path.resolve('/data', 'users', 'alice.json');
  
  console.log('\nWith absolute segment:');
  console.log('join:', absJoined);
  console.log('resolve:', absResolved);
}

async function demonstratePathManager() {
  console.log('\n=== Path Manager ===\n');
  
  const projectRoot = path.resolve(__dirname, '..');
  const pm = new PathManager(projectRoot);
  
  console.log('Project root:', pm.projectRoot);
  console.log('Source dir:', pm.srcDir);
  console.log('Data dir:', pm.dataDir);
  
  const dataFile = pm.resolve('data', 'users.json');
  console.log('\nData file:', dataFile);
  console.log('Relative:', pm.relative(dataFile));
  console.log('Inside project:', pm.isInside(dataFile));
  
  // Test outside
  const outside = '/tmp/external.json';
  console.log('\nExternal file:', outside);
  console.log('Inside project:', pm.isInside(outside));
}

async function demonstrateFileUtils() {
  console.log('\n=== File Utilities ===\n');
  
  const original = '/docs/report.txt';
  console.log('Original:', original);
  
  // Change extension
  const withPdf = FilePathUtils.changeExtension(original, '.pdf');
  console.log('Changed ext:', withPdf);
  
  // Add suffix
  const withSuffix = FilePathUtils.addSuffix(original, '_backup');
  console.log('With suffix:', withSuffix);
  
  // Combined
  const backup = FilePathUtils.changeExtension(
    FilePathUtils.addSuffix(original, '_backup'),
    '.bak'
  );
  console.log('Backup path:', backup);
  
  // Get info
  console.log('\nFile info:');
  const info = FilePathUtils.getInfo(original);
  Object.entries(info).forEach(([key, value]) => {
    console.log(`  ${key}: ${value}`);
  });
}

async function demonstrateSafety() {
  console.log('\n=== Path Safety ===\n');
  
  const base = '/var/www/uploads';
  
  // Safe paths
  const safe1 = FilePathUtils.safeJoin(base, 'user123', 'avatar.jpg');
  console.log('✓ Safe:', safe1);
  
  const safe2 = FilePathUtils.safeJoin(base, 'documents/report.pdf');
  console.log('✓ Safe:', safe2);
  
  // Unsafe paths (path traversal attempts)
  const unsafe = ['../etc/passwd', '../../secret.txt', '/etc/shadow'];
  
  unsafe.forEach(attempt => {
    try {
      FilePathUtils.safeJoin(base, attempt);
      console.log('✗ Should have failed:', attempt);
    } catch (error) {
      console.log(`✓ Blocked: ${attempt}`);
    }
  });
}

async function demonstratePlatform() {
  console.log('\n=== Platform Info ===\n');
  
  console.log('Path separator:', path.sep);
  console.log('Delimiter:', path.delimiter);
  console.log('Platform:', process.platform);
  
  // Build path manually
  const manual = ['users', 'alice', 'file.txt'].join(path.sep);
  console.log('Manual path:', manual);
  
  // Parse PATH environment variable
  const pathDirs = (process.env.PATH || '').split(path.delimiter).slice(0, 5);
  console.log('\nPATH directories (first 5):');
  pathDirs.forEach(dir => console.log(`  ${dir}`));
}

// Main execution
async function main() {
  console.log('=== Path Manipulation Demo ===\n');
  
  try {
    await demonstrateBasicOps();
    await demonstrateJoinResolve();
    await demonstratePathManager();
    await demonstrateFileUtils();
    await demonstrateSafety();
    await demonstratePlatform();
    
    console.log('\n✓ Complete!');
  } catch (error) {
    console.error('\n✗ Error:', error.message);
    process.exit(1);
  }
}

main();
```

## Requisiti
- [ ] Usa `path.join()` per concatenare paths
- [ ] Usa `path.resolve()` per absolute paths
- [ ] Estrai componenti con `dirname()`, `basename()`, `extname()`
- [ ] Parse/format con `parse()` e `format()`
- [ ] Gestisci cross-platform differences
- [ ] Codice eseguibile

## Risorse
- [Node.js - Path](https://nodejs.org/api/path.html)
- [MDN - File paths](https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/Dealing_with_files)
- [Path traversal security](https://owasp.org/www-community/attacks/Path_Traversal)

## Note
Usa sempre `path.join()` o `path.resolve()` invece di string concatenation. `path.join()` è relativo, `path.resolve()` è assoluto. In ES modules usa `fileURLToPath(import.meta.url)` per ottenere `__filename` e `__dirname`. Valida sempre user input per prevenire path traversal attacks.

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
