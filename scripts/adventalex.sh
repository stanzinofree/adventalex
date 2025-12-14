#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  echo "Uso:"
  echo "  adventalex.sh start <lang>          # Avvia prossima sfida libera"
  echo "  adventalex.sh start <lang> <num>    # Avvia sfida specifica (opzionale)"
  echo "  adventalex.sh done  <lang> <num>    # Completa sfida"
  exit 1
}

# Trova la prossima sfida libera per un linguaggio
find_next_challenge() {
  local lang_normalized="$1"  # es. "Bash"
  local progress_file="$ROOT_DIR/progress.md"
  
  # Cerca la prima riga con stato ⬜ todo nella sezione del linguaggio
  local next_num=$(awk -v lang="$lang_normalized" '
    BEGIN { in_section = 0 }
    $0 ~ "^## "lang"$" { in_section = 1; next }
    $0 ~ "^## " && in_section { exit }
    in_section && $0 ~ /⬜ todo/ {
      split($0, parts, "|")
      gsub(/^[ \t]+|[ \t]+$/, "", parts[2])
      print parts[2]
      exit
    }
  ' "$progress_file")
  
  echo "$next_num"
}

# Legge il titolo della sfida da STUDY.md
get_challenge_title() {
  local lang_raw="$1"
  local day_num="$2"
  local study_file="$ROOT_DIR/STUDY.md"
  
  # Mappa linguaggio raw a pattern in STUDY.md
  local lang_pattern=""
  case "$lang_raw" in
    bash) lang_pattern="Bash" ;;
    python) lang_pattern="Python" ;;
    go) lang_pattern="Go" ;;
    rust) lang_pattern="Rust" ;;
    zig) lang_pattern="Zig" ;;
    javascript) lang_pattern="JavaScript" ;;
  esac
  
  # Cerca pattern: **Day01**: Title - Description
  local title=$(awk -v pattern="$lang_pattern" -v day="Day$(printf '%02d' $day_num)" '
    # Trova sezione linguaggio
    $0 ~ "^## .*"pattern {
      in_lang = 1
      next
    }
    # Esce dalla sezione se trova un altro linguaggio
    in_lang && $0 ~ "^## [^#]" {
      in_lang = 0
    }
    # Cerca il giorno specifico
    in_lang && $0 ~ "\\*\\*"day"\\*\\*:" {
      # Estrae il titolo manualmente
      # Pattern: **DayXX**: Title - Description
      sub(/.*\*\*Day[0-9]+\*\*: */, "")  # Rimuove tutto prima del titolo
      sub(/ *-.*/, "")                    # Rimuove tutto dopo il trattino
      gsub(/^[ \t]+|[ \t]+$/, "")        # Trim
      print
      exit
    }
  ' "$study_file")
  
  echo "$title"
}

lang_map() {
  # converte "bash" -> "Bash", "zig" -> "Zig"
  case "$1" in
    bash) echo "Bash" ;;
    python) echo "Python" ;;
    go) echo "Go" ;;
    rust) echo "Rust" ;;
    zig) echo "Zig" ;;
    javascript) echo "JavaScript" ;;
    *) echo "$1" ;;
  esac
}

create_challenge_structure() {
  local lang_raw="$1"
  local num_padded="$2"
  local title="$3"
  local daydir="$ROOT_DIR/$lang_raw/day$num_padded"
  
  # Crea directory
  mkdir -p "$daydir"
  
  # Crea README.md
  cat > "$daydir/README.md" <<EOF
# $title

## Obiettivo
[Descrivi l'obiettivo della sfida qui]

## Requisiti
- [ ] Requisito 1
- [ ] Requisito 2
- [ ] Requisito 3

## Vincoli
- Max 10 minuti
- Deve essere funzionante
- Test devono passare al 100%

## Risorse
- [Documentazione ufficiale]
- [Tutorial/Guide]

## Note
[Eventuali note aggiuntive]
EOF
  
  # Crea file implementazione e test in base al linguaggio
  case "$lang_raw" in
    bash)
      create_bash_template "$daydir" "$title"
      ;;
    python)
      create_python_template "$daydir" "$title"
      ;;
    go)
      create_go_template "$daydir" "$title"
      ;;
    rust)
      create_rust_template "$daydir" "$title"
      ;;
    zig)
      create_zig_template "$daydir" "$title"
      ;;
    javascript)
      create_javascript_template "$daydir" "$title"
      ;;
  esac
  
  echo "✨ Struttura creata in: $daydir"
  echo "   - README.md"
  echo "   - File implementazione"
  echo "   - File test"
}

