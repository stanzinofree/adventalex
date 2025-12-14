# STUDY.md - Piano Studi 0-to-Hero in 30 Giorni

Percorso progressivo da principiante assoluto a competente pratico in 30 giorni per ogni linguaggio.
Ogni sfida richiede max 10 minuti e si concentra su casi d'uso reali IT/DevOps.

---

## 🐚 Bash - Shell Scripting Mastery

**Focus**: Automazione sistema, scripting, gestione server, DevOps essentials

### Week 1: Fondamenti (Day 01-07)
- **Day01**: System Summary - Raccogliere info sistema (hostname, user, uptime, disk)
- **Day02**: File Permissions Checker - Verificare permessi file/directory
- **Day03**: Network Connectivity Test - Ping host, check porte aperte
- **Day04**: Log Parser - Estrarre errori da file log
- **Day05**: Backup Script - Backup directory con timestamp
- **Day06**: User Management - Creare/eliminare utenti, gestire gruppi
- **Day07**: Process Monitor - Trovare processi per nome, kill

### Week 2: Elaborazione Dati (Day 08-14)
- **Day08**: CSV Parser - Leggere e filtrare CSV
- **Day09**: Text Replacement - Sostituire testo in file multipli (sed)
- **Day10**: Directory Tree - Generare struttura directory
- **Day11**: Disk Usage Report - Analizzare spazio disco per directory
- **Day12**: Service Health Check - Verificare stato servizi systemd
- **Day13**: Environment Variables - Gestire .env file
- **Day14**: Archive Manager - Creare/estrarre tar.gz

### Week 3: Automazione (Day 15-21)
- **Day15**: Cron Job Manager - Creare/modificare crontab
- **Day16**: SSH Key Setup - Automatizzare setup chiavi SSH
- **Day17**: Git Hook - Pre-commit script
- **Day18**: Database Backup - Dump MySQL/PostgreSQL automatico
- **Day19**: API Call - curl con autenticazione, parse JSON (jq)
- **Day20**: Docker Container Check - Verificare stato container
- **Day21**: Alert Script - Inviare notifica (email/webhook) su errore

### Week 4: DevOps Avanzato (Day 22-30)
- **Day22**: Log Rotation - Implementare rotazione log custom
- **Day23**: Multi-server Command - Eseguire comando su N server (ssh loop)
- **Day24**: Certificate Expiry - Controllare scadenza certificati SSL
- **Day25**: Resource Monitor - Alert se CPU/RAM/Disk > soglia
- **Day26**: Config File Generator - Template con variabili
- **Day27**: Deployment Script - Deploy app con rollback
- **Day28**: Firewall Rule Manager - Gestire iptables rules
- **Day29**: Backup Verification - Testare integrità backup
- **Day30**: Infrastructure Report - Report completo server (CPU, RAM, Disk, Servizi)

---

## 🐍 Python - Automation & API Mastery

**Focus**: Automazione IT, API, data processing, scripting DevOps

### Week 1: Fondamenti (Day 01-07)
- **Day01**: Hello + Environment - Print info Python, sys.version, platform
- **Day02**: String Processing - Manipolare stringhe, regex base
- **Day03**: File Operations - Leggere, scrivere, appendere file
- **Day04**: JSON Parsing - Leggere JSON, modificare, scrivere
- **Day05**: HTTP Client - GET request con requests, parse response
- **Day06**: Command Line Args - argparse per CLI tool
- **Day07**: Environment Config - Leggere variabili .env, os.environ

### Week 2: Data Processing (Day 08-14)
- **Day08**: CSV Processing - Leggere CSV, filtrare, aggregare
- **Day09**: XML/YAML Parsing - Parse configurazioni
- **Day10**: Log Analyzer - Parse log, contare errori
- **Day11**: File System Walker - os.walk, trovare file per pattern
- **Day12**: Text Report Generator - Creare report formattato
- **Day13**: Data Validation - Validare input con pydantic/dataclasses
- **Day14**: Configuration Manager - Classe per gestire config

