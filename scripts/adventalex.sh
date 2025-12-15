#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  echo "Uso:"
  echo "  adventalex.sh done <lang> <num>    # Completa sfida"
  exit 1
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

cmd="${1:-}"
case "$cmd" in
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
    [[ -n "$PCT" ]] || { echo "❌ TEST_RESULT non trovato nell'output del test"; exit 1; }

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
