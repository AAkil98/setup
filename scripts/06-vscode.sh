#!/usr/bin/env bash
# Step 6 — install VS Code extensions and drop in settings.json.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

log "Step 6: VS Code extensions + settings"

if ! have code; then
  warn "The 'code' command isn't on your PATH yet."
  warn "Open VS Code, press Cmd+Shift+P, run"
  warn "  'Shell Command: Install \"code\" command in PATH', then re-run this script."
  exit 0
fi

# 1. Extensions — skip blank lines and # comments in the list.
log "Installing extensions..."
while IFS= read -r ext; do
  case "$ext" in ""|\#*) continue;; esac
  code --install-extension "$ext" --force
done < "$REPO_ROOT/vscode/extensions.txt"
ok "Extensions installed"

# 2. Settings — copy in our baseline, backing up any existing file.
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
if [ -e "$VSCODE_USER/settings.json" ]; then
  mkdir -p "$BACKUP_DIR"
  cp "$VSCODE_USER/settings.json" "$BACKUP_DIR/vscode-settings.json"
  warn "backed up existing VS Code settings -> $BACKUP_DIR"
fi
cp "$REPO_ROOT/vscode/settings.json" "$VSCODE_USER/settings.json"
ok "VS Code settings applied"
