#!/usr/bin/env bash
set -euo pipefail

# Test runner for lint-tells.sh.
# Verifies: bad fixture triggers findings, clean fixture passes.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
LINT="${REPO_DIR}/scripts/lint-tells.sh"
FIXTURES="${REPO_DIR}/fixtures"

PASS=0
FAIL=0

run_test() {
  local name="$1"
  local expected_exit="$2"
  shift 2
  local actual_exit=0

  "$@" > /dev/null 2>&1 || actual_exit=$?

  if [ "$actual_exit" -eq "$expected_exit" ]; then
    echo "  PASS: ${name}"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: ${name} (expected exit ${expected_exit}, got ${actual_exit})"
    FAIL=$((FAIL + 1))
  fi
}

echo "Running lint-tells.sh tests"
echo ""

run_test "bad.tsx triggers findings (exit 1)" 1 bash "$LINT" "${FIXTURES}/bad.tsx"
run_test "clean.tsx passes (exit 0)" 0 bash "$LINT" "${FIXTURES}/clean.tsx"
run_test "directory scan finds bad.tsx (exit 1)" 1 bash "$LINT" "${FIXTURES}"
run_test "no arguments prints usage (exit 2)" 2 bash "$LINT"

echo ""
echo "${PASS} passed, ${FAIL} failed."

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
