---
name: search-knowledge
description: Search across ~/code/knowledge-base for relevant knowledge
---

# Search Knowledge

Search the personal knowledge base at `~/code/knowledge-base` for relevant notes,
recipes, and benchmarks.

## Usage

```bash
# Simple search
/search-knowledge "docker"
/search-knowledge "performance optimization"

# Search specific category
/search-knowledge "pytorch" --category performance
/search-knowledge "compose" --category recipes

# Search with context (include file paths)
/search-knowledge "M4 Pro" --with-context
```

## Arguments

- `<query>`: Search term or phrase
- `--category <name>` (optional): Limit to `performance`, `recipes`, or `machines`
- `--with-context` (optional): Show surrounding lines and file paths

## What You Do

1. **Search the knowledge base:**
   ```bash
   cd ~/code/knowledge-base
   
   # Basic search
   grep -r "<query>" .
   
   # Category-specific
   grep -r "<query>" <category>/
   
   # With context (3 lines before/after)
   grep -r -B3 -A3 "<query>" .
   ```

2. **Present results** grouped by category:
   ```
   Found in performance/:
   - numpy-m-series-optimization.md: "...BLAS threading config..."
   - pytorch-mps-tuning.md: "...batch size affects performance..."
   
   Found in recipes/:
   - ml-docker-stack.yml: "...docker-compose for ML..."
   ```

3. **If multiple matches**, show snippets with enough context to differentiate

4. **If no matches**, suggest:
   - Similar terms that do exist
   - Offer to save new knowledge if this is a gap

## Examples

**User:** `/search-knowledge "docker compose"`

**You:**
```bash
cd ~/code/knowledge-base
grep -r "docker compose" .
```

Then show:
```
Found 2 matches:

recipes/ml-docker-stack.yml:
  Docker Compose setup for ML development with Postgres, Redis, and Jupyter

recipes/fastapi-postgres-docker/:
  FastAPI + Postgres + Nginx production stack
```

---

**User:** `/search-knowledge "batch size" --category performance`

**You:**
```bash
cd ~/code/knowledge-base
grep -r "batch size" performance/
```

Then show the relevant sections with file:line references.

---

**Note:** Use `ripgrep` (`rg`) if available for faster, prettier output:
```bash
rg "<query>" ~/code/knowledge-base --heading --line-number
```
