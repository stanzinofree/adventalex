#!/usr/bin/env bash
set -u

TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$TEST_DIR/../.." && pwd)"

# shellcheck source=../../scripts/testlib/test_utils.sh
source "$ROOT_DIR/scripts/testlib/test_utils.sh"

TOTAL=5
PASS=0

info "Zig Day01 - Hello CLI"

# 1) zig presente
ZIG_BIN="$(command -v zig || true)"
if [[ -n "$ZIG_BIN" && -x "$ZIG_BIN" ]]; then
  ok "zig presente: $ZIG_BIN"
  ((PASS++))
else
  bad "zig non trovato"
fi

# 2) esecuzione (catturo anche stderr)
OUT=""
if OUT="$(zig run "$TEST_DIR/main.zig" 2>&1)"; then
  ok "zig run: exit 0"
  ((PASS++))
else
  bad "zig run: exit != 0"
fi

# Mostra output (utile per debug)
echo -e "${GRAY}--- zig output ---${RESET}"
echo "$OUT"
echo -e "${GRAY}------------------${RESET}"

# 3) output non vuoto
assert_not_empty "$OUT" "Output non vuoto" && ((PASS++))

# 4) contiene Zig
assert_contains "$OUT" "Zig" "Contiene 'Zig'" && ((PASS++))

# 5) contiene OK (nel tuo caso non c’è, quindi non passerà finché non lo aggiungi)
assert_contains "$OUT" "OK" "Contiene 'OK'" && ((PASS++))

PERCENT=$((PASS * 100 / TOTAL))
echo "TEST_RESULT=$PERCENT"
exit 0
