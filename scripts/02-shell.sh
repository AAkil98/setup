#!/usr/bin/env bash
# Step 2 — oh-my-zsh, the syntax-highlighting plugin, and your dotfiles.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

log "Step 2: oh-my-zsh + plugins + dotfiles"

# 1. oh-my-zsh — unattended install (don't switch shell or launch zsh now,
#    and DON'T let it overwrite our .zshrc; we symlink our own below).
if [ -d "$HOME/.oh-my-zsh" ]; then
  ok "oh-my-zsh already installed"
else
  log "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 2. zsh-syntax-highlighting (the other plugins ship inside oh-my-zsh).
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  ok "zsh-syntax-highlighting already installed"
else
  log "Installing zsh-syntax-highlighting..."
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# 3. Symlink dotfiles into $HOME (existing files are backed up first).
link_file "$REPO_ROOT/dotfiles/.zshrc"            "$HOME/.zshrc"
link_file "$REPO_ROOT/dotfiles/.aliases"          "$HOME/.aliases"
link_file "$REPO_ROOT/dotfiles/.gitconfig"        "$HOME/.gitconfig"
link_file "$REPO_ROOT/dotfiles/.gitignore_global" "$HOME/.gitignore_global"

ok "Shell ready. Open a new terminal (or run 'exec zsh') to load it."
