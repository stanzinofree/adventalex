#!/usr/bin/env bash
set -u

# Directory del test (bash/day01)
TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$TEST_DIR/../.." && pwd)"

# Import libreria test comune
# shellcheck source=../../scripts/testlib/test_utils.sh
source "$ROOT_DIR/scripts/testlib/test_utils.sh"

TOTAL=5
PASS=0

SCRIPT="$TEST_DIR/system_summary.sh"

info "Bash Day01 - System Summary"

assert_executable "$SCRIPT" && ((PASS++))

OUTPUT="$("$SCRIPT" 2>/dev/null || true)"

assert_not_empty "$OUTPUT" "Output non vuoto" && ((PASS++))
assert_contains "$OUTPUT" "Host:" "Contiene Host:" && ((PASS++))
assert_contains "$OUTPUT" "User:" "Contiene User:" && ((PASS++))
assert_contains "$OUTPUT" "Disk"  "Contiene Disk"  && ((PASS++))

PERCENT=$((PASS * 100 / TOTAL))

echo "TEST_RESULT=$PERCENT"
exit 0
