# CLAUDE.md - Documentazione Progetto AdventAlex

## Panoramica del Progetto

**AdventAlex** è un sistema di micro-sfide giornaliere progettato per mantenere e migliorare le competenze di programmazione in linguaggi chiave per DevOps, SysAdmin e sviluppo software.

### Obiettivi
- Allenarsi quotidianamente (max 10 minuti per sfida)
- Coprire 6 linguaggi: Bash, Python, Go, Rust, Zig, JavaScript
- 30 sfide per linguaggio (totale: 180 sfide)
- Progressione da principiante a competente in 30 giorni per linguaggio

### Filosofia
- **Continuità > Perfezione**: meglio un esercizio funzionante che uno perfetto
- **Pragmatismo**: sfide basate su casi d'uso reali IT/DevOps
- **Automazione**: script per gestire il ciclo di vita delle sfide
- **Tracciabilità**: progresso visibile e misurabile

## Architettura del Sistema

### Struttura Directory
```
AdventAlex/
├── scripts/              # Script di orchestrazione
│   ├── adventalex.sh    # CLI principale (start, done)
│   ├── update_progress.sh   # Aggiornamento progress.md e README.md
│   └── testlib/         # Librerie per test bash
│       ├── ansi.sh      # Colori ANSI
│       └── test_utils.sh    # Funzioni assert
├── {linguaggio}/        # Directory per linguaggio
│   └── day{XX}/         # Directory per giorno (01-30)
│       ├── README.md    # Specifica della sfida
│       ├── {impl}.*     # Implementazione
│       └── test_*.sh    # Script di test
├── progress.md          # Tracker dettagliato (auto-generato)
├── README.md            # Documentazione utente
├── STUDY.md             # Piano di studi 30 giorni
├── TODO.md              # Roadmap e prossimi passi
├── CHANGELOG.md         # Storia delle modifiche
└── CLAUDE.md            # Questo file
```

### Ciclo di Vita di una Sfida

1. **Avvio**
   ```bash
   ./scripts/adventalex.sh start <lang> <num> "<title>"
   ```
   - Crea directory `<lang>/day<num>/`
   - Genera template README.md, file implementazione, test
   - Aggiorna `progress.md` con stato ⏳ started
   - Aggiorna tabella progressi in `README.md`

2. **Sviluppo**
   - Leggi specifica in `<lang>/day<num>/README.md`
   - Implementa soluzione in file principale
   - Scrivi/modifica test in `test_*.sh`
   - Testa manualmente: `./test_*.sh`

3. **Completamento**
   ```bash
   ./scripts/adventalex.sh done <lang> <num>
   ```
   - Esegue automaticamente `test_*.sh`
   - Estrae `TEST_RESULT=<0-100>` dall'output
   - Se `TEST_RESULT=100`: ✅ done
   - Se `TEST_RESULT<100`: ❌ failed (mostra %)
   - Aggiorna `progress.md` e tabella in `README.md`

### Sistema di Test

#### Requisiti Test Script
- Deve essere eseguibile (`chmod +x`)
- Deve produrre output con `TEST_RESULT=<0-100>`
- Può usare librerie in `scripts/testlib/`

#### Esempio Test
```bash
#!/usr/bin/env bash
source "$(dirname "$0")/../../scripts/testlib/test_utils.sh"

TOTAL=5
PASS=0

assert_executable "./solution.sh" && ((PASS++))
OUTPUT=$(./solution.sh)
assert_not_empty "$OUTPUT" "Output non vuoto" && ((PASS++))
assert_contains "$OUTPUT" "expected" "Contiene 'expected'" && ((PASS++))

PERCENT=$((PASS * 100 / TOTAL))
echo "TEST_RESULT=$PERCENT"
```

### Tracciamento Progressi

#### progress.md (Dettagliato)
- Una sezione per linguaggio
- Tabella con 30 righe (day01-day30)
- Colonne: #, Sfida, Stato, StartedAt, Test
- Stati: ⬜ todo, ⏳ started, ❌ failed, ✅ done

#### README.md (Sintetico)
- Tabella riepilogativa 6 righe (1 per linguaggio)
- Colonne: Linguaggio, Completate, Avanzamento, Progresso
- Barra visiva: `[███░░░░░░░]` (30 caratteri)

### Script Principali

#### adventalex.sh
**Comandi**:
- `start <lang> <num> "<title>"` - Avvia nuova sfida
- `done <lang> <num>` - Completa sfida (esegue test)

**Funzionalità**:
- Normalizzazione linguaggi (bash → Bash)
- Validazione input
- Ricerca automatica test script
- Parsing `TEST_RESULT` da output
- Chiamata `update_progress.sh`

#### update_progress.sh
**Comandi**:
- `start <Lang> <num> <title>` - Marca come started
- `done <Lang> <num> <title> <pct>` - Marca come done
- `fail <Lang> <num> <title> <pct>` - Marca come failed

