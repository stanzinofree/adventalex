# CHANGELOG.md - Storia Modifiche AdventAlex

Tutte le modifiche rilevanti al progetto AdventAlex saranno documentate in questo file.

Il formato è basato su [Keep a Changelog](https://keepachangelog.com/it/1.0.0/),
e questo progetto aderisce al [Semantic Versioning](https://semver.org/lang/it/).

## [Unreleased]

### Da Aggiungere
- Comando `list` per visualizzare stato globale
- Comando `stats` per statistiche dettagliate
- Generazione automatica completa struttura sfide nel comando `start`
- Piano studi completo STUDY.md per tutti i linguaggi

## [0.2.0] - 2025-12-14

### Aggiunto
- **CLAUDE.md**: Documentazione tecnica completa del progetto
- **TODO.md**: Roadmap e prossimi passi con priorità
- **CHANGELOG.md**: Questo file per tracciare modifiche
- **Tabella progressi in README.md**: 
  - Riepilogo sintetico per ogni linguaggio
  - Colonne: Linguaggio, Completate, Avanzamento, Progresso
  - Barra visiva con caratteri `█` e `░` (30 caratteri)
  - Aggiornamento automatico ad ogni `start`/`done`
- **Funzione `progress_bar()` in update_progress.sh**:
  - Genera barra proporzionale sfide completate/totali
  - Mostra almeno 1 carattere se almeno 1 sfida completata
- **Funzione `update_readme_summary()` in update_progress.sh**:
  - Calcola statistiche per ogni linguaggio
  - Conta sfide ✅ done da progress.md
  - Genera e inserisce tabella in README.md
- **Sezione "## Progressi" in README.md**:
  - Posizionata prima di "## Linguaggi"
  - Auto-generata e auto-aggiornata

### Modificato
- **update_progress.sh**:
  - Aggiunta chiamata a `update_readme_summary()` dopo ogni aggiornamento
  - Refactoring `progress_bar()` per accettare `done` e `total` invece di `percent`
  - Migliorata gestione edge case (0% completamento)
- **README.md**:
  - Aggiornato con documentazione completa degli script
  - Aggiunta sezione "Librerie di test"
  - Aggiunta sezione "Workflow completo" con esempi pratici
  - Aggiunto JavaScript alla lista linguaggi
  - Espanse "Regole d'oro" con principi da rules.md

### Corretto
- Calcolo barra progresso ora mostra almeno 1 blocco se sfide > 0
- Gestione corretta percentuale bassa (< 3%) nella barra visiva

## [0.1.0] - 2025-12-14

### Aggiunto
- **Struttura progetto iniziale**:
  - Directory per 6 linguaggi: Bash, Python, Go, Rust, Zig, JavaScript
  - Sottodirectory `day01/` per Bash e Zig
- **Script adventalex.sh**:
  - Comando `start <lang> <num> "<title>"` per avviare sfida
  - Comando `done <lang> <num>` per completare sfida
  - Normalizzazione nomi linguaggi (bash → Bash)
  - Ricerca automatica test script
  - Parsing `TEST_RESULT` da output test
  - Validazione exit code test
- **Script update_progress.sh**:
  - Comando `start` per marcare sfida come ⏳ started
  - Comando `done` per marcare sfida come ✅ done
  - Comando `fail` per marcare sfida come ❌ failed
  - Parsing e modifica progress.md con AWK
  - Preservazione timestamp originale su update
- **Libreria testlib/**:
  - `ansi.sh`: Costanti colori ANSI (RED, GREEN, YELLOW, BLUE, GRAY, BOLD, RESET)
  - `test_utils.sh`: Funzioni helper per test
    - `info()`, `ok()`, `warn()`, `bad()` - output colorati
    - `assert_executable()` - verifica file eseguibile
    - `assert_not_empty()` - verifica stringa non vuota
    - `assert_contains()` - verifica substring (case-insensitive)
- **Sfida Bash Day01 - System Summary**:
  - README.md con specifica
  - `system_summary.sh` - implementazione
  - `test_system_summary.sh` - test script (5 test, 100%)
- **Sfida Zig Day01 - Zig Hello CLI**:
  - README.md con specifica
  - `main.zig` - implementazione
  - `test_zig_hello.sh` - test script (5 test, 100%)
- **File di progetto**:
  - `README.md` - documentazione utente
  - `progress.md` - tracker stato sfide (30 righe × 6 linguaggi)
  - `rules.md` - regole d'oro del progetto
  - `.gitignore` - configurazione Git per tutti i linguaggi
  - `assets/badges/` - badge SVG (todo.svg, done.svg)

### Principi Stabiliti
- Max 10 minuti per sfida
- Funzionale > Perfetto
- Continuità > Qualità
- Commit frequenti
- Test automatizzati obbligatori
- Ogni test deve produrre `TEST_RESULT=<0-100>`

---

## Legenda Tipi di Modifiche

- **Aggiunto**: Nuove funzionalità
- **Modificato**: Modifiche a funzionalità esistenti
- **Deprecato**: Funzionalità che saranno rimosse
- **Rimosso**: Funzionalità rimosse
- **Corretto**: Bug fix
- **Sicurezza**: Vulnerabilità corrette

## Formato Versioni

Usiamo Semantic Versioning: `MAJOR.MINOR.PATCH`
- **MAJOR**: Modifiche incompatibili con versioni precedenti
- **MINOR**: Nuove funzionalità retrocompatibili
- **PATCH**: Bug fix retrocompatibili

---

**Ultimo aggiornamento**: 2025-12-14
