#!/usr/bin/env bash
# install.sh — run the whole macOS setup, or just the steps you name.
#
#   ./install.sh            run every step, in order
#   ./install.sh 1 2 4      run only steps 1, 2 and 4
#   ./install.sh --list     list the steps and exit
#
set -euo pipefail
cd "$(dirname "$0")"
source "scripts/lib.sh"

STEPS=(
  "01-homebrew.sh:Command Line Tools, Homebrew & Brewfile apps"
  "02-shell.sh:oh-my-zsh, plugins & dotfiles"
  "03-github.sh:SSH key & GitHub login (interactive)"
  "04-languages.sh:Python (pyenv/forge-ml) & Node (nvm)"
  "05-python-packages.sh:Data-science Python packages"
  "06-vscode.sh:VS Code extensions & settings"
  "07-macos.sh:macOS system preferences"
)

usage() {
  echo "Usage: ./install.sh [step-numbers...]"
  echo
  echo "With no arguments, runs every step in order. Steps:"
  local i=1
  for s in "${STEPS[@]}"; do
    printf "  %d. %s\n" "$i" "${s#*:}"
    i=$((i + 1))
  done
}

case "${1:-}" in
  -h | --help | --list) usage; exit 0 ;;
esac

# Which steps?
if [ "$#" -gt 0 ]; then
  selected=("$@")
else
  selected=(1 2 3 4 5 6 7)
fi

echo
log "macOS setup — about to run:"
for n in "${selected[@]}"; do
  idx=$((n - 1))
  [ "$idx" -ge 0 ] && [ "$idx" -lt "${#STEPS[@]}" ] || { warn "no step $n"; continue; }
  printf "   %s. %s\n" "$n" "${STEPS[$idx]#*:}"
done
echo
printf "Proceed? [y/N] "
read -r reply
case "$reply" in [yY]*) ;; *) echo "Aborted."; exit 1 ;; esac

for n in "${selected[@]}"; do
  idx=$((n - 1))
  [ "$idx" -ge 0 ] && [ "$idx" -lt "${#STEPS[@]}" ] || continue
  echo
  log "────────────────────────────────────────────────────"
  bash "scripts/${STEPS[$idx]%%:*}"
done

echo
ok "All selected steps complete."
log "Restart your terminal (or run 'exec zsh') and you're ready. 🎉"
