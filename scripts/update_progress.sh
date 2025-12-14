#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-}"     # start|done|fail
LANG="${2:-}"       # Bash|Zig
NUM="${3:-}"        # 1..30
TITLE="${4:-—}"     # nome sfida
TESTPCT="${5:-—}"   # 0..100 oppure —

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROGRESS="$ROOT_DIR/progress.md"
README="$ROOT_DIR/README.md"
TMP="$PROGRESS.tmp"

usage() {
  echo "Uso:"
  echo "  update_progress.sh start <Lang> <num> <title>"
  echo "  update_progress.sh done  <Lang> <num> <title> <pct>"
  echo "  update_progress.sh fail  <Lang> <num> <title> <pct>"
  exit 1
}

# Funzione per generare barra di progresso
progress_bar() {
  local done=$1
  local total=$2
  local width=30
  
  # Calcola quanti caratteri riempire proporzionalmente
  local filled=$((done * width / total))
  local empty=$((width - filled))
  
  # Se c'è almeno una sfida completata, mostra almeno 1 carattere
  if [ $done -gt 0 ] && [ $filled -eq 0 ]; then
    filled=1
    empty=$((width - 1))
  fi
  
  printf "["
  if [ $filled -gt 0 ]; then
    printf "%${filled}s" | tr ' ' '█'
  fi
  if [ $empty -gt 0 ]; then
    printf "%${empty}s" | tr ' ' '░'
  fi
  printf "]"
}

# Funzione per aggiornare la tabella sintetica nel README
update_readme_summary() {
  local langs=("Bash" "Python" "Go" "Rust" "Zig" "JavaScript")
  local total_challenges=30
  
  # Calcola statistiche per ogni linguaggio
  local summary_lines=""
  for lang in "${langs[@]}"; do
    # Conta le sfide done per questo linguaggio
    local done_count=$(grep -A $((total_challenges + 5)) "^## $lang$" "$PROGRESS" | \
                       grep "✅ done" | wc -l | tr -d ' ')
    
    # Calcola percentuale
    local percent=$((done_count * 100 / total_challenges))
    
    # Genera barra di progresso (passa done_count e total)
    local bar=$(progress_bar $done_count $total_challenges)
    
    # Aggiungi riga alla tabella
    summary_lines+="| $lang | $done_count/$total_challenges | $percent% | $bar |\n"
  done
  
  # Crea la nuova tabella
  local new_table="## Progressi\n\n"
  new_table+="| Linguaggio | Completate | Avanzamento | Progresso |\n"
  new_table+="|------------|------------|-------------|-----------|\\n"
  new_table+="$summary_lines"
  
  # Aggiorna il README.md sostituendo la sezione tra ## Progressi e la prossima ##
  awk -v table="$new_table" '
    BEGIN { in_progress = 0; printed = 0 }
    
    /^## Progressi/ {
      if (!printed) {
        printf "%s\n", table
        printed = 1
      }
      in_progress = 1
      next
    }
    
    /^## / && in_progress {
      in_progress = 0
      print
      next
    }
    
    !in_progress { print }
  ' "$README" > "$README.tmp"
  
  # Se la sezione non esisteva, aggiungila prima di "## Linguaggi"
  if ! grep -q "^## Progressi" "$README"; then
    awk -v table="$new_table" '
      /^## Linguaggi/ {
        printf "%s\n", table
      }
      { print }
    ' "$README" > "$README.tmp"
  fi
  
  mv "$README.tmp" "$README"
  echo "✔ README.md aggiornato con tabella progressi"
}

[[ -z "$ACTION" || -z "$LANG" || -z "$NUM" ]] && usage

NUM_PADDED=$(printf "%02d" "$NUM")
TS="$(date '+%Y-%m-%d %H:%M')"

case "$ACTION" in
  start)
    STATUS="⏳ started"
    STARTED="$TS"
    TEST="—"
    ;;
  done)
    STATUS="✅ done"
    STARTED="KEEP"
    TEST="${TESTPCT}%"
    ;;
  fail)
    STATUS="❌ failed"
    STARTED="KEEP"
    TEST="${TESTPCT}%"
    ;;
  *)
    usage
    ;;
esac

awk -v lang="$LANG" \
    -v num="$NUM_PADDED" \
    -v status="$STATUS" \
    -v title="$TITLE" \
    -v started="$STARTED" \
    -v test="$TEST" '
BEGIN { in_section = 0 }

# entra nella sezione del linguaggio
$0 ~ "^## "lang"$" {
  in_section = 1
  print
  next
}

# esce dalla sezione del linguaggio
$0 ~ "^## " && in_section {
  in_section = 0
  print
  next
}

# righe della tabella: parse per colonne
in_section && $0 ~ /^\|/ {
  split($0, c, "|")
  for (i = 1; i <= length(c); i++) gsub(/^ +| +$/, "", c[i])

  # c[2] = numero
  if (c[2] == num) {
    old_started = c[5]
    new_started = started
    if (started == "KEEP") new_started = old_started

    print "| ", num, " | ", title, " | ", status, " | ", new_started, " | ", test, " |"
    next
  }
}

{ print }
' "$PROGRESS" > "$TMP"

mv "$TMP" "$PROGRESS"
echo "✔ progress.md aggiornato: $ACTION $LANG $NUM_PADDED"

# Aggiorna anche la tabella sintetica nel README.md
update_readme_summary
