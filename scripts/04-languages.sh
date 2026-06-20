#!/usr/bin/env bash
# Step 4 — Python (pyenv + forge-ml virtualenv) and Node (nvm).
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

PYTHON_VERSION="3.12.9"
VENV_NAME="forge-ml"
NODE_VERSION="24.11.1"
NVM_VERSION="v0.39.0"

log "Step 4: Python (pyenv) + Node (nvm)"

# ---- Python -----------------------------------------------------------------
if ! have pyenv; then err "pyenv not found — run 01-homebrew.sh first."; exit 1; fi
eval "$(pyenv init -)"

log "Installing Python $PYTHON_VERSION (compiles from source, be patient)..."
pyenv install -s "$PYTHON_VERSION"
ok "Python $PYTHON_VERSION ready"

if pyenv virtualenvs --bare | grep -qx "$VENV_NAME"; then
  ok "virtualenv '$VENV_NAME' already exists"
else
  log "Creating virtualenv '$VENV_NAME'..."
  pyenv virtualenv "$PYTHON_VERSION" "$VENV_NAME"
fi
pyenv global "$VENV_NAME"
ok "pyenv global set to '$VENV_NAME'"

# ---- Node -------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  ok "nvm already installed"
else
  log "Installing nvm $NVM_VERSION..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
fi
# shellcheck disable=SC1091
\. "$NVM_DIR/nvm.sh"

if nvm ls "$NODE_VERSION" >/dev/null 2>&1; then
  ok "Node $NODE_VERSION already installed"
else
  log "Installing Node $NODE_VERSION..."
  nvm install "$NODE_VERSION"
fi
nvm alias default "$NODE_VERSION" >/dev/null
ok "Node default set to $NODE_VERSION"

# ---- Ruby (optional) --------------------------------------------------------
warn "Ruby/rbenv is optional and skipped by default."
warn "Need it later?  brew install rbenv ruby-build && rbenv install <version>"
