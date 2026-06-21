---
name: index-knowledge
description: Rebuild the README.md index for ~/code/knowledge-base
---

# Index Knowledge

Scan `~/code/knowledge-base` and rebuild the `README.md` index to reflect current
content. Run this after adding files manually or when the index is stale.

## Usage

```bash
/index-knowledge

# With explicit commit
/index-knowledge --commit
```

## Arguments

- `--commit` (optional): Commit the updated README after rebuilding

## What You Do

1. **Scan each category directory:**
   ```bash
   cd ~/code/knowledge-base
   find machines/ performance/ recipes/ -type f -name "*.md" | sort
   ```

2. **Extract metadata** from each file:
   - First `# heading` → title
   - First paragraph or `**Context:**` line → summary (1 line max)

3. **Rebuild README sections:**

   ```markdown
   ### 📊 [Machines](machines/)
   - [M4 Pro MacBook Pro (2024-06-21)](machines/m4-pro-2024-06-21.md) - Current machine
   
   ### ⚡ [Performance](performance/)
   - [NumPy M-series optimization](performance/numpy-m-series-optimization.md) - Threading and BLAS config
   - [PyTorch MPS tuning](performance/pytorch-mps-tuning.md) - Batch sizes for Apple Silicon
   
   ### 📝 [Recipes](recipes/)
   - [ML Docker Stack](recipes/ml-docker-stack.yml) - Postgres, Redis, Jupyter
   - [FastAPI + Postgres](recipes/fastapi-postgres-docker/) - Production-ready API stack
   ```

4. **Update README.md** in place, preserving the header and "Quick Find" section

5. **If `--commit` flag:**
   ```bash
   git add README.md
   git commit -m "Update knowledge base index"
   ```

6. **Confirm** how many entries were indexed per category

## Example

**User:** `/index-knowledge --commit`

**You:**
1. Scan all `.md` files in `machines/`, `performance/`, `recipes/`
2. Extract titles and one-line summaries
3. Rebuild the category sections in `README.md`
4. Run:
   ```bash
   cd ~/code/knowledge-base
   git add README.md
   git commit -m "Update knowledge base index"
   ```
5. Reply:
   ```
   Indexed 1 machine, 3 performance notes, 2 recipes.
   Committed to knowledge-base at <commit-hash>.
   ```

---

**Note:** Keep index entries under ~120 chars total so they scan quickly.
Format: `- [Title](path/to/file.md) - One-line summary`
