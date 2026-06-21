# Global skills

User-level Agent Skills, symlinked to `~/.claude/skills/` by
`scripts/08-claude-code.sh`. Each skill is its own folder with a `SKILL.md`;
Claude loads it **on demand** when the description matches the task — so it costs
no always-on context (unlike `CLAUDE.md`).

```
skills/
└── <skill-name>/
    └── SKILL.md
```

`SKILL.md` format:

```markdown
---
name: <skill-name>
description: When to use this skill (this line is what Claude matches on)
---

<the procedure / instructions; can reference other files in the folder>
```

Good candidates (from recurring per-project workflows): incremental spec writing,
notebook cell-by-cell, vertical-slice delivery, new-`uv`-project scaffolding.

Public repo — keep skills free of secrets and personal info.
