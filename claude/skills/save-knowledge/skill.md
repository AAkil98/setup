---
name: save-knowledge
description: Capture knowledge from the current session to ~/code/knowledge-base
---

# Save Knowledge

Capture reusable knowledge from the current conversation to the personal knowledge
base at `~/code/knowledge-base`.

## Usage

```bash
# Quick save with category and title
/save-knowledge performance "PyTorch MPS batch size optimization"
/save-knowledge recipe "Docker Compose for ML stack"

# Auto-categorize based on context
/save-knowledge "Fixing APFS snapshot issues"

# Save with explicit filename
/save-knowledge performance "postgres-tuning-m-series.md"
```

## Arguments

- `<category>` (optional): One of `performance`, `recipe`, `machine`, or auto-detect
- `<title>`: Topic or filename (you'll generate a slug if needed)

## What You Do

1. **Extract the key knowledge** from recent conversation turns:
   - Problem/context
   - Solution (code, command, or config)
   - Why it works
   - When to use/avoid

2. **Determine the file location:**
   - `performance/` — optimization patterns, debugging notes, tuning guides
   - `recipes/` — reusable code templates, configs, docker-compose files
   - `machines/` — hardware benchmarks, specs

3. **Write the file** using the format in `~/code/knowledge-base/CLAUDE.md`:
   - Concise, example-first
   - Include context (hardware, OS, versions)
   - Cross-link related notes if applicable

4. **Commit immediately:**
   ```bash
   cd ~/code/knowledge-base
   git add <new-file>
   git commit -m "Add <topic> to <category>"
   ```

5. **Confirm** with a one-line summary of what was saved and where.

## When to Refuse

- If the knowledge is too specific to the current task (not reusable)
- If it's already documented (check first with grep)
- If the user just wants to remember something (use memory instead)

## Examples

**User:** `/save-knowledge performance "NumPy on M4 Pro"`

**You:**
1. Extract the NumPy optimization patterns we just discussed
2. Create `~/code/knowledge-base/performance/numpy-m-series-optimization.md`
3. Include the threading config, BLAS settings, and benchmark results
4. Commit: `"Add NumPy optimization guide for M-series chips"`
5. Reply: "Saved NumPy M-series optimization to performance/numpy-m-series-optimization.md"

---

**User:** `/save-knowledge recipe "FastAPI + Postgres"`

**You:**
1. Extract the docker-compose setup and FastAPI config we created
2. Create `~/code/knowledge-base/recipes/fastapi-postgres-docker.yml` and a README
3. Include connection settings, migrations setup, env vars
4. Commit: `"Add FastAPI + Postgres Docker Compose template"`
5. Reply: "Saved FastAPI + Postgres stack to recipes/fastapi-postgres-docker/"

---

**Note:** Always check `~/code/knowledge-base/CLAUDE.md` for the current format
guidelines before writing.
