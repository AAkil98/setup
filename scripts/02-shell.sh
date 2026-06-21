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
link_file "$REPO_ROOT/dotfiles/.editorconfig"     "$HOME/.editorconfig"

# starship prompt config.
mkdir -p "$HOME/.config"
link_file "$REPO_ROOT/dotfiles/starship.toml" "$HOME/.config/starship.toml"

# tmux config + plugin manager (tpm).
link_file "$REPO_ROOT/dotfiles/.tmux.conf" "$HOME/.tmux.conf"
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  ok "tpm already installed"
else
  log "Installing tmux plugin manager (tpm)..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 \
  || warn "tmux plugins will install on first launch (open tmux, press prefix + I)."

ok "Shell ready. Open a new terminal (or run 'exec zsh') to load it."
