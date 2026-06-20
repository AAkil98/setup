#!/usr/bin/env bash
# Step 3 — SSH key + GitHub authentication (interactive).
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

log "Step 3: SSH key + GitHub login"

# 1. SSH key.
if [ -f "$HOME/.ssh/id_ed25519" ]; then
  ok "SSH key already exists (~/.ssh/id_ed25519)"
else
  email="$(git config --global user.email || echo "$USER@$(hostname)")"
  log "Generating an ed25519 SSH key for $email ..."
  ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/id_ed25519"
  ok "SSH key created"
fi

# 2. GitHub CLI auth — this can upload the SSH key for you.
if have gh; then
  if gh auth status >/dev/null 2>&1; then
    ok "Already logged in to GitHub CLI"
  else
    log "Logging in to GitHub (follow the browser prompts)..."
    gh auth login -p ssh -w
  fi
  gh auth setup-git
  ok "GitHub configured (git will authenticate through gh)"
else
  warn "'gh' isn't installed yet — run 01-homebrew.sh first, then re-run this."
fi
