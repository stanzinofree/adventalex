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

```bash
./scripts/adventalex.sh start <linguaggio> <numero> "<Titolo Sfida>"
```

Esempio:
```bash
./scripts/adventalex.sh start zig 1 "Zig Hello CLI"
./scripts/adventalex.sh start bash 2 "Check Permissions"
```

Questo comando:
- Aggiorna `progress.md` segnando la sfida come ⏳ started
- Registra il timestamp di inizio

### Struttura manuale della sfida

Dopo aver avviato la sfida, crea manualmente:

1. **Directory della sfida**: `<linguaggio>/day<numero>/`
   - Esempio: `bash/day02/`, `zig/day01/`

2. **File README.md**: Specifica della sfida
   - Obiettivo della sfida
   - Requisiti obbligatori
   - Vincoli tecnici
   - La prima riga deve contenere il titolo (con o senza #)

3. **File di implementazione**: Soluzione alla sfida
   - `main.zig`, `solution.sh`, `main.py`, etc.

4. **File di test**: Script eseguibile `test_*.sh`
   - Deve essere eseguibile (`chmod +x`)
   - Deve produrre output con `TEST_RESULT=<0-100>`
   - Può usare le utility in `scripts/testlib/`

Esempio struttura:
```
bash/day02/
├── README.md              # Specifica della sfida
├── check_perms.sh         # Implementazione
└── test_check_perms.sh    # Test (eseguibile)
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

1. Avvia la sfida: `./scripts/adventalex.sh start bash 3 "Network Checker"`
2. Crea la struttura:
   ```bash
   mkdir -p bash/day03
   touch bash/day03/README.md
   touch bash/day03/network_check.sh
   touch bash/day03/test_network_check.sh
   chmod +x bash/day03/network_check.sh
   chmod +x bash/day03/test_network_check.sh
   ```
3. Scrivi specifica, implementazione e test
4. Testa manualmente: `./bash/day03/test_network_check.sh`
5. Completa: `./scripts/adventalex.sh done bash 3`
6. Commit e vai alla prossima sfida!
