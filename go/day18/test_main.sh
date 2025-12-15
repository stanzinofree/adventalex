#!/usr/bin/env bash
source "$(dirname "$0")/../../scripts/testlib/test_utils.sh"

DIR="$(dirname "$0")"

info "Go Day - HTTP Server"

TOTAL=5
PASS=0

# Test 1: Go presente
if command -v go >/dev/null 2>&1; then
  ok "go presente: $(command -v go)"
  ((PASS++))
else
  bad "go non trovato"
fi

# Test 2: Build success
if go build -o "$DIR/main_test" "$DIR/main.go" 2>/dev/null; then
  ok "Build success"
  ((PASS++))
  rm -f "$DIR/main_test"
else
  bad "Build failed"
fi

# Test 3: Run success
if go run "$DIR/main.go" >/dev/null 2>&1; then
  ok "Run success"
  ((PASS++))
else
  bad "Run failed"
fi

# Test 4-5: TODO - Aggiungi test specifici qui

PERCENT=$((PASS * 100 / TOTAL))
echo "TEST_RESULT=$PERCENT"
