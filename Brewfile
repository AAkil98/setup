# Brewfile — declarative list of everything Homebrew should install.
# Run with:  brew bundle --file=Brewfile
#
# Anything you add here is installed/updated next time you run the command,
# which makes this the single source of truth for your apps & CLI tools.

# ---- CLI tools --------------------------------------------------------------
brew "git"                # version control
brew "git-lfs"            # large file storage (used by your .gitconfig filters)
brew "gh"                 # GitHub CLI — login + git credential helper
brew "pyenv"              # manage multiple Python versions
brew "pyenv-virtualenv"   # virtualenvs on top of pyenv (this builds forge-ml)
brew "direnv"             # auto-load per-project env vars from .envrc
brew "tmux"               # terminal multiplexer
brew "ripgrep"            # blazing-fast search (the `rg` command)
brew "vim"                # terminal editor
brew "wget"               # downloader
brew "jq"                 # command-line JSON processor
brew "tree"               # pretty directory trees

# pyenv build dependencies (needed to compile Python cleanly)
brew "openssl@3"
brew "readline"
brew "sqlite"
brew "xz"
brew "zlib"

# ---- GUI apps (casks) -------------------------------------------------------
cask "visual-studio-code" # your editor
cask "docker-desktop"     # Docker (Desktop app + `docker` CLI)
cask "google-chrome"      # browser

# ---- LLMOps / MLOps / DevOps (for mlops-projects & mada) ---------------------
brew "uv"                 # fast Python package/project manager (forge-ml uses it)
brew "pipx"               # isolated Python CLIs (installs poetry, commitizen)
brew "pre-commit"         # git hooks — used across your repos
brew "dvc"                # data version control (ChurnOps, forge-ml)
brew "yq"                 # YAML processor (compose / k8s manifests)
brew "protobuf"           # protoc — for grpclib/betterproto (wacp)
brew "kubernetes-cli"     # kubectl

cask "ollama"             # run local LLMs (aiweave's ollama provider)

# ---- Optional — uncomment anything you want ---------------------------------
# brew "poetry"           # also installed via pipx in step 5 (ChurnOps uses it)
# brew "k9s"              # Kubernetes TUI
# brew "helm"             # Kubernetes package manager
# brew "grpcurl"          # curl for gRPC services
# brew "redis"            # local Redis (or just run it via Docker)
# brew "awscli"           # AWS CLI (~/.aws is present)
# cask "google-cloud-sdk" # gcloud CLI
# cask "iterm2"           # a nicer terminal than Terminal.app
# cask "rectangle"        # keyboard window management
# cask "slack"
# cask "notion"
# cask "spotify"
# brew "pgcli"            # nicer Postgres CLI
# brew "postgresql@16"    # local Postgres server
# brew "ffmpeg"