create_bash_template() {
  local dir="$1"
  local title="$2"
  local script_name="$(echo "$title" | tr '[:upper:] ' '[:lower:]_' | sed 's/[^a-z0-9_]//g').sh"
  
  # Script principale
  cat > "$dir/$script_name" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Implementazione della sfida
echo "=== TODO: Implementa la sfida qui ==="
EOF
  chmod +x "$dir/$script_name"
  
  # Test script
  cat > "$dir/test_${script_name}" <<EOF
#!/usr/bin/env bash
source "\$(dirname "\$0")/../../scripts/testlib/test_utils.sh"

SCRIPT="\$(dirname "\$0")/$script_name"

info "Bash Day - $title"

TOTAL=5
PASS=0

# Test 1: Script eseguibile
assert_executable "\$SCRIPT" && ((PASS++))

# Test 2: Output non vuoto
OUTPUT=\$("\$SCRIPT")
assert_not_empty "\$OUTPUT" "Output non vuoto" && ((PASS++))

# Test 3-5: TODO - Aggiungi test specifici qui
# assert_contains "\$OUTPUT" "expected" "Contiene 'expected'" && ((PASS++))
# ...

PERCENT=\$((PASS * 100 / TOTAL))
echo "TEST_RESULT=\$PERCENT"
EOF
  chmod +x "$dir/test_${script_name}"
}

create_python_template() {
  local dir="$1"
  local title="$2"
  local script_name="$(echo "$title" | tr '[:upper:] ' '[:lower:]_' | sed 's/[^a-z0-9_]//g').py"
  
  # Script principale
  cat > "$dir/$script_name" <<'EOF'
#!/usr/bin/env python3
"""
TODO: Implementa la sfida qui
"""

def main():
    print("=== TODO: Implementa la sfida qui ===")

if __name__ == "__main__":
    main()
EOF
  chmod +x "$dir/$script_name"
  
  # Test script
  cat > "$dir/test_${script_name%.py}.sh" <<EOF
#!/usr/bin/env bash
source "\$(dirname "\$0")/../../scripts/testlib/test_utils.sh"

SCRIPT="\$(dirname "\$0")/$script_name"

info "Python Day - $title"

TOTAL=5
PASS=0

# Test 1: Python presente
if command -v python3 >/dev/null 2>&1; then
  ok "python3 presente"
  ((PASS++))
else
  bad "python3 non trovato"
fi

# Test 2: Script eseguibile
assert_executable "\$SCRIPT" && ((PASS++))

# Test 3: Esecuzione senza errori
if python3 "\$SCRIPT" >/dev/null 2>&1; then
  ok "Esecuzione senza errori"
  ((PASS++))
else
  bad "Errore durante esecuzione"
fi

# Test 4-5: TODO - Aggiungi test specifici qui

PERCENT=\$((PASS * 100 / TOTAL))
echo "TEST_RESULT=\$PERCENT"
EOF
  chmod +x "$dir/test_${script_name%.py}.sh"
}

