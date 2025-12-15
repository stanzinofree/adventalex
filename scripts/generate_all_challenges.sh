#!/usr/bin/env bash
set -euo pipefail

# Script per generare tutte le 180 sfide con README dettagliati
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source le funzioni condivise
source "$ROOT_DIR/scripts/challenge_functions.sh"

echo "🚀 Generazione di tutte le 180 sfide..."
echo ""

# Array linguaggi
LANGUAGES=("bash" "python" "go" "rust" "zig" "javascript")

# Contatore
TOTAL=0
CREATED=0
SKIPPED=0

for lang in "${LANGUAGES[@]}"; do
  echo "📦 Generando sfide per $lang..."
  
  for day in {1..30}; do
    day_padded=$(printf "%02d" "$day")
    daydir="$ROOT_DIR/$lang/day$day_padded"
    
    # Se esiste già, salta
    if [[ -d "$daydir" ]]; then
      echo "  ⏭  Day $day_padded - già esistente, skip"
      SKIPPED=$((SKIPPED + 1))
      TOTAL=$((TOTAL + 1))
      continue
    fi
    
    # Ottieni titolo e descrizione da STUDY.md
    LANG_NORMALIZED=$(lang_map "$lang")
    TITLE=$(get_challenge_title "$lang" "$day")
    DESCRIPTION=$(get_challenge_description "$lang" "$day")
    
    if [[ -z "$TITLE" ]]; then
      echo "  ❌ Day $day_padded - titolo non trovato in STUDY.md"
      TOTAL=$((TOTAL + 1))
      continue
    fi
    
    # Crea la struttura
    create_challenge_structure "$lang" "$day_padded" "$TITLE" "$DESCRIPTION"
    echo "  ✨ Day $day_padded - $TITLE"
    
    CREATED=$((CREATED + 1))
    TOTAL=$((TOTAL + 1))
  done
  
  echo ""
done

echo "📊 Riepilogo:"
echo "   Totale sfide: $TOTAL"
echo "   Create: $CREATED"
echo "   Saltate (già esistenti): $SKIPPED"
echo ""
echo "✅ Generazione completata!"
