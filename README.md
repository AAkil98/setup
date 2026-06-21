# 💻 macOS Setup

My personal setup for a fresh MacBook. Clone it on day one, run one command, and
get back a familiar data-science / **LLMOps + MLOps** environment — shell,
languages, editor, tooling, Claude Code, the lot.

## What it installs

| Area | What you get |
|------|--------------|
| **Homebrew** | git, gh, **uv**, pipx, pre-commit, dvc, kubectl, protobuf, yq, tmux, ripgrep… + VS Code, Docker, Chrome, **Ollama** (`Brewfile`) |
| **Shell** | zsh + oh-my-zsh (Le Wagon plugins) with a **starship** prompt (Catppuccin Mocha) + JetBrainsMono Nerd Font, tmux, **Ghostty** terminal, and my dotfiles |
| **Workflow** | SSH config (macOS keychain), global `.editorconfig`, gh aliases + **gh-dash** PR dashboard, Touch ID for `sudo` |
| **Modern CLI** | zoxide (`z`), fzf, git-delta, eza, bat — Catppuccin-themed |
| **Python (data)** | pyenv → Python 3.12.9 → a `forge-ml` virtualenv with the data-science stack (`requirements.txt`) |
| **Python (LLMOps/MLOps)** | same env, plus langchain/langgraph, langfuse, mcp/fastmcp, qdrant, mlflow, prefect, optuna, evidently, opentelemetry… (`requirements-llmops.txt`) + `poetry`/`commitizen` via pipx |
| **Node** | nvm → Node 24.11.1 (default) |
| **VS Code** | my extensions + `settings.json` themed **Catppuccin Mocha** (JetBrains Mono ligatures, Catppuccin icons, ErrorLens) |
| **Claude Code** | the CLI, my `settings.json` (opus / low effort / `dark-daltonized`), 8 plugins (`rust-analyzer-lsp`, `pyright-lsp`, `mcp-server-dev`, `langfuse-observability`, `qdrant-skills`, `huggingface-skills`, `pydantic-ai`, `vercel`), and MCP servers |
| **macOS** | sensible system tweaks (fast key repeat, show extensions, screenshots → ~/Screenshots…) |

## Quick start (on the new Mac)

1. **Open Terminal** and trigger the Command Line Tools install by running:
   ```bash
   git --version
   ```
   If a popup appears, finish it (this gives you `git`). Otherwise you're set.

2. **Clone this repo:**
   ```bash
   git clone https://github.com/AAkil98/setup.git ~/code/setup
   cd ~/code/setup
   ```

3. **Run it:**
   ```bash
   ./install.sh
   ```
   It lists the steps, asks for confirmation, then runs them in order.
   When it finishes, restart your terminal (`exec zsh`).

That's it. ☕ The full run takes ~20–40 min (compiling Python and installing
packages are the slow parts).

## Running individual steps

Each step is a standalone script in `scripts/` and is safe to re-run
(idempotent — existing files are backed up to `~/.setup-backups/…`).

```bash
./install.sh 6        # just VS Code
./install.sh 4 5      # languages, then Python packages
./install.sh --list   # show all steps
```

| # | Script | Does |
|---|--------|------|
| 1 | `01-homebrew.sh` | Command Line Tools, Homebrew, everything in the `Brewfile` |
| 2 | `02-shell.sh` | oh-my-zsh + `zsh-syntax-highlighting` + starship + tmux/tpm, symlinks dotfiles |
| 3 | `03-github.sh` | SSH key + `~/.ssh/config`, `gh` login, gh aliases + gh-dash *(interactive)* |
| 4 | `04-languages.sh` | pyenv + Python 3.12.9 + `forge-ml` venv, nvm + Node 24.11.1 |
| 5 | `05-python-packages.sh` | installs `requirements.txt` + `requirements-llmops.txt` into `forge-ml`, plus `poetry`/`commitizen` via pipx |
| 6 | `06-vscode.sh` | installs extensions, drops in `settings.json` |
| 7 | `07-macos.sh` | applies macOS `defaults` tweaks + Touch ID for `sudo` |
| 8 | `08-claude-code.sh` | installs Claude Code, applies settings, installs plugins, adds MCP servers |

## Secrets (MCP tokens)

Tokens never live in this repo. Step 8 reads them from `.secrets.local`, which is
gitignored:

```bash
cp .secrets.local.example .secrets.local   # then paste your token(s)
```

Set `SANITY_MCP_TOKEN` there and step 8 wires up the Sanity MCP server for you;
leave it blank to skip.

## Directory layout

All code lives under one root — nothing dev-related in `Desktop`, `Documents`, or
`Downloads`. Repos sit **flat** under `~/code`, named exactly as on GitHub:

```
~/code/
├── forge-ml/
├── tessera/
├── setup/        ← this repo
└── …
```

The `clone` helper (from `dotfiles/.aliases`) keeps it tidy automatically:

```bash
clone AAkil98/forge-ml   # → clones into ~/code/forge-ml and cds in
```

`z forge-ml` jumps back there anytime (zoxide).

## Customizing

Everything is plain text — edit, commit, and your next machine inherits it:

- **Apps / CLI tools** → `Brewfile`
- **Data-science packages** → `requirements.txt`
- **LLMOps / MLOps packages** → `requirements-llmops.txt`
- **VS Code extensions** → `vscode/extensions.txt`
- **Claude Code settings** → `claude/settings.json`
- **Shell / git / SSH / editor config** → `dotfiles/`
- **Prompt / tmux / terminal** → `dotfiles/starship.toml`, `dotfiles/.tmux.conf`, `dotfiles/ghostty/config`
- **gh-dash dashboard** → `dotfiles/gh-dash/config.yml`
- **macOS tweaks** → `scripts/07-macos.sh`

## Keeping it current (on the old machine)

Re-snapshot what you have before you switch, so the repo stays accurate:

```bash
# refresh the VS Code extension list
code --list-extensions > vscode/extensions.txt   # (then re-add the header comment)

# refresh installed Python packages in forge-ml
pyenv activate forge-ml && pip freeze > requirements.lock.txt
```

## Notes

- **Apple Silicon & Intel** are both handled (Homebrew path is detected).
- **Ruby/rbenv** is optional and skipped by default — see the hint at the end of
  step 4 if you need it.
- Replaced files are never deleted; they're backed up under
  `~/.setup-backups/<timestamp>/`.

---

### First time? Publish this repo so it's cloneable on the new Mac

From this folder on your **current** machine:

```bash
git add -A
git commit -m "Initial macOS setup"
gh repo create setup --public --source=. --push   # needs the gh CLI
```

Then the `git clone` step above will work on the MacBook.