create_go_template() {
  local dir="$1"
  local title="$2"
  
  # main.go
  cat > "$dir/main.go" <<'EOF'
package main

import "fmt"

func main() {
	fmt.Println("=== TODO: Implementa la sfida qui ===")
}
EOF
  
  # Test script
  cat > "$dir/test_main.sh" <<EOF
#!/usr/bin/env bash
source "\$(dirname "\$0")/../../scripts/testlib/test_utils.sh"

DIR="\$(dirname "\$0")"

info "Go Day - $title"

TOTAL=5
PASS=0

# Test 1: Go presente
if command -v go >/dev/null 2>&1; then
  ok "go presente: \$(command -v go)"
  ((PASS++))
else
  bad "go non trovato"
fi

# Test 2: Build success
if go build -o "\$DIR/main_test" "\$DIR/main.go" 2>/dev/null; then
  ok "Build success"
  ((PASS++))
  rm -f "\$DIR/main_test"
else
  bad "Build failed"
fi

# Test 3: Run success
if go run "\$DIR/main.go" >/dev/null 2>&1; then
  ok "Run success"
  ((PASS++))
else
  bad "Run failed"
fi

# Test 4-5: TODO - Aggiungi test specifici qui

PERCENT=\$((PASS * 100 / TOTAL))
echo "TEST_RESULT=\$PERCENT"
EOF
  chmod +x "$dir/test_main.sh"
}

create_rust_template() {
  local dir="$1"
  local title="$2"
  
  # main.rs
  cat > "$dir/main.rs" <<'EOF'
fn main() {
    println!("=== TODO: Implementa la sfida qui ===");
}
EOF
  
  # Test script
  cat > "$dir/test_main.sh" <<EOF
#!/usr/bin/env bash
source "\$(dirname "\$0")/../../scripts/testlib/test_utils.sh"

DIR="\$(dirname "\$0")"

info "Rust Day - $title"

TOTAL=5
PASS=0

# Test 1: rustc presente
if command -v rustc >/dev/null 2>&1; then
  ok "rustc presente: \$(command -v rustc)"
  ((PASS++))
else
  bad "rustc non trovato"
fi

# Test 2: Compile success
if rustc "\$DIR/main.rs" -o "\$DIR/main_test" 2>/dev/null; then
  ok "Compile success"
  ((PASS++))
else
  bad "Compile failed"
fi

# Test 3: Run success
if [[ -x "\$DIR/main_test" ]] && "\$DIR/main_test" >/dev/null 2>&1; then
  ok "Run success"
  ((PASS++))
  rm -f "\$DIR/main_test"
else
  bad "Run failed"
fi

# Test 4-5: TODO - Aggiungi test specifici qui

PERCENT=\$((PASS * 100 / TOTAL))
echo "TEST_RESULT=\$PERCENT"
EOF
  chmod +x "$dir/test_main.sh"
}

create_zig_template() {
  local dir="$1"
  local title="$2"
  
  # main.zig
  cat > "$dir/main.zig" <<'EOF'
const std = @import("std");

pub fn main() void {
    std.debug.print("=== TODO: Implementa la sfida qui ===\n", .{});
}
EOF
  
  # Test script
  cat > "$dir/test_main.sh" <<EOF
#!/usr/bin/env bash
source "\$(dirname "\$0")/../../scripts/testlib/test_utils.sh"

DIR="\$(dirname "\$0")"

info "Zig Day - $title"

TOTAL=5
PASS=0

# Test 1: zig presente
if command -v zig >/dev/null 2>&1; then
  ok "zig presente: \$(command -v zig)"
  ((PASS++))
else
  bad "zig non trovato"
fi

# Test 2: Run success
if zig run "\$DIR/main.zig" >/dev/null 2>&1; then
  ok "zig run: exit 0"
  ((PASS++))
else
  bad "zig run failed"
fi

# Test 3-5: TODO - Aggiungi test specifici qui

PERCENT=\$((PASS * 100 / TOTAL))
echo "TEST_RESULT=\$PERCENT"
EOF
  chmod +x "$dir/test_main.sh"
}

