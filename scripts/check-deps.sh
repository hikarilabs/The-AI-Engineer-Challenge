#!/usr/bin/env bash
#
# check-deps.sh — Verify that all required developer tools are installed.
#
# Checks for every tool this project needs. If any are missing, it prints the
# list and tells you to run the bootstrap script.
#
# Usage:
#     ./scripts/check-deps.sh
#
set -euo pipefail

# Required tools. Add new ones here (and mirror them in bootstrap.sh).
REQUIRED_TOOLS=(git uv node npm)

RED=$'\033[1;31m'; GREEN=$'\033[1;32m'; YELLOW=$'\033[1;33m'; RESET=$'\033[0m'

missing=()

echo "Checking required developer tools..."
for tool in "${REQUIRED_TOOLS[@]}"; do
  if command -v "${tool}" >/dev/null 2>&1; then
    printf '  %s✓%s %-6s %s\n' "${GREEN}" "${RESET}" "${tool}" "$(command -v "${tool}")"
  else
    printf '  %s✗%s %-6s (not found)\n' "${RED}" "${RESET}" "${tool}"
    missing+=("${tool}")
  fi
done

echo
if [ ${#missing[@]} -eq 0 ]; then
  printf '%sAll required tools are installed. You'\''re good to go!%s\n' "${GREEN}" "${RESET}"
  exit 0
else
  printf '%sMissing tool(s): %s%s\n' "${YELLOW}" "${missing[*]}" "${RESET}"
  printf '%sPlease run the bootstrap script to install them:%s\n\n' "${YELLOW}" "${RESET}"
  echo "    ./scripts/bootstrap.sh"
  echo
  exit 1
fi