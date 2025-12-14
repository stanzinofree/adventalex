#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-}"     # start|done|fail
LANG="${2:-}"       # Bash|Zig
NUM="${3:-}"        # 1..30
TITLE="${4:-—}"     # nome sfida
TESTPCT="${5:-—}"   # 0..100 oppure —

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROGRESS="$ROOT_DIR/progress.md"
TMP="$PROGRESS.tmp"

usage() {
  echo "Uso:"
  echo "  update_progress.sh start <Lang> <num> <title>"
  echo "  update_progress.sh done  <Lang> <num> <title> <pct>"
  echo "  update_progress.sh fail  <Lang> <num> <title> <pct>"
  exit 1
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
