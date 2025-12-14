#!/usr/bin/env bash

set -euo pipefail

DAY="$1"
LANG="$2"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROGRESS_FILE="$ROOT_DIR/progress.md"

TODO_BADGE="![todo](assets/badges/todo.svg)"
DONE_BADGE="![done](assets/badges/done.svg)"

if [[ -z "$DAY" || -z "$LANG" ]]; then
  echo "Uso: update_progress.sh <DAY> <LANG>"
  exit 1
fi

DAY_PADDED=$(printf "%02d" "$DAY")

sed -i.bak \
  "s#| $DAY_PADDED | $LANG | .* |#| $DAY_PADDED | $LANG | $DONE_BADGE |#" \
  "$PROGRESS_FILE"

rm -f "$PROGRESS_FILE.bak"

echo "✔ Giorno $DAY_PADDED ($LANG) marcato come DONE"
