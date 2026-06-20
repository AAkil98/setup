# 💻 macOS Setup

My personal setup for a fresh MacBook. Clone it on day one, run one command, and
get back a familiar data-science environment — shell, languages, editor, the lot.

Inspired by [lewagon/data-setup](https://github.com/lewagon/data-setup), trimmed
down to **just macOS** and automated end-to-end.

## What it installs

| Area | What you get |
|------|--------------|
| **Homebrew** | git, gh, pyenv, direnv, tmux, ripgrep, vim, jq… + VS Code, Docker, Chrome (`Brewfile`) |
| **Shell** | zsh + oh-my-zsh (`robbyrussell` theme, Le Wagon plugins) and my dotfiles |
| **Python** | pyenv → Python 3.12.9 → a `forge-ml` virtualenv with the full data-science stack |
| **Node** | nvm → Node 24.11.1 (default) |
| **VS Code** | my extensions + a baseline `settings.json` |
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
| 2 | `02-shell.sh` | oh-my-zsh + `zsh-syntax-highlighting`, symlinks dotfiles |
| 3 | `03-github.sh` | generates an SSH key and logs in with `gh` *(interactive)* |
| 4 | `04-languages.sh` | pyenv + Python 3.12.9 + `forge-ml` venv, nvm + Node 24.11.1 |
| 5 | `05-python-packages.sh` | `pip install -r requirements.txt` into `forge-ml` |
| 6 | `06-vscode.sh` | installs extensions, drops in `settings.json` |
| 7 | `07-macos.sh` | applies macOS `defaults` tweaks |

## Customizing

Everything is plain text — edit, commit, and your next machine inherits it:

- **Apps / CLI tools** → `Brewfile`
- **Python packages** → `requirements.txt`
- **VS Code extensions** → `vscode/extensions.txt`
- **Shell / git config** → `dotfiles/`
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
