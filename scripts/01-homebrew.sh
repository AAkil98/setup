#!/usr/bin/env bash
# Step 1 — Xcode Command Line Tools, Homebrew, and everything in the Brewfile.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

log "Step 1: Command Line Tools + Homebrew + Brewfile"

# 1. Xcode Command Line Tools (provides git, compilers, headers...).
if xcode-select -p >/dev/null 2>&1; then
  ok "Command Line Tools already installed"
else
  log "Triggering Command Line Tools install (a system dialog will appear)..."
  xcode-select --install || true
  warn "Complete the popup, then press Enter here to continue."
  read -r
fi

# 2. Homebrew.
if have brew; then
  ok "Homebrew already installed"
else
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make brew usable in THIS shell session.
if [ -x /opt/homebrew/bin/brew ]; then      # Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then        # Intel
  eval "$(/usr/local/bin/brew shellenv)"
fi

# 3. Install/upgrade everything declared in the Brewfile.
log "Installing apps & tools from the Brewfile (grab a coffee)..."
brew bundle --file="$REPO_ROOT/Brewfile"
ok "Homebrew packages installed"
