# AdventAlex 🎄🧠

AdventAlex è un percorso di micro-sfide giornaliere (≤10 minuti)
per allenarsi su linguaggi utili nel lavoro IT / DevOps.

## Progressi

| Linguaggio | Completate | Avanzamento | Progresso |
|------------|------------|-------------|-----------|
| Bash | 1/30 | 3% | [█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] |
| Python | 0/30 | 0% | [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] |
| Go | 0/30 | 0% | [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] |
| Rust | 0/30 | 0% | [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] |
| Zig | 1/30 | 3% | [█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] |
| JavaScript | 0/30 | 0% | [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] |

## Linguaggi
- Bash
- Python
- Go
- Rust
- Zig
- JavaScript

## Regole d'oro
- 1 esercizio al giorno
- Max 10 minuti
- Deve compilare o girare
- Non serve essere perfetti
- Deve essere utile o realistica
- Continuità > qualità
- Commit piccoli e frequenti

Obiettivo: **non perdere la mano, rinforzare le basi, divertirsi**.

## Utilizzo

### Avviare una nuova sfida

**Modalità automatica** (consigliata):
```bash
./scripts/adventalex.sh start <linguaggio>
```

Lo script trova automaticamente la prossima sfida libera e legge il titolo da `STUDY.md`.

Esempio:
```bash
./scripts/adventalex.sh start bash
# 🔍 Prossima sfida libera: Day 02
# 📖 Titolo da STUDY.md: File Permissions Checker
# 🚀 Started: Bash 02 – File Permissions Checker

./scripts/adventalex.sh start python
# 🔍 Prossima sfida libera: Day 01
# 📖 Titolo da STUDY.md: Hello + Environment
```

**Modalità manuale** (opzionale):
```bash
./scripts/adventalex.sh start <linguaggio> <numero> "<Titolo Sfida>"
```

Esempio:
```bash
./scripts/adventalex.sh start zig 5 "Custom Challenge"
```

Questo comando:
- Crea automaticamente la directory `<linguaggio>/day<numero>/`
- Genera `README.md`, file implementazione e test script
- Aggiorna `progress.md` segnando la sfida come ⏳ started
- Registra il timestamp di inizio
- Aggiorna la tabella progressi in questo README

### Struttura della sfida (auto-generata)

Il comando `start` crea automaticamente:

1. **Directory della sfida**: `<linguaggio>/day<numero>/`
   - Esempio: `bash/day02/`, `python/day01/`

2. **File README.md**: Template con:
   - Titolo (da STUDY.md)
   - Sezioni: Obiettivo, Requisiti, Vincoli, Risorse, Note
   - Checklist requisiti vuota da completare

3. **File di implementazione**: Template specifico per linguaggio
   - **Bash**: `<nome>.sh` con shebang e `set -euo pipefail`
   - **Python**: `<nome>.py` con shebang, docstring e `main()`
   - **Go**: `main.go` con `package main`
   - **Rust**: `main.rs` con `fn main()`
   - **Zig**: `main.zig` con `pub fn main()`
   - **JavaScript**: `<nome>.js` con shebang Node.js

4. **File di test**: Script `test_*.sh` eseguibile
   - Include test base (compilazione, esecuzione)
   - Usa utility da `scripts/testlib/`
   - Segnaposto per test specifici
   - Produce `TEST_RESULT=<0-100>`

Esempio struttura generata:
```
bash/day02/
├── README.md                      # Template con titolo da STUDY.md
├── file_permissions_checker.sh    # Script bash con template
└── test_file_permissions_checker.sh  # Test script con 5 test base
```

### Completare una sfida

```bash
./scripts/adventalex.sh done <linguaggio> <numero>
```

Esempio:
```bash
./scripts/adventalex.sh done bash 1
./scripts/adventalex.sh done zig 1
```

Questo comando:
- Cerca ed esegue automaticamente il file `test_*.sh` nella directory della sfida
- Estrae il valore `TEST_RESULT` dall'output del test (0-100)
- Se `TEST_RESULT=100`: segna la sfida come ✅ done in `progress.md`
- Se `TEST_RESULT<100`: segna la sfida come ❌ failed con la percentuale raggiunta
- Legge il titolo dal `README.md` della sfida

### Visualizzare i progressi

Consulta il file `progress.md` per vedere lo stato di tutte le sfide:
- ⬜ todo - Da iniziare
- ⏳ started - In corso
- ❌ failed - Test non passati (mostra %)
- ✅ done - Completata (100%)

## Librerie di test

Il progetto include utility per scrivere test in Bash (`scripts/testlib/`):

- **ansi.sh**: Codici colore ANSI (RED, GREEN, YELLOW, BLUE, etc.)
- **test_utils.sh**: Funzioni di assertion e output:
  - `info "msg"` - Info blu con ℹ
  - `ok "msg"` - Successo verde con ✔
  - `warn "msg"` - Warning giallo con ⚠
  - `bad "msg"` - Errore rosso con ✘
  - `assert_executable <path>` - Verifica file eseguibile
  - `assert_not_empty <value> <msg>` - Verifica stringa non vuota
  - `assert_contains <haystack> <needle> <msg>` - Verifica substring

Esempio di test:
```bash
#!/usr/bin/env bash
source "$(dirname "$0")/../../scripts/testlib/test_utils.sh"

TOTAL=3
PASS=0

assert_executable "./solution.sh" && ((PASS++))
OUTPUT=$(./solution.sh)
assert_not_empty "$OUTPUT" "Output non vuoto" && ((PASS++))
assert_contains "$OUTPUT" "expected" "Contiene 'expected'" && ((PASS++))

PERCENT=$((PASS * 100 / TOTAL))
echo "TEST_RESULT=$PERCENT"
```

## Workflow completo

**Workflow semplificato (consigliato)**:

1. **Avvia la sfida**: 
   ```bash
   ./scripts/adventalex.sh start bash
   ```
   Output:
   ```
   🔍 Prossima sfida libera: Day 03
   📖 Titolo da STUDY.md: Network Connectivity Test
   ✨ Struttura creata in: bash/day03
   🚀 Started: Bash 03 – Network Connectivity Test
   ```

2. **Implementa la soluzione**:
   ```bash
   cd bash/day03
   cat README.md                    # Leggi la specifica
   vim network_connectivity_test.sh # Implementa
   ```

3. **Testa manualmente**:
   ```bash
   ./test_network_connectivity_test.sh
   # ℹ Bash Day - Network Connectivity Test
   # ✔ Script eseguibile
   # ✔ Output non vuoto
   # TEST_RESULT=40
   ```

4. **Completa quando i test passano**:
   ```bash
   cd ../..
   ./scripts/adventalex.sh done bash 3
   ```
   Output se 100%:
   ```
   🧪 Running tests: bash/day03/test_network_connectivity_test.sh
   TEST_RESULT=100
   ✅ DONE (100%)
   ```

5. **Commit e prossima sfida**:
   ```bash
   git add bash/day03
   git commit -m "Bash day03: Network Connectivity Test"
   ./scripts/adventalex.sh start bash  # Automaticamente day04
   ```

**Ciclo quotidiano ideale**:
```bash
# Mattina (3 min)
./scripts/adventalex.sh start python

# Durante il giorno (10 min max)
cd python/dayXX && vim *.py

# Sera (2 min)
./scripts/adventalex.sh done python XX
git add . && git commit -m "Python dayXX: <titolo>"
```
