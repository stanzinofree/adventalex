# TODO.md - Roadmap AdventAlex

## 🎯 Priorità Immediate

### P0 - Critiche (Da fare subito)
- [ ] Completare STUDY.md con tutti i piani 30 giorni (6 linguaggi)
- [ ] Testare generazione automatica struttura sfide per tutti i linguaggi
- [ ] Creare template sfide day02-day05 per Bash e Zig

### P1 - Importanti (Questa settimana)
- [ ] Iniziare sfide Python (day01-day03)
- [ ] Iniziare sfide Go (day01-day03)
- [ ] Aggiungere comando `./scripts/adventalex.sh list` per vedere stato globale
- [ ] Aggiungere comando `./scripts/adventalex.sh stats` per statistiche dettagliate

### P2 - Desiderabili (Prossime 2 settimane)
- [ ] Creare GitHub Actions per CI/CD
- [ ] Aggiungere badge dinamici nel README.md
- [ ] Implementare `./scripts/adventalex.sh reset <lang> <num>` per resettare sfida
- [ ] Aggiungere supporto per sfide multi-file

## 📚 Contenuti e Sfide

### Bash (1/30 completate)
- [x] Day01 - System Summary
- [ ] Day02 - File Permissions Checker
- [ ] Day03 - Network Connectivity Test
- [ ] Day04 - Log Parser
- [ ] Day05 - Backup Script
- [ ] Day06-30 - Da pianificare (vedi STUDY.md)

### Zig (1/30 completate)
- [x] Day01 - Zig Hello CLI
- [ ] Day02 - String Manipulation
- [ ] Day03 - Array Operations
- [ ] Day04 - File Read/Write
- [ ] Day05 - HTTP Request
- [ ] Day06-30 - Da pianificare (vedi STUDY.md)

### Python (0/30 completate)
- [ ] Day01 - Python Hello + Environment Info
- [ ] Day02 - String Processing
- [ ] Day03 - File Operations
- [ ] Day04 - JSON Parsing
- [ ] Day05 - HTTP Client
- [ ] Day06-30 - Da pianificare (vedi STUDY.md)

### Go (0/30 completate)
- [ ] Day01 - Go Hello + Build
- [ ] Day02 - Variables & Types
- [ ] Day03 - Slices & Maps
- [ ] Day04 - File I/O
- [ ] Day05 - HTTP Server
- [ ] Day06-30 - Da pianificare (vedi STUDY.md)

### Rust (0/30 completate)
- [ ] Day01 - Rust Hello + Cargo
- [ ] Day02 - Ownership Basics
- [ ] Day03 - String vs &str
- [ ] Day04 - Error Handling
- [ ] Day05 - File Read/Write
- [ ] Day06-30 - Da pianificare (vedi STUDY.md)

### JavaScript (0/30 completate)
- [ ] Day01 - Node.js Hello
- [ ] Day02 - Array Methods
- [ ] Day03 - Async/Await
- [ ] Day04 - File System
- [ ] Day05 - HTTP Request
- [ ] Day06-30 - Da pianificare (vedi STUDY.md)

## 🛠 Miglioramenti Script

### adventalex.sh
- [x] Comando `start` con creazione automatica struttura
- [x] Comando `done` con esecuzione test
- [ ] Comando `list` - mostra tutte le sfide e stato
- [ ] Comando `stats` - statistiche globali
- [ ] Comando `reset <lang> <num>` - resetta sfida a todo
- [ ] Comando `skip <lang> <num>` - salta sfida (marca come skipped)
- [ ] Opzione `--dry-run` per vedere cosa farebbe
- [ ] Validazione: impedire `done` se non esiste directory sfida

### update_progress.sh
- [x] Aggiornamento progress.md
- [x] Generazione tabella progressi in README.md
- [x] Barra di progresso visiva
- [ ] Supporto stato `⏭ skipped`
- [ ] Export progressi in JSON
- [ ] Generazione badge SVG personalizzati
- [ ] Calcolo streak (giorni consecutivi)

### testlib/
- [x] ansi.sh - colori ANSI
- [x] test_utils.sh - assert base
- [ ] Aggiungere `assert_equals <expected> <actual> <msg>`
- [ ] Aggiungere `assert_exit_code <cmd> <expected_code> <msg>`
- [ ] Aggiungere `assert_file_exists <path> <msg>`
- [ ] Aggiungere `assert_json_valid <json_string> <msg>`
- [ ] Template generator per test comuni

## 📊 Tracking e Reporting

### Metriche da Implementare
- [ ] Tempo medio per sfida (tracking con timestamp)
- [ ] Streak corrente e massimo
- [ ] Heatmap tipo GitHub (giorni con sfide completate)
- [ ] Grafico progressione per linguaggio
- [ ] Export dati in CSV/JSON