create_javascript_template() {
  local dir="$1"
  local title="$2"
  local script_name="$(echo "$title" | tr '[:upper:] ' '[:lower:]_' | sed 's/[^a-z0-9_]//g').js"
  
  # Script principale
  cat > "$dir/$script_name" <<'EOF'
#!/usr/bin/env node

// TODO: Implementa la sfida qui
console.log("=== TODO: Implementa la sfida qui ===");
EOF
  chmod +x "$dir/$script_name"
  
  # Test script
  cat > "$dir/test_${script_name%.js}.sh" <<EOF
#!/usr/bin/env bash
source "\$(dirname "\$0")/../../scripts/testlib/test_utils.sh"

SCRIPT="\$(dirname "\$0")/$script_name"

info "JavaScript Day - $title"

TOTAL=5
PASS=0

# Test 1: node presente
if command -v node >/dev/null 2>&1; then
  ok "node presente: \$(command -v node)"
  ((PASS++))
else
  bad "node non trovato"
fi

# Test 2: Script eseguibile
assert_executable "\$SCRIPT" && ((PASS++))

# Test 3: Run success
if node "\$SCRIPT" >/dev/null 2>&1; then
  ok "Run success"
  ((PASS++))
else
  bad "Run failed"
fi

# Test 4-5: TODO - Aggiungi test specifici qui

PERCENT=\$((PASS * 100 / TOTAL))
echo "TEST_RESULT=\$PERCENT"
EOF
  chmod +x "$dir/test_${script_name%.js}.sh"
}

cmd="${1:-}"
case "$cmd" in
  start)
    LRAW="${2:-}"
    NUM="${3:-}"
    TITLE="${4:-}"
    
    [[ -z "$LRAW" ]] && usage
    
    LANG="$(lang_map "$LRAW")"
    
    # Se NUM non è specificato, trova la prossima sfida libera
    if [[ -z "$NUM" ]]; then
      NUM=$(find_next_challenge "$LANG")
      [[ -z "$NUM" ]] && { echo "❌ Nessuna sfida libera trovata per $LANG"; exit 1; }
      echo "🔍 Prossima sfida libera: Day $NUM"
    fi
    
    # Se TITLE non è specificato, leggilo da STUDY.md
    if [[ -z "$TITLE" ]]; then
      TITLE=$(get_challenge_title "$LRAW" "$NUM")
      [[ -z "$TITLE" ]] && { echo "❌ Titolo non trovato in STUDY.md per $LANG Day $NUM"; exit 1; }
      echo "📖 Titolo da STUDY.md: $TITLE"
    fi
    
    NUM_PADDED=$(printf "%02d" "$NUM")
    
    # Crea struttura sfida
    create_challenge_structure "$LRAW" "$NUM_PADDED" "$TITLE"
    
    # Aggiorna progress.md
    "$ROOT_DIR/scripts/update_progress.sh" start "$LANG" "$NUM" "$TITLE"
    echo "🚀 Started: $LANG $NUM – $TITLE"
    ;;

  done)
    LRAW="${2:-}"; NUM="${3:-}"
    [[ -z "$LRAW" || -z "$NUM" ]] && usage
    LANG="$(lang_map "$LRAW")"
    NUM_PADDED=$(printf "%02d" "$NUM")

    DAYDIR="$ROOT_DIR/$LRAW/day$NUM_PADDED"
    TEST_SCRIPT="$(ls "$DAYDIR"/test_*.sh 2>/dev/null | head -n1 || true)"
    [[ -n "$TEST_SCRIPT" && -x "$TEST_SCRIPT" ]] || { echo "❌ test_*.sh non trovato o non eseguibile in $DAYDIR"; exit 1; }

    echo "🧪 Running tests: $TEST_SCRIPT"
    OUT="$("$TEST_SCRIPT")"
    echo "$OUT"

    PCT="$(echo "$OUT" | awk -F= '/^TEST_RESULT=/ {print $2}' | tail -n1)"
    [[ -n "$PCT" ]] || { echo "❌ TEST_RESULT non trovato nell’output del test"; exit 1; }

    # Titolo: prova a leggerlo dal README (prima riga)
    TITLE="$(sed -n '1{s/^# *//p;}' "$DAYDIR/README.md" 2>/dev/null | head -n1)"
    [[ -n "$TITLE" ]] || TITLE="—"

    if [[ "$PCT" -eq 100 ]]; then
      ./scripts/update_progress.sh done "$LANG" "$NUM" "$TITLE" "$PCT"
      echo "✅ DONE ($PCT%)"
    else
      ./scripts/update_progress.sh fail "$LANG" "$NUM" "$TITLE" "$PCT"
      echo "❌ NOT DONE ($PCT%)"
      exit 2
    fi
    ;;
  *)
    usage
    ;;
esac
