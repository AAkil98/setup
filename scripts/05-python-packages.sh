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

log "Installing base data-science stack (requirements.txt)..."
"$PIP" install -r "$REPO_ROOT/requirements.txt"

log "Installing LLMOps/MLOps stack (requirements-llmops.txt)..."
"$PIP" install -r "$REPO_ROOT/requirements-llmops.txt"
ok "Python packages installed into '$VENV_NAME'"

# Cross-project Python CLIs, isolated via pipx (so they don't pollute forge-ml).
if have pipx; then
  log "Installing global Python CLIs via pipx (poetry, commitizen)..."
  pipx install poetry     >/dev/null 2>&1 || pipx upgrade poetry     || true
  pipx install commitizen >/dev/null 2>&1 || pipx upgrade commitizen || true
  ok "pipx tools ready (poetry, commitizen)"
else
  warn "pipx not found — skipping poetry/commitizen (it's in the Brewfile)."
fi
