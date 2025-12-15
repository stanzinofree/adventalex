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

### Tutte le 180 sfide sono già pronte!

**Non serve più il comando `start`** - tutte le sfide sono state pre-generate con:
- README.md con obiettivo e descrizione
- File di implementazione con template
- Script di test funzionante

**Trova la tua prossima sfida**: Consulta `progress.md` per vedere quali sfide sono ⬜ todo.

### Struttura delle sfide (pre-generate)

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

**Workflow ultra-semplificato** (tutte le sfide già pronte!):

1. **Scegli una sfida da `progress.md`**:
   ```bash
   # Trova la prossima sfida ⬜ todo per il linguaggio che preferisci
   cat progress.md | grep -A 5 "## Bash"
   ```

2. **Vai alla directory e leggi la sfida**:
   ```bash
   cd bash/day04
   cat README.md  # Leggi obiettivo, requisiti e risorse
   ```

3. **Implementa la soluzione** (max 10 minuti):
   ```bash
   vim log_parser.sh  # Il file è già creato con template
   ```

4. **Testa manualmente**:
   ```bash
   ./test_log_parser.sh
   # ℹ Bash Day - Log Parser
   # ✔ Script eseguibile
   # ✔ Output non vuoto
   # TEST_RESULT=40
   ```

5. **Quando i test passano al 100%**:
   ```bash
   cd ../..
   ./scripts/adventalex.sh done bash 4
   ```
   Output:
   ```
   🧪 Running tests: bash/day04/test_log_parser.sh
   TEST_RESULT=100
   ✅ DONE (100%)
   ```

6. **Commit e vai alla prossima**:
   ```bash
   git add bash/day04
   git commit -m "Bash day04: Log Parser"
   # Scegli la prossima sfida da progress.md!
   ```

**Ciclo quotidiano ideale**:
```bash
# 1. Scegli sfida (30 sec)
cat progress.md | grep -A 3 "## Python"

# 2. Implementa (10 min max)
cd python/day05 && vim http_client.py

# 3. Completa (2 min)
cd ../.. && ./scripts/adventalex.sh done python 5

# 4. Commit (30 sec)
git add . && git commit -m "Python day05: HTTP Client"
```

**Total time: ~13 minuti/giorno** per mantenersi in allenamento! 🚀
