#!/usr/bin/env bash
#
# bootstrap.sh — Install all required developer tools for macOS & Linux.
#
# Everything this script downloads (uv, Python 3.12, Node.js, caches) is kept
# inside a single, self-contained folder in your home directory:
#
#     ~/.ai-eng-challenge-deps
#
# To completely uninstall everything this script created, just delete it:
#
#     rm -rf ~/.ai-eng-challenge-deps
#     (and, from the repo, `rm -rf .venv` to drop the project virtualenv)
#
# Usage:
#     ./scripts/bootstrap.sh          # install everything
#     source ./scripts/bootstrap.sh   # install AND load the tools into this shell
#
set -euo pipefail

# --- Resolve project root (parent of this script's directory) ----------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# --- Self-contained install root under the home directory --------------------
DEPS_DIR="${HOME}/.ai-eng-challenge-deps"
BIN_DIR="${DEPS_DIR}/bin"
NODE_DIR="${DEPS_DIR}/node"
export UV_INSTALL_DIR="${BIN_DIR}"                      # where the uv binary goes
export UV_UNMANAGED_INSTALL="${BIN_DIR}"               # don't touch PATH / shell rc
export UV_PYTHON_INSTALL_DIR="${DEPS_DIR}/python"      # downloaded Python versions
export UV_CACHE_DIR="${DEPS_DIR}/cache"                # uv download / build cache
export UV_PROJECT_ENVIRONMENT="${PROJECT_ROOT}/.venv"  # project virtualenv

mkdir -p "${BIN_DIR}" "${NODE_DIR}" "${UV_PYTHON_INSTALL_DIR}" "${UV_CACHE_DIR}"

# Prefer our sandboxed tools for the rest of this script.
export PATH="${BIN_DIR}:${NODE_DIR}/bin:${PATH}"

RED='\033[1;31m'; GREEN='\033[1;32m'; RESET='\033[0m'
log() { printf "${GREEN}==>${RESET} %s\n" "$*"; }
err() { printf "${RED}Error:${RESET} %s\n" "$*" >&2; }

# --- Detect OS / architecture (used for the Node.js download) ----------------
OS="$(uname -s)"; ARCH="$(uname -m)"
case "${OS}" in
  Linux)  NODE_OS="linux" ;;
  Darwin) NODE_OS="darwin" ;;
  *) err "Unsupported OS: ${OS} (this script supports macOS and Linux)."; exit 1 ;;
esac
case "${ARCH}" in
  x86_64|amd64) NODE_ARCH="x64" ;;
  arm64|aarch64) NODE_ARCH="arm64" ;;
  *) err "Unsupported architecture: ${ARCH}."; exit 1 ;;
esac

have() { command -v "$1" >/dev/null 2>&1; }

# A downloader helper (curl or wget).
fetch() { # fetch <url> -> stdout
  if have curl; then curl -LsSf "$1"
  elif have wget; then wget -qO- "$1"
  else err "need either curl or wget to download tools."; exit 1
  fi
}

# --- 1. git ------------------------------------------------------------------
# git generally ships with the OS / Xcode Command Line Tools and isn't something
# we can cleanly sandbox, so we only verify it and guide the user if it's absent.
if have git; then
  log "git already installed: $(git --version)"
else
  err "git is not installed."
  if [ "${NODE_OS}" = "darwin" ]; then
    echo "   Install it with: xcode-select --install"
  else
    echo "   Install it with your package manager, e.g.:"
    echo "     Debian/Ubuntu: sudo apt-get install -y git"
    echo "     Fedora:        sudo dnf install -y git"
    echo "     Arch:          sudo pacman -S git"
  fi
  echo "   Then re-run this script."
  exit 1
fi

# --- 2. uv (standalone) + Python 3.12 ----------------------------------------
if [ -x "${BIN_DIR}/uv" ]; then
  log "uv already present in ${BIN_DIR} — skipping download."
else
  log "Installing uv into ${BIN_DIR} ..."
  fetch https://astral.sh/uv/install.sh | sh
fi
log "Using uv: $(uv --version)"

log "Installing Python 3.12 (managed by uv) ..."
uv python install 3.12

# --- 3. Node.js + npm (sandboxed download) -----------------------------------
NODE_VERSION="20.17.0"   # LTS; bump as needed
if [ -x "${NODE_DIR}/bin/node" ]; then
  log "Node.js already present in ${NODE_DIR} — skipping download."
else
  NODE_PKG="node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}"
  NODE_URL="https://nodejs.org/dist/v${NODE_VERSION}/${NODE_PKG}.tar.gz"
  log "Installing Node.js ${NODE_VERSION} into ${NODE_DIR} ..."
  tmp_tar="$(mktemp)"
  fetch "${NODE_URL}" > "${tmp_tar}"
  tar -xzf "${tmp_tar}" -C "${NODE_DIR}" --strip-components=1
  rm -f "${tmp_tar}"
fi
log "Using node: $(node --version)  /  npm: $(npm --version)"

# --- 4. Project dependencies -------------------------------------------------
log "Installing backend dependencies with uv sync ..."
( cd "${PROJECT_ROOT}" && uv sync )

echo
log "All tools installed under: ${DEPS_DIR}"
log "Add them to your PATH for this session by running:"
echo "    source ./scripts/bootstrap.sh"
echo
log "Or add this line to your shell profile (~/.bashrc, ~/.zshrc) to make it permanent:"
echo "    export PATH=\"${BIN_DIR}:${NODE_DIR}/bin:\$PATH\""
echo
log "To remove EVERYTHING this script installed:"
echo "    rm -rf ${DEPS_DIR}"
echo "    rm -rf \"${PROJECT_ROOT}/.venv\""
echo
log "Verify your setup any time with:"
echo "    ./scripts/check-deps.sh"