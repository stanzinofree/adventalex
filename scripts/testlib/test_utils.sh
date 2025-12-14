#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=ansi.sh
source "$SCRIPT_DIR/ansi.sh"

info() { echo -e "${BLUE}ℹ${RESET} $1"; }
ok()   { echo -e "${GREEN}✔${RESET} $1"; }
warn() { echo -e "${YELLOW}⚠${RESET} $1"; }
bad()  { echo -e "${RED}✘${RESET} $1"; }

# Assert "soft": ritorna 0/1 ma NON fa exit
assert_executable() {
  if [[ -x "$1" ]]; then ok "$1 eseguibile"; return 0; else bad "$1 non eseguibile"; return 1; fi
}
assert_not_empty() {
  local v="$1" msg="$2"
  if [[ -n "$v" ]]; then ok "$msg"; return 0; else bad "$msg"; return 1; fi
}
assert_contains() {
  local hay="$1" needle="$2" msg="$3"
  if echo "$hay" | grep -qi "$needle"; then ok "$msg"; return 0; else bad "$msg"; return 1; fi
}
