# Review: Making bashrcs User-Agnostic

**Date Started**: 2025-10-07
**Goal**: Make `/opt/clones/github/jalanb/bashrcs` work for user `alan`, not just `jab`

## Problem Statement

The bashrcs project has hardcoded "jab" references throughout. Need to:
1. Support new user `alan` on this machine
2. Make it work for arbitrary usernames (use `$USER` or clone dir name)
3. Keep legitimate "jab" references (GitHub username `jalanb`, etc.)

## Progress So Far

### ✅ Completed: `home/.link` Refactoring

File: `/opt/clones/github/jalanb/bashrcs/jab/home/.link`

**What we did**:
- Replaced hardcoded `~/jab/` with dynamic `$HOME_CLONE` variable
- Added `get_git_dir()` function to find git repo root
- Made `renew_clone_link()` accept optional parameter to override link name
  - Example: `.link alan` creates `~/alan` → repo (instead of `~/jab`)
- Lines 78-79: Uses `basename` of clone dir by default, but `$1` overrides
- Line 86: Now correctly links `$clone_dir` (repo root), not `.git` dir

**Key improvement**: Can now run from either `jab` or `alan` clone and it adapts!

### 📊 Scope Identified

Found **185 hardcoded path references** across **44 shell files**:
- `~/jab/`
- `$HOME/jab/`
- `/Users/jab/jab/`

**Critical files needing fixes**:
1. `home/bashrc` - ~12 occurrences (lines 4, 6-7, 46, 49, 91-95, 105-108, 112, 150)
2. `__init__.sh` - 7 occurrences (lines 35, 37, 49-50, 52, 58)
3. `environ.d/jab.sh` - 2 occurrences (lines 41-42)
4. `src/bash/` files - ~30 occurrences across multiple files
5. `oses/` scripts - ~10 occurrences (may be obsolete legacy files)
6. `bin/` scripts - ~5 occurrences (need case-by-case review)

## Next Steps

### 1. Build Smart Categorization Tool

**Proposed**: Interactive script `~/tmp/categorize_jab_refs.sh`

**Categories to separate**:
- **CRITICAL**: Path references that must use `$HOME_CLONE` or similar variable
- **KEEP**: GitHub username `jalanb`, repo names, etc.
- **CONTEXT**: Comments, documentation (review case-by-case)
- **FILENAME**: Files named `jab.sh`, `jab.vim` (decide per-file)
- **VARIABLE**: Local variables like `jab_venv`, `jab_` prefix (probably keep)

**Interactive approach** (your suggestion):
- Show each "jab" reference with context
- Ask "Yes/No/Skip" - should this change?
- Learn patterns from answers
- Generate sed script or edit list

### 2. Systematic Replacement Strategy

**Phase A - Core initialization chain**:
```
home/bashrc → __init__.sh → environ.d/__init__.sh → environ.d/jab.sh
```
These must work first or nothing else loads.

**Phase B - Source bash helpers**:
```
src/bash/__init__.sh, src/bash/aliases.sh, src/bash/functons.sh, etc.
```

**Phase C - Legacy/optional**:
```
oses/* scripts (may be old), work/__init__.sh (optional)
```

### 3. Testing Plan

For each phase:
1. Make changes in `jab` clone
2. Test as user `jab`: `source ~/.bashrc` still works
3. Run `.link alan` from `alan` clone
4. Test as user `alan`: `source ~/.bashrc` works
5. Commit when both users work

## Design Decisions Needed

### Q1: Variable naming convention?
- `$HOME_CLONE` (current in `.link`)
- `$BASHRC_ROOT` or `$JAB_ROOT`?
- Should this be exported for all scripts to use?

### Q2: environ.d/jab.sh filename?
- Keep as `jab.sh` (it's about "jab's utilities")
- Rename to `utils.sh` or `core.sh`?

### Q3: How to handle `oses/jab/` directory?
- That's literally OS setup for machines named "jab"
- Probably keep as-is (machine-specific, not user-specific)

## Reference Search Examples

**Pattern**: `\$HOME/jab/|~/jab/|/Users/jab/jab/`

**Sample problematic lines**:
```bash
# home/bashrc:4
local jab_=$HOME/jab

# __init__.sh:35
. ~/jab/environ.d/__init__.sh optional

# environ.d/jab.sh:41-42
[[ -d ~/jab ]] || echo ~/jab is not a directory >&2
[[ -d ~/jab ]] || return 1
```

## Files for Tomorrow

**Working directory**: `/opt/clones/github/jalanb/bashrcs/jab/`

**Key files**:
- `home/.link` - ✅ Done
- `home/bashrc` - TODO
- `__init__.sh` - TODO
- `environ.d/jab.sh` - TODO
- `src/bash/*.sh` - TODO (~10 files)

**Temp files created**:
- `~/tmp/jab_search_categories.md` - Category definitions
- `~/tmp/review-jab-draft.md` - This file

## Command Snippets for Tomorrow

```bash
# Find all hardcoded jab paths
rg '\$HOME/jab/|~/jab/|/Users/jab/jab/' /opt/clones/github/jalanb/bashrcs/jab/ -g '*.sh'

# Count by file
rg '\$HOME/jab/|~/jab/|/Users/jab/jab/' /opt/clones/github/jalanb/bashrcs/jab/ -g '*.sh' --count

# Show with context
rg '\$HOME/jab/|~/jab/|/Users/jab/jab/' /opt/clones/github/jalanb/bashrcs/jab/ -g '*.sh' -C 2

# Test .link with override
cd /opt/clones/github/jalanb/bashrcs/alan/home
./.link alan  # Should create ~/alan -> repo
```

## Session Notes

- User prefers `bat` over `cat` (`/opt/homebrew/bin/bat`)
- User prefers `~/tmp` over `/tmp`
- User likes interactive tools with Yes/No prompts
- Bedtime approaching - good stopping point after `.link` success
