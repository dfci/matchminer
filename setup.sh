#!/usr/bin/env bash
# Served at https://matchminer.org/setup.sh, which the dfci/matchminer README
# pipes to bash. The old WordPress site 301-redirected this URL to the script
# below; GitHub Pages can't redirect, so this shim fetches and runs it instead.
# The real script is configured through environment variables
# (MATCHMINER_GIT_REMOTE_REF, MATCHMINER_SETUP_DIR), which pass through.
set -euo pipefail

SETUP_URL="https://raw.githubusercontent.com/dfci/matchminer-setup/HEAD/setup.sh"

if ! script="$(curl -fsSL "$SETUP_URL")"; then
  echo "Could not download the MatchMiner setup script from $SETUP_URL" >&2
  exit 1
fi

# Run with bash -c so the script sees the same conditions as `curl | bash`
# (no BASH_SOURCE, so it fetches a fresh copy of the setup repo).
exec bash -c "$script" setup.sh "$@"
