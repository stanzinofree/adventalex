#!/usr/bin/env bash
source "$(dirname "$0")/../../scripts/testlib/test_utils.sh"

SCRIPT="$(dirname "$0")/variables__types.js"

info "JavaScript Day - Variables & Types"

TOTAL=5
PASS=0

# Test 1: node presente
if command -v node >/dev/null 2>&1; then
  ok "node presente: $(command -v node)"
  ((PASS++))
else
  bad "node non trovato"
fi

# Test 2: Script eseguibile
assert_executable "$SCRIPT" && ((PASS++))

# Test 3: Run success
if node "$SCRIPT" >/dev/null 2>&1; then
  ok "Run success"
  ((PASS++))
else
  bad "Run failed"
fi

# Test 4-5: TODO - Aggiungi test specifici qui

PERCENT=$((PASS * 100 / TOTAL))
echo "TEST_RESULT=$PERCENT"
