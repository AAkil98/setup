# Global subagents (roles)

User-level subagents, symlinked to `~/.claude/agents/` by
`scripts/08-claude-code.sh`. Each is a single `<name>.md` with a persona plus its
own tools/model; Claude delegates to one when the task matches its `description`.

`<name>.md` format:

```markdown
---
name: <role-name>
description: When to hand work to this role
tools: Read, Grep, Bash      # optional — omit to inherit all tools
model: sonnet                # optional
---

<the role's system prompt>
```

Good candidates: a spec/design reviewer, an ML-experiment reviewer.

Public repo — keep agents free of secrets and personal info.