### Week 3: API e Rete (Day 15-21)
- **Day15**: REST API Client - CRUD operations su API
- **Day16**: API Authentication - Bearer token, API key
- **Day17**: Web Scraping - BeautifulSoup per estrarre dati
- **Day18**: Webhook Receiver - Flask endpoint per webhook
- **Day19**: Async HTTP - aiohttp per richieste concorrenti
- **Day20**: Database Client - SQLite CRUD operations
- **Day21**: Redis Client - Set/Get dati da Redis

### Week 4: DevOps Tools (Day 22-30)
- **Day22**: Docker API - Gestire container via API Python
- **Day23**: AWS S3 Client - Upload/download file da S3 (boto3)
- **Day24**: Monitoring Script - Raccogliere metriche sistema (psutil)
- **Day25**: Alert Manager - Inviare alert via email/Slack
- **Day26**: CI/CD Helper - Script per build/test automation
- **Day27**: Kubernetes Client - Kubectl operations via Python
- **Day28**: Ansible Dynamic Inventory - Generare inventory dinamico
- **Day29**: Infrastructure as Code - Generare Terraform/CloudFormation
- **Day30**: DevOps Dashboard - CLI tool con rich/click per status infra

---

## 🐹 Go - CLI Tools & Services Mastery

**Focus**: Tool CLI performanti, microservizi, concorrenza

### Week 1: Fondamenti (Day 01-07)
- **Day01**: Hello + Build - Primo programma, go build/run
- **Day02**: Variables & Types - int, string, bool, struct
- **Day03**: Slices & Maps - Operazioni base su collezioni
- **Day04**: Functions - Funzioni, multiple return, error handling
- **Day05**: File I/O - Leggere/scrivere file
- **Day06**: CLI Flags - flag package per argomenti CLI
- **Day07**: Error Handling - Gestione errori idiomatica

### Week 2: Strutture Dati (Day 08-14)
- **Day08**: JSON Marshal/Unmarshal - Encoding/decoding JSON
- **Day09**: Struct Methods - Metodi su struct
- **Day10**: Interfaces - Definire e implementare interface
- **Day11**: String Builder - Manipolare stringhe efficientemente
- **Day12**: Time & Duration - Gestire date, timer
- **Day13**: Custom Types - Type alias, metodi custom
- **Day14**: File Path Operations - path/filepath package

### Week 3: Concorrenza & HTTP (Day 15-21)
- **Day15**: Goroutines - Concorrenza base con go keyword
- **Day16**: Channels - Comunicazione tra goroutine
- **Day17**: WaitGroup - Sincronizzazione goroutine
- **Day18**: HTTP Server - net/http server base
- **Day19**: HTTP Client - GET/POST requests
- **Day20**: HTTP Handlers - Routing, middleware
- **Day21**: Context - context.Context per timeout/cancellation

### Week 4: Tool Avanzati (Day 22-30)
- **Day22**: CLI Tool Cobra - CLI complesso con cobra
- **Day23**: Config File - Viper per configurazioni
- **Day24**: Database - database/sql con SQLite/PostgreSQL
- **Day25**: Testing - Unit test con testing package
- **Day26**: Logging - structured logging con zerolog/zap
- **Day27**: Docker Builder - Dockerfile multi-stage per Go app
- **Day28**: REST API - API completa con gin/echo
- **Day29**: Worker Pool - Pattern worker con canali
- **Day30**: DevOps CLI - Tool completo per deploy/monitoring

---

## 🦀 Rust - Systems Programming Mastery

**Focus**: Sicurezza, performance, tool affidabili, basso livello

### Week 1: Fondamenti (Day 01-07)
- **Day01**: Hello + Cargo - Primo progetto Rust, cargo new/build/run
- **Day02**: Ownership - Basics di ownership, borrowing
- **Day03**: String vs &str - Gestione stringhe
- **Day04**: Option & Result - Error handling idiomatico
- **Day05**: Vectors - Vec<T> operazioni base
- **Day06**: Structs - Definire e usare struct
- **Day07**: Enums - Pattern matching con match

