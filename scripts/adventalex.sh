#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROGRESS_FILE="$ROOT_DIR/progress.md"

SUPPORTED_LANGS="bash python go rust zig javascript"

usage() {
  echo "Uso:"
  echo "  adventalex.sh init <lang>"
  echo "  adventalex.sh done <lang> <day>"
  echo "  adventalex.sh status"
  echo ""
  echo "Linguaggi supportati: $SUPPORTED_LANGS"
  exit 1
}

validate_lang() {
  for l in $SUPPORTED_LANGS; do
    [[ "$l" == "$1" ]] && return 0
  done
  echo "❌ Linguaggio non supportato: $1"
  usage
}

find_next_day() {
  awk '
    NR>2 {
      if ($NF ~ /todo/) {
        gsub(/\|/, "", $2)
        print $2
        exit
      }
    }
  ' "$PROGRESS_FILE"
}

cmd="${1:-}"

case "$cmd" in
  init)
    LANG="${2:-}"
    [[ -z "$LANG" ]] && usage
    validate_lang "$LANG"

    DAY="$(find_next_day)"
    [[ -z "$DAY" ]] && {
      echo "🎉 Tutti i giorni completati!"
      exit 0
    }

    DIR="$ROOT_DIR/$LANG/day$DAY"
    mkdir -p "$DIR"

    README="$DIR/README.md"
    if [[ ! -f "$README" ]]; then
      DATE_INIT="$(date '+%Y-%m-%d')"

      cat > "$README" <<EOF
# Day $DAY – $LANG

🗓️ Inizializzato il: **$DATE_INIT**

## Obiettivo

## Vincoli
- Max 10 minuti

## Output atteso

## Note
EOF
      echo "✔ Inizializzato Day $DAY ($LANG)"
    else
      echo "ℹ README già esistente"
    fi
    ;;

  done)
    LANG="${2:-}"
    DAY="${3:-}"
    [[ -z "$LANG" || -z "$DAY" ]] && usage
    validate_lang "$LANG"

    ./scripts/update_progress.sh "$DAY" "$LANG"
    ;;

  status)
    cat "$PROGRESS_FILE"
    ;;

  *)
    usage
    ;;
esac