**Funzionalità**:
- Parsing e modifica `progress.md` con AWK
- Generazione tabella sintetica per `README.md`
- Calcolo statistiche per linguaggio
- Generazione barra progresso visiva

### Librerie Test (testlib/)

#### ansi.sh
Costanti per colori ANSI:
- `RED`, `GREEN`, `YELLOW`, `BLUE`, `GRAY`
- `BOLD`, `RESET`

#### test_utils.sh
Funzioni helper:
- `info "msg"` - Output blu ℹ
- `ok "msg"` - Output verde ✔
- `warn "msg"` - Output giallo ⚠
- `bad "msg"` - Output rosso ✘
- `assert_executable <path>` - Verifica eseguibile
- `assert_not_empty <val> <msg>` - Verifica non vuoto
- `assert_contains <haystack> <needle> <msg>` - Verifica substring

## Template per Linguaggio

### Bash
- File principale: `*.sh`
- Convenzioni: shebang `#!/usr/bin/env bash`, `set -euo pipefail`
- Focus: scripting, automazione, gestione sistema

### Python
- File principale: `*.py`
- Convenzioni: shebang `#!/usr/bin/env python3`
- Focus: automazione, API, data processing

### Go
- File principale: `main.go`
- Convenzioni: package main, func main()
- Focus: tool CLI, servizi, concorrenza

### Rust
- File principale: `main.rs` o progetto Cargo
- Convenzioni: fn main(), error handling
- Focus: performance, sicurezza, tool CLI

### Zig
- File principale: `main.zig`
- Convenzioni: pub fn main() void/!void
- Focus: basso livello, performance, C interop

### JavaScript
- File principale: `*.js` o `*.mjs`
- Convenzioni: Node.js, ES modules
- Focus: scripting, automazione, API

## Regole d'Oro

1. **Max 10 minuti** per sfida
2. **Funzionale > Perfetto** - se compila/gira, è valido
3. **No refactoring** di sfide completate
4. **Commenti essenziali** - solo dove necessario
5. **Commit frequenti** - una sfida = un commit
6. **Continuità** - meglio poco ogni giorno che tanto saltuariamente

## Metriche di Successo

- **Completamento**: 100% test passati
- **Consistenza**: Almeno 5 sfide/settimana
- **Diversità**: Almeno 3 linguaggi attivi in parallelo
- **Qualità**: Media test > 80% su sfide completate

## Workflow Tipico

```bash
# Mattina: avvia sfida
./scripts/adventalex.sh start python 5 "Parse JSON Config"

# Sviluppo (max 10 min)
cd python/day05
cat README.md                  # leggi specifica
vim parse_config.py            # implementa
chmod +x test_parse_config.sh
./test_parse_config.sh         # testa manualmente

# Sera: completa
cd ../..
./scripts/adventalex.sh done python 5
git add python/day05
git commit -m "Python day05: Parse JSON Config"
git push
```

## Estensibilità

### Aggiungere un Nuovo Linguaggio
1. Aggiungi a `STUDY.md` il piano 30 giorni
2. Aggiungi sezione in `progress.md` con tabella 30 righe
3. Aggiungi alla lista in `update_progress.sh` (array `langs`)
4. Crea directory `<linguaggio>/`

### Modificare Numero Sfide
- Variabile `total_challenges=30` in `update_progress.sh`
- Aggiorna template `progress.md`
- Aggiorna `STUDY.md`

## Manutenzione

### File Auto-generati (NON modificare manualmente)
- `progress.md` (gestito da `update_progress.sh`)
- Sezione `## Progressi` in `README.md` (gestita da `update_progress.sh`)

### File Manuali
- `README.md` (resto del documento)
- `STUDY.md` (piano studi)
- `TODO.md` (roadmap)
- `CHANGELOG.md` (storia)
- `CLAUDE.md` (questo file)

## Troubleshooting

### Test non trovato
```bash
# Verifica presenza test
ls -la <lang>/day<num>/test_*.sh
# Verifica permessi
chmod +x <lang>/day<num>/test_*.sh
```

### TEST_RESULT non parsato
```bash
# Esegui test manualmente e verifica output
./path/to/test_script.sh
# Output deve contenere esattamente: TEST_RESULT=<0-100>
```

### Tabella progressi non aggiornata
```bash
# Verifica sintassi progress.md (deve avere sezione ## <Lang>)
# Riesegui manualmente update
./scripts/update_progress.sh done Bash 1 "Title" 100
```

## Riferimenti

- Repository: `/Users/alessandro/Documents/PLAY/REPOS/AdventAlex`
- Piano studi: `STUDY.md`
- Roadmap: `TODO.md`
- Storia: `CHANGELOG.md`
- Documentazione utente: `README.md`
