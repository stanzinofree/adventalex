# Hello Node

## Obiettivo

Creare il tuo **primo script Node.js** per familiarizzare con l'ambiente di esecuzione JavaScript server-side. Node.js permette di eseguire JavaScript fuori dal browser, ed è perfetto per CLI tools, automation scripts, e API servers.

### Contesto Pratico

Node.js è ideale per:
- **Automation scripts**: deploy, build, task automation
- **CLI tools**: utility command-line
- **API servers**: REST, GraphQL, WebSocket
- **DevOps**: monitoring, logging, orchestration

Vantaggi:
- **Ecosystem enorme**: npm con milioni di package
- **Event-driven**: async I/O non-blocking
- **Cross-platform**: Linux, macOS, Windows
- **JavaScript everywhere**: stesso linguaggio frontend/backend

### Primo Script

```javascript
// index.js
console.log('Hello, Node.js!');
console.log('Node version:', process.version);
console.log('Platform:', process.platform);
console.log('Architecture:', process.arch);
```

**Esegui:**
```bash
node index.js
```

### Process Object

```javascript
// System info
console.log('=== System Info ===');
console.log('Node:', process.version);
console.log('Platform:', process.platform);
console.log('Arch:', process.arch);
console.log('PID:', process.pid);
console.log('CWD:', process.cwd());
console.log('User:', process.env.USER || process.env.USERNAME);

// Command line args
console.log('\n=== Arguments ===');
console.log('Args:', process.argv);
console.log('Script:', process.argv[1]);
if (process.argv.length > 2) {
  console.log('User args:', process.argv.slice(2));
}

// Exit code
process.exit(0);  // Success
```

### Esempio Completo

```javascript
#!/usr/bin/env node
// Make executable: chmod +x index.js

function main() {
  console.log('=== Node.js Hello ===\n');
  
  // Version info
  console.log(`Node: ${process.version}`);
  console.log(`V8: ${process.versions.v8}`);
  console.log(`Platform: ${process.platform}`);
  console.log(`Arch: ${process.arch}`);
  
  // Environment
  const env = process.env.NODE_ENV || 'development';
  console.log(`\nEnvironment: ${env}`);
  
  // Command args
  const args = process.argv.slice(2);
  if (args.length > 0) {
    console.log(`\nArguments: ${args.join(', ')}`);
  }
  
  console.log('\n✓ Node.js is working!');
}

main();
```

**Run:**
```bash
node index.js arg1 arg2
# Or if executable:
./index.js arg1 arg2
```

## Requisiti
- [ ] Crea file `index.js`
- [ ] Usa `console.log()` per output
- [ ] Mostra `process.version`
- [ ] Gestisci `process.argv` (opzionale)
- [ ] Esegui con `node index.js`

## Risorse
- [Node.js Docs](https://nodejs.org/docs/)
- [Process Object](https://nodejs.org/api/process.html)
- [MDN JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript)

## Note
Node.js esegue JavaScript con V8 engine (Chrome). Usa NPM per package management.

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
