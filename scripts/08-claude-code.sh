#!/usr/bin/env bash
# Step 8 — Claude Code: CLI, settings, plugins, and MCP servers.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

log "Step 8: Claude Code"

# 1. Install the Claude Code CLI (native installer -> ~/.local/bin/claude).
if have claude; then
  ok "Claude Code already installed ($(claude --version 2>/dev/null))"
else
  log "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
fi

if ! have claude; then
  warn "claude isn't on PATH yet — open a new terminal and run: ./install.sh 8"
  exit 0
fi

# 2. Settings (model, theme, effort, enabled plugins) — drop in our baseline.
mkdir -p "$HOME/.claude"
if [ -e "$HOME/.claude/settings.json" ]; then
  mkdir -p "$BACKUP_DIR"
  cp "$HOME/.claude/settings.json" "$BACKUP_DIR/claude-settings.json"
  warn "backed up existing Claude settings -> $BACKUP_DIR"
fi
cp "$REPO_ROOT/claude/settings.json" "$HOME/.claude/settings.json"
ok "Claude settings applied"

# 3. Plugins — needs you to have logged in to Claude at least once.
log "Registering the official marketplace + your plugins..."
claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 \
  || warn "marketplace add failed (run 'claude' once to log in, then re-run)."

# Plugin list comes from claude/settings.json — single source of truth.
if have jq; then
  plugins=$(jq -r '.enabledPlugins | keys[]' "$REPO_ROOT/claude/settings.json")
else
  plugins="rust-analyzer-lsp@claude-plugins-official vercel@claude-plugins-official
pyright-lsp@claude-plugins-official mcp-server-dev@claude-plugins-official
langfuse-observability@claude-plugins-official qdrant-skills@claude-plugins-official
huggingface-skills@claude-plugins-official pydantic-ai@claude-plugins-official"
fi
for p in $plugins; do
  if claude plugin install "$p" >/dev/null 2>&1; then
    ok "installed plugin: ${p%@*}"
  else
    warn "could not install ${p%@*} — try: claude plugin install $p"
  fi
done

# 4. MCP servers. Tokens come from .secrets.local (gitignored) — never the repo.
[ -f "$REPO_ROOT/.secrets.local" ] && source "$REPO_ROOT/.secrets.local"
if [ -n "${SANITY_MCP_TOKEN:-}" ]; then
  log "Adding Sanity MCP server (user scope)..."
  if claude mcp add --scope user --transport http Sanity https://mcp.sanity.io \
       --header "Authorization: Bearer ${SANITY_MCP_TOKEN}" >/dev/null 2>&1; then
    ok "Sanity MCP added"
  else
    warn "Sanity MCP add failed — check the token / run the command manually."
  fi
else
  warn "SANITY_MCP_TOKEN not set — skipping the Sanity MCP server."
  warn "Add it to .secrets.local (see .secrets.local.example), then: ./install.sh 8"
fi

ok "Claude Code configured. Run 'claude' to start."
