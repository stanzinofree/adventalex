#!/usr/bin/env bash
source "$(dirname "$0")/../../scripts/testlib/test_utils.sh"

SCRIPT="$(dirname "$0")/rest_api_client.py"

info "Python Day - REST API Client"

TOTAL=5
PASS=0

# Test 1: Python presente
if command -v python3 >/dev/null 2>&1; then
  ok "python3 presente"
  ((PASS++))
else
  bad "python3 non trovato"
fi

# Test 2: Script eseguibile
assert_executable "$SCRIPT" && ((PASS++))

# Test 3: Esecuzione senza errori
if python3 "$SCRIPT" >/dev/null 2>&1; then
  ok "Esecuzione senza errori"
  ((PASS++))
else
  bad "Errore durante esecuzione"
fi

# Test 4-5: TODO - Aggiungi test specifici qui

PERCENT=$((PASS * 100 / TOTAL))
echo "TEST_RESULT=$PERCENT"
