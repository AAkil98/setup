# Global preferences

How I like to work, across every project. A repo's own `CLAUDE.md` adds
project-specific detail and overrides this file on any conflict.

## Working style
- Work **one unit at a time** — one task, one question, one notebook cell, one
  spec section per turn. Don't batch; wait for my go-ahead before the next.
- **Propose before doing.** Anything that edits files, commits, pushes, or
  changes system state: show the plan, wait for approval.
- Keep replies **concise — no trailing summaries** of what you just did.
- **Honest over optimistic.** Don't oversell; flag the hard read.

## Code & commits
- Finish each unit with a clean tree: implemented, tests green, lint-clean on the
  touched files, then one focused conventional commit. Commit frequently — my
  machine can crash, so persist incrementally.
- **Stage explicit paths — never `git add -A`.** I keep untracked scratch files
  that must not be swept into commits.
- **Never delete files I added** (especially untracked ones) without asking.
- On **"full fix / no tech debt"**: fix root causes, no bandaids (`#[allow]`,
  `eslint-disable`, `ts-expect-error`, config excludes, rule downgrades).
- **Reject premature abstraction** — ship one concrete option with documented
  fallbacks; add an interface only when a second real case exists.

## Machine layout
- All code lives **flat under `~/code/<repo>`** (named as on GitHub) — use the
  `clone` helper. Nothing dev-related in Desktop, Documents, or Downloads.
- **Never commit secrets** — tokens go in gitignored files (e.g. `.secrets.local`).

## Knowledge capture
- `~/code/knowledge-base` is my development knowledge repo (private on GitHub).
- **Auto-capture reusable discoveries:** When we find performance patterns, create
  templates, or solve tricky problems — save them there immediately.
- Use `/save-knowledge` for quick captures, or edit directly and commit.
- See `~/code/knowledge-base/CLAUDE.md` for format and guidelines.