### Week 2: Concetti Core (Day 08-14)
- **Day08**: Traits - Definire e implementare trait
- **Day09**: Lifetimes - Lifetime annotations base
- **Day10**: Error Propagation - ? operator, custom errors
- **Day11**: Collections - HashMap, HashSet
- **Day12**: Iterators - Iter, map, filter, collect
- **Day13**: Closures - Anonymous functions
- **Day14**: File I/O - std::fs read/write

### Week 3: Tool Pratici (Day 15-21)
- **Day15**: CLI Args - clap per argomenti
- **Day16**: JSON Serde - Serialize/deserialize con serde
- **Day17**: HTTP Client - reqwest per HTTP requests
- **Day18**: Regex - Regex processing
- **Day19**: Async Basics - async/await con tokio
- **Day20**: File Watcher - Notificare modifiche file
- **Day21**: CSV Processing - csv crate per parsing

### Week 4: Avanzato (Day 22-30)
- **Day22**: HTTP Server - axum/actix-web server
- **Day23**: Database - sqlx per PostgreSQL/SQLite
- **Day24**: Testing - Unit + integration test
- **Day25**: Error Handling - thiserror/anyhow
- **Day26**: Concurrency - Thread, Arc, Mutex
- **Day27**: CLI Tool - Tool completo con clap + serde
- **Day28**: Performance - Benchmark, ottimizzazione
- **Day29**: Cross-compilation - Build per Linux/macOS/Windows
- **Day30**: DevOps Tool - CLI per infra management

---

## ⚡ Zig - Low-Level Performance Mastery

**Focus**: Performance, C interop, sistemi, tool veloci

### Week 1: Fondamenti (Day 01-07)
- **Day01**: Hello CLI - Primo programma, zig build-exe/run
- **Day02**: Variables & Types - var, const, tipi base
- **Day03**: Arrays & Slices - Array fixed-size, slice []T
- **Day04**: Control Flow - if, switch, while, for
- **Day05**: Functions - fn, parametri, return
- **Day06**: Structs - Struct base, metodi
- **Day07**: Error Handling - ! error union, try/catch

### Week 2: Memory & I/O (Day 08-14)
- **Day08**: Allocators - std.heap.page_allocator, arena
- **Day09**: String Operations - []const u8, std.mem
- **Day10**: File Read - std.fs.File read
- **Day11**: File Write - std.fs.File write, create
- **Day12**: Command Line - std.process.args()
- **Day13**: Print Formatting - std.debug.print, std.fmt
- **Day14**: ArrayList - std.ArrayList(T)

### Week 3: Strutture Avanzate (Day 15-21)
- **Day15**: HashMap - std.AutoHashMap
- **Day16**: Optional - ?T, orelse, if unwrap
- **Day17**: Unions - union, tagged union
- **Day18**: Enums - enum con metodi
- **Day19**: Testing - test blocks, zig test
- **Day20**: Build System - build.zig basics
- **Day21**: C Interop - Chiamare funzioni C

### Week 4: Progetti Reali (Day 22-30)
- **Day22**: CLI Parser - Argomenti con std.process
- **Day23**: JSON Parser - std.json parse/stringify
- **Day24**: HTTP Client - std.http.Client (o cURL binding)
- **Day25**: File Watcher - Polling directory
- **Day26**: Binary Tool - Tool che processa file binari
- **Day27**: Network Socket - TCP socket client
- **Day28**: Performance Tool - Benchmark, comptime
- **Day29**: Cross-platform - Build per OS diversi
- **Day30**: System Tool - Tool completo DevOps (monitor/deploy)

---

## 🟨 JavaScript (Node.js) - Scripting & Automation Mastery

**Focus**: Automazione, API, tool veloci, scripting moderno

