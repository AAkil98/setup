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

# 3. Install everything in the Brewfile — resilient to flaky networks that drop
#    large cask downloads. brew bundle is idempotent, so each retry only
#    re-fetches whatever is still missing.
export HOMEBREW_CURL_RETRIES=5        # retry each download up to 5x
export HOMEBREW_NO_AUTO_UPDATE=1      # don't re-update on every retry
export HOMEBREW_NO_INSTALL_CLEANUP=1  # fewer ops between attempts

log "Installing apps & tools from the Brewfile (grab a coffee)..."
for i in 1 2 3 4; do
  brew bundle --file="$REPO_ROOT/Brewfile" && break
  warn "brew bundle hit failures (usually dropped downloads) — retry in 15s [$i/4]..."
  sleep 15
done

# Retry any casks that still didn't land, one at a time — the big GUI downloads
# are what flaky networks drop. Cask names are read straight from the Brewfile.
grep -E '^[[:space:]]*cask ' "$REPO_ROOT/Brewfile" \
  | sed -E 's/^[[:space:]]*cask "([^"]+)".*/\1/' | while read -r c; do
    brew list --cask "$c" >/dev/null 2>&1 && continue
    warn "cask '$c' still missing — retrying it on its own..."
    brew install --cask "$c" || warn "  '$c' failed again — grab it later on a stabler network"
  done || true

# Don't abort the whole setup over one stubborn GUI app — report and move on.
if brew bundle check --file="$REPO_ROOT/Brewfile" >/dev/null 2>&1; then
  ok "All Homebrew packages installed"
else
  warn "Some packages are still missing."
  warn "Re-run './install.sh 1' on a better connection, or list what's left with:"
  warn "  brew bundle check --file=\"$REPO_ROOT/Brewfile\" --verbose"
fi
