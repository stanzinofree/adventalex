#!/usr/bin/env bash
source "$(dirname "$0")/../../scripts/testlib/test_utils.sh"

DIR="$(dirname "$0")"

info "Rust Day - Iterators"

TOTAL=5
PASS=0

# Test 1: rustc presente
if command -v rustc >/dev/null 2>&1; then
  ok "rustc presente: $(command -v rustc)"
  ((PASS++))
else
  bad "rustc non trovato"
fi

# Test 2: Compile success
if rustc "$DIR/main.rs" -o "$DIR/main_test" 2>/dev/null; then
  ok "Compile success"
  ((PASS++))
else
  bad "Compile failed"
fi

# Test 3: Run success
if [[ -x "$DIR/main_test" ]] && "$DIR/main_test" >/dev/null 2>&1; then
  ok "Run success"
  ((PASS++))
  rm -f "$DIR/main_test"
else
  bad "Run failed"
fi

# Test 4-5: TODO - Aggiungi test specifici qui

PERCENT=$((PASS * 100 / TOTAL))
echo "TEST_RESULT=$PERCENT"
