#!/usr/bin/env bash
source "$(dirname "$0")/../../scripts/testlib/test_utils.sh"

SCRIPT="$(dirname "$0")/csv_parser.sh"

info "Bash Day - CSV Parser"

TOTAL=5
PASS=0

# Test 1: Script eseguibile
assert_executable "$SCRIPT" && ((PASS++))

# Test 2: Output non vuoto
OUTPUT=$("$SCRIPT")
assert_not_empty "$OUTPUT" "Output non vuoto" && ((PASS++))

# Test 3-5: TODO - Aggiungi test specifici qui
# assert_contains "$OUTPUT" "expected" "Contiene 'expected'" && ((PASS++))
# ...

PERCENT=$((PASS * 100 / TOTAL))
echo "TEST_RESULT=$PERCENT"