### Week 1: Fondamenti (Day 01-07)
- **Day01**: Hello Node - Primo script Node.js, process.version
- **Day02**: Variables & Types - const, let, arrow functions
- **Day03**: Arrays - map, filter, reduce
- **Day04**: Objects - Object manipulation, destructuring
- **Day05**: Promises - Promise, .then/.catch
- **Day06**: Async/Await - Async functions
- **Day07**: Modules - import/export ES modules

### Week 2: I/O e File System (Day 08-14)
- **Day08**: File Read/Write - fs.promises read/write
- **Day09**: Path Operations - path module
- **Day10**: Directory Walker - fs.readdir recursivo
- **Day11**: JSON Processing - JSON.parse/stringify
- **Day12**: Environment Vars - process.env, dotenv
- **Day13**: Command Line Args - process.argv, minimist/yargs
- **Day14**: Child Process - exec, spawn command

### Week 3: HTTP & API (Day 15-21)
- **Day15**: HTTP Client - fetch/axios GET/POST
- **Day16**: REST API - express.js server base
- **Day17**: Middleware - express middleware custom
- **Day18**: Error Handling - try/catch async, error middleware
- **Day19**: Authentication - JWT token handling
- **Day20**: Database - SQLite/PostgreSQL con better-sqlite3/pg
- **Day21**: Redis Client - ioredis operazioni base

### Week 4: Tool Avanzati (Day 22-30)
- **Day22**: CLI Tool - Commander.js per CLI complesso
- **Day23**: Testing - Jest/Vitest unit test
- **Day24**: File Watcher - chokidar per hot reload
- **Day25**: Web Scraping - Cheerio/Puppeteer
- **Day26**: Stream Processing - Node streams per file grandi
- **Day27**: Worker Threads - worker_threads concorrenza
- **Day28**: Docker API - dockerode per gestire container
- **Day29**: CI/CD Script - Script automazione build/deploy
- **Day30**: DevOps Dashboard - CLI/TUI con inquirer/blessed

---

## 📊 Progressione delle Competenze

### Milestone per Livello

**Beginner (Day 1-7)**
- Sintassi base
- I/O file
- Variabili e tipi
- Controllo flusso
- Primo tool funzionante

**Intermediate (Day 8-14)**
- Strutture dati complesse
- Error handling
- Parsing (JSON/CSV/XML)
- File system operations
- CLI con argomenti

**Advanced (Day 15-21)**
- HTTP client/server
- Concorrenza/Async
- Database operations
- API integration
- Testing

**Expert (Day 22-30)**
- Tool completi production-ready
- Performance optimization
- DevOps integration
- Cross-platform
- Best practices consolidate

---

## 🎯 Strategia di Apprendimento

### Regole Generali
1. **Max 10 minuti**: Timer per evitare over-engineering
2. **Funzionale > Perfetto**: Se gira, è valido
3. **Iterazione**: Parti semplice, aggiungi feature
4. **Test Driven**: Test prima, poi implementazione
5. **Documentazione**: README chiaro per ogni sfida

### Progressione Multilingua
- **Parallelo**: Fare stesso concetto in più linguaggi (es. Day05 HTTP in tutti)
- **Confronto**: Notare differenze approccio
- **Specializzazione**: Dopo 2 settimane, focus su 2-3 linguaggi preferiti

### Tips per Successo
- Commit ogni giorno completato
- Non tornare indietro a "migliorare"
- Usare official docs come riferimento
- Tenere cheatsheet personale
- Celebrare ogni milestone (10/20/30 sfide)

---

## 📚 Risorse Consigliate

### Bash
- man pages (man bash, man sed, man awk)
- ShellCheck per lint
- bash-hackers.org

### Python
- python.org docs
- Real Python tutorials
- PyPI per package

### Go
- go.dev/tour
- Effective Go
- Go by Example

### Rust
- The Rust Book
- Rust by Example
- docs.rs

### Zig
- ziglang.org/learn
- Zig Language Reference
- ziglearn.org

### JavaScript
- MDN Web Docs
- nodejs.org/docs
- npmjs.com

---

**Buon coding! 🚀**

*Ultimo aggiornamento: 2025-12-14*
