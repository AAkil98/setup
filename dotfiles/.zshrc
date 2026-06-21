# ~/.zshrc — managed by your setup repo (github.com/AAkil98/setup)
# Cleaned for macOS: WSL/Windows-only lines removed.
# ---------------------------------------------------------------------------

# Homebrew. Puts brew + everything it installs on PATH.
if [ -x /opt/homebrew/bin/brew ]; then        # Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then          # Intel Macs
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Prompt is handled by starship (loaded at the bottom) — disable oh-my-zsh's theme.
ZSH_THEME=""

# oh-my-zsh plugins (Le Wagon set).
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search ssh-agent)

# Don't report Homebrew analytics.
export HOMEBREW_NO_ANALYTICS=1
# Retry dropped downloads (resilience on flaky networks).
export HOMEBREW_CURL_RETRIES=5

# Disable warning about insecure completion-dependent directories.
ZSH_DISABLE_COMPFIX=true

# Load oh-my-zsh.
source "$ZSH/oh-my-zsh.sh"
unalias rm 2>/dev/null    # no interactive rm by default (from common-aliases)
unalias lt 2>/dev/null    # keep `lt` free for localtunnel

# ---- Version managers -------------------------------------------------------

# rbenv (Ruby) — only loads if you've installed it.
type -a rbenv > /dev/null 2>&1 && eval "$(rbenv init - zsh)"

# pyenv (Python) + pyenv-virtualenv.
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if type -a pyenv > /dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init - 2> /dev/null)"
fi

# nvm (Node).
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto-run `nvm use` in a directory that has a .nvmrc file.
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"
    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null 2>&1 && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null 2>&1 && load-nvmrc

# Run project binstubs directly: `rails` instead of `bin/rails`, etc.
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# ---- Personal config --------------------------------------------------------

# Load personal aliases from ~/.aliases.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Terminal encoding.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Default editor (VS Code, wait for the window to close).
export EDITOR="code --wait"
export BUNDLER_EDITOR="code"

# Use ipdb as the default debugger for breakpoint().
export PYTHONBREAKPOINT=ipdb.set_trace

# direnv — auto-load .envrc files.
type -a direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"

# Preferred Claude model for Claude Code.
export ANTHROPIC_MODEL="claude-sonnet-4-5-20250929"

# pipx / user-installed binaries.
export PATH="$HOME/.local/bin:$PATH"

# bun.
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ---- Modern CLI tools -------------------------------------------------------

# zoxide — smarter cd (`z <dir>`; `zi` for interactive pick).
type -a zoxide > /dev/null 2>&1 && eval "$(zoxide init zsh)"

# fzf — fuzzy finder (Ctrl-R history, Ctrl-T files, Alt-C cd).
if type -a fzf > /dev/null 2>&1; then
  source <(fzf --zsh) 2>/dev/null
  type -a rg > /dev/null 2>&1 && export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a --multi"
fi

# bat — better cat (Catppuccin theme installed by scripts/02-shell.sh).
type -a bat > /dev/null 2>&1 && export BAT_THEME="Catppuccin Mocha"

# eza — better ls (needs a Nerd Font for --icons).
if type -a eza > /dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --git --group-directories-first'
  alias la='eza -la --icons --git --group-directories-first'
fi

# Starship prompt — must load after oh-my-zsh so it owns the prompt.
type -a starship > /dev/null 2>&1 && eval "$(starship init zsh)"
