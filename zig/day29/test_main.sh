#!/usr/bin/env bash
source "$(dirname "$0")/../../scripts/testlib/test_utils.sh"

DIR="$(dirname "$0")"

info "Zig Day - Cross"

TOTAL=5
PASS=0

# Test 1: zig presente
if command -v zig >/dev/null 2>&1; then
  ok "zig presente: $(command -v zig)"
  ((PASS++))
else
  bad "zig non trovato"
fi

# Test 2: Run success
if zig run "$DIR/main.zig" >/dev/null 2>&1; then
  ok "zig run: exit 0"
  ((PASS++))
else
  bad "zig run failed"
fi

# Test 3-5: TODO - Aggiungi test specifici qui

PERCENT=$((PASS * 100 / TOTAL))
echo "TEST_RESULT=$PERCENT"
