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

# 2. SSH config (macOS keychain integration + GitHub host).
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
link_file "$REPO_ROOT/dotfiles/ssh/config" "$HOME/.ssh/config"

# 3. GitHub CLI auth — this can upload the SSH key for you.
if have gh; then
  if gh auth status >/dev/null 2>&1; then
    ok "Already logged in to GitHub CLI"
  else
    log "Logging in to GitHub (follow the browser prompts)..."
    gh auth login -p ssh -w
  fi
  gh auth setup-git
  ok "GitHub configured (git will authenticate through gh)"

  # gh aliases (you already had `co`).
  gh alias set prs 'pr list'       2>/dev/null || true
  gh alias set prv 'pr view --web' 2>/dev/null || true
  gh alias set co  'pr checkout'   2>/dev/null || true
  gh alias set rc  'repo create'   2>/dev/null || true
  ok "gh aliases set (prs, prv, co, rc)"

  # gh-dash — PR/issue dashboard across your repos (run: gh dash).
  if gh extension list 2>/dev/null | grep -q 'dlvhdr/gh-dash'; then
    ok "gh-dash already installed"
  else
    log "Installing gh-dash extension..."
    gh extension install dlvhdr/gh-dash 2>/dev/null \
      && ok "gh-dash installed (run: gh dash)" \
      || warn "gh-dash install failed — retry: gh extension install dlvhdr/gh-dash"
  fi
  mkdir -p "$HOME/.config/gh-dash"
  link_file "$REPO_ROOT/dotfiles/gh-dash/config.yml" "$HOME/.config/gh-dash/config.yml"
else
  warn "'gh' isn't installed yet — run 01-homebrew.sh first, then re-run this."
fi