### Dashboard
- [ ] Script `./scripts/dashboard.sh` - TUI interattiva
- [ ] Visualizzazione calendario con sfide completate
- [ ] Classifica linguaggi per completamento
- [ ] Suggerimento prossima sfida da fare

## 🔧 Automazione e CI/CD

### GitHub Actions
- [ ] Workflow per validare test su PR
- [ ] Auto-update badge in README.md
- [ ] Notifica Discord/Slack a sfida completata
- [ ] Generazione release notes automatiche
- [ ] Deploy documentazione su GitHub Pages

### Pre-commit Hooks
- [ ] Validazione formato test script
- [ ] Lint per script bash
- [ ] Verifica presenza README.md in ogni sfida
- [ ] Check duplicati titoli sfide

## 📖 Documentazione

### Da Completare
- [x] CLAUDE.md - documentazione tecnica
- [x] TODO.md - questo file
- [ ] CHANGELOG.md - storia modifiche
- [x] STUDY.md - piano studi 30 giorni (in progress)
- [ ] CONTRIBUTING.md - guida per contribuire
- [ ] FAQ.md - domande frequenti

### Video/Tutorial
- [ ] Screencast demo completo
- [ ] Video setup iniziale
- [ ] Video workflow tipico
- [ ] Serie tutorial per linguaggio

## 🎨 UX e Miglioramenti Utente

### Output Script
- [ ] Progress bar durante esecuzione test lunghi
- [ ] Emoji personalizzati per stati
- [ ] Colori ANSI in tutti gli output
- [ ] Riepilogo giornaliero: "Oggi hai completato X sfide"

### Template e Scaffolding
- [x] Auto-generazione README.md sfida
- [x] Auto-generazione test script
- [ ] Template specifici per linguaggio
- [ ] Esempio implementazione nei template
- [ ] Link a risorse/docs nel template README

## 🔐 Sicurezza e Qualità

### Code Quality
- [ ] Shellcheck per tutti gli script bash
- [ ] Linter specifici per ogni linguaggio
- [ ] Code coverage per script di test
- [ ] Security scan su dipendenze

### Backup e Recovery
- [ ] Script `./scripts/backup.sh` - backup completo
- [ ] Script `./scripts/restore.sh` - ripristino
- [ ] Git hooks per backup automatico
- [ ] Export/import stato progressi

## 🌍 Community e Sharing

### Sharing
- [ ] Template README.md per condivisione pubblica
- [ ] Anonimizzazione dati personali
- [ ] Export portfolio (sfide completate + codice)
- [ ] Generazione certificato completamento linguaggio

### Gamification
- [ ] Sistema punti (10pt = sfida completata)
- [ ] Achievement/Badge (es. "10 giorni streak", "Master Bash")
- [ ] Leaderboard (se usato in team)
- [ ] Challenge settimanali

## 📱 Multi-piattaforma

### Portabilità
- [ ] Test su Linux
- [ ] Test su macOS
- [ ] Test su Windows (WSL)
- [ ] Docker container per ambiente isolato

### Mobile
- [ ] Progressive Web App per visualizzare progressi
- [ ] Notifiche push reminder giornaliere
- [ ] App companion iOS/Android

## 🔮 Idee Future

### Avanzate
- [ ] AI assistant per suggerire sfide in base al livello
- [ ] Integrazione con LeetCode/HackerRank
- [ ] Peer review di sfide completate
- [ ] Live coding session registrate
- [ ] Modalità multiplayer/competizione

### Espansione Contenuti
- [ ] Aggiungere linguaggi: Ruby, PHP, Java, C, C++
- [ ] Sfide specializzate DevOps (Kubernetes, Terraform, Ansible)
- [ ] Sfide database (SQL, MongoDB, Redis)
- [ ] Sfide cloud (AWS, Azure, GCP)

## 📅 Timeline Suggerita

### Settimana 1 (Corrente)
- Completare STUDY.md
- Testare generazione automatica
- 3 sfide Bash, 3 sfide Zig

### Settimana 2
- Iniziare Python (5 sfide)
- Iniziare Go (5 sfide)
- Implementare comando `list`

### Settimana 3
- Iniziare Rust (3 sfide)
- Iniziare JavaScript (3 sfide)
- Implementare comando `stats`

### Settimana 4
- GitHub Actions base
- Dashboard TUI
- 15 sfide totali completate

### Mese 2
- Completare almeno 10 sfide per 3 linguaggi
- Sistema metriche e tracking
- Badge e gamification

### Mese 3-4
- Raggiungere 20+ sfide per almeno 2 linguaggi
- Community features
- Documentazione completa

## 🎯 Obiettivo Finale

**Entro 4 mesi:**
- 180 sfide totali (30 per linguaggio × 6 linguaggi)
- Sistema completo e documentato
- CI/CD funzionante
- Portfolio condivisibile
- Competenza pratica in tutti e 6 i linguaggi

---

**Ultimo aggiornamento**: 2025-12-14
**Prossima revisione**: 2025-12-21
