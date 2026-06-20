#!/usr/bin/env bash
# Step 5 — install the data-science stack into the forge-ml virtualenv.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

VENV_NAME="forge-ml"

log "Step 5: Python packages -> '$VENV_NAME'"

if ! have pyenv; then err "pyenv not found — run 01-homebrew.sh first."; exit 1; fi
eval "$(pyenv init -)"

# Target the forge-ml interpreter directly so we don't depend on what's active.
PIP="$(pyenv root)/versions/$VENV_NAME/bin/pip"
if [ ! -x "$PIP" ]; then
  err "virtualenv '$VENV_NAME' not found — run 04-languages.sh first."; exit 1
fi

log "Upgrading pip..."
"$PIP" install --upgrade pip
log "Installing from requirements.txt (a few minutes)..."
"$PIP" install -r "$REPO_ROOT/requirements.txt"
ok "Data-science packages installed into '$VENV_NAME'"
