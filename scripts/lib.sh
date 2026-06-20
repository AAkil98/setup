#!/usr/bin/env bash
# Shared helpers — every step script sources this first.

set -euo pipefail

# Repo root, resolved no matter where the script is called from.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Where existing files get backed up before we replace them.
BACKUP_DIR="$HOME/.setup-backups/$(date +%Y%m%d-%H%M%S)"

# Pretty logging.
log()  { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m  !\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m  ✗\033[0m %s\n" "$*" >&2; }

# Is a command on PATH?
have() { command -v "$1" >/dev/null 2>&1; }

# Symlink a repo file into $HOME, backing up anything already there.
# Idempotent: re-running just re-points the link, no duplicate backups.
link_file() {
  local src="$1" dest="$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    ok "$(basename "$dest") already linked"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
    warn "backed up existing $(basename "$dest") -> $BACKUP_DIR"
  fi
  ln -s "$src" "$dest"
  ok "linked $(basename "$dest") -> $src"
}
