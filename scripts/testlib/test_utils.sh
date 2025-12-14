#!/usr/bin/env bash

set -euo pipefail

# Carica colori
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=ansi.sh
source "$SCRIPT_DIR/ansi.sh"

fail() {
  echo -e "${RED}${BOLD}❌ FAIL${RESET} $1"
  exit 1
}

pass() {
  echo -e "${GREEN}✔${RESET} $1"
}

info() {
  echo -e "${BLUE}ℹ${RESET} $1"
}

assert_not_empty() {
  local value="$1"
  local msg="$2"

  [[ -z "$value" ]] && fail "$msg"
  pass "$msg"
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local msg="$3"

  echo "$haystack" | grep -qi "$needle" \
    || fail "$msg"

  pass "$msg"
}

assert_executable() {
  [[ -x "$1" ]] || fail "$1 non eseguibile o mancante"
  pass "$1 eseguibile"
}
