#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

# Import librerie comuni
# shellcheck source=../../scripts/testlib/test_utils.sh
source "$ROOT_DIR/scripts/testlib/test_utils.sh"

SCRIPT="./system_summary.sh"

info "Avvio test System Summary"

assert_executable "$SCRIPT"

OUTPUT="$($SCRIPT)"

assert_not_empty "$OUTPUT" "Output non vuoto"

echo -e "${GRAY}--- Output script ---${RESET}"
echo "$OUTPUT"
echo -e "${GRAY}---------------------${RESET}"

assert_contains "$OUTPUT" "host" "Hostname presente"
assert_contains "$OUTPUT" "user" "Utente presente"
assert_contains "$OUTPUT" "up" "Uptime presente"
assert_contains "$OUTPUT" "date" "Data presente"
assert_contains "$OUTPUT" "/" "Spazio disco root presente"

echo ""
echo -e "${GREEN}${BOLD}🎉 Tutti i test superati!${RESET}"
