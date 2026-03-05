# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This directory (`/opt/clones/github/jalanb/bashrcs/jab/src/bash`) contains the core bash functionality for an extensive personal shell configuration system. This is part of a larger "extended bashrc" project that transforms a simple `~/.bashrc` into a comprehensive interactive shell environment with thousands of custom functions and shortcuts.

## Architecture

### Startup Flow
The bash initialization follows this cascade:
1. `~/.bashrc` → `~/jab/__init__.sh` 
2. `__init__.sh` sources external projects (cde, whyp, ackvim) and `src/bash/__init__.sh`
3. `src/bash/__init__.sh` sources core modules and calls `keys_read`
4. `keys_read` regenerates and sources the keyboard shortcuts system

### Core Modules
- **`__init__.sh`** - Main orchestrator that sources all bash modules
- **`functons.sh`** - Primary function library (1500+ lines of utilities)
- **`crayons.sh`** - Color output system (generates `crayons.sh.sh` with color functions)
- **`git/`** - Comprehensive git workflow system (see `git/CLAUDE.md`)
- **`keyboard/`** - Ultra-short command aliases (see `keyboard/CLAUDE.md`)
- **`keys.sh`** - Manages the keyboard shortcut system

### Key Design Principles
- **Everything is sourced, not executed** - Functions extend the interactive shell
- **Progressive abbreviation** - Frequently used commands get shorter names
- **Auto-regeneration** - Keyboard shortcuts are dynamically compiled at startup
- **Git integration** - Special branch management for keyboard shortcuts

## Development Commands

### Testing Python Code
```bash
# Run all tests with tox
tox

# Run specific test environments
tox -e tests    # Run pytest
tox -e lints    # Run linting (black, flake8, mypy)

# Run pytest directly (when in venv)
py.test --doctest-modules --doctest-glob="*.test" --doctest-glob="*.tests" src/python
```

### Linting and Code Quality
```bash
# Run all linting
tox -e lints

# Individual tools
black --check src/python
flake8 src/python
mypy --ignore-missing-imports --install-types --non-interactive src/python
```

### Keyboard System Management
```bash
.k                          # Reload all keyboard functions
keys_vim [letters]          # Edit keyboard files, auto-reloads
push_keys                   # Commit and push keyboard changes
push_changed_keys           # Auto-detect and push if needed
```

### Git Workflow (via included git functions)
```bash
gsi        # Interactive git status
gi "msg"   # Smart git commit
gff        # Comprehensive fetch/pull/status
```

## Key Dependencies

### External Tools Required
- Standard Unix tools: `grep`, `awk`, `sed`, `find`
- Python 3.13+ (configured in pyproject.toml)
- Git with advanced features
- `vim`/`MacVim` for editing
- `bat` for enhanced file display
- `tree` for directory visualization
- `tox` for Python testing

### Helper Projects (External)
- **cde** - Enhanced `cd` with directory prediction
- **whyp** - Enhanced `type` command  
- **ackvim** - Find files with ack, open in vim
- **pysyte** - Python utilities supporting the bash functions

## Architecture Patterns

### Function Organization
- **Single-purpose modules**: Each `.sh` file has a focused responsibility
- **Hierarchical sourcing**: `__init__.sh` files orchestrate module loading
- **Dynamic generation**: Some files (like `keyboard/__init__.sh`) are auto-generated
- **Error handling**: Functions use `show_error`, `show_command` for consistent UX

### Color System
The `crayons.sh` system provides:
- `show_command` - Display commands before execution
- `show_error`/`show_fail` - Error messaging
- `red`, `green`, `blue`, etc. - Direct color output
- Auto-generated color functions in `crayons.sh.sh`

### Keyboard Shortcuts
Ultra-short aliases organized alphabetically:
- `a.sh` through `z.sh` - Letter-based functions
- `1.sh`, `2.sh`, `3.sh` - Numeric shortcuts  
- Functions follow pattern: `x`, `xx`, `xxx` (increasing verbosity)
- Auto-commits to separate `keyboard` git branch

## Integration Points

### Critical $HOME Integration
This directory is not just a configuration - it IS the active shell environment. Key files are directly linked from `$HOME`:

**Active Function Files:**
- `~/git.sh` → `~/bash/git/functons.sh` (1500+ git functions)
- `~/prompt.sh` → `~/bash/prompt.sh` (custom prompt system)
- `~/crayons.sh` → `~/bash/crayons.sh` (color functions)
- `~/crayons.sh.sh` → `~/bash/crayons.sh.sh` (generated color output)

**Core Directories:**
- `~/bash` → `~/jab/src/bash` (THIS directory - all bash functions)
- `~/keys` → `~/jab/src/bash/keyboard/` (ultra-short aliases)
- `~/python` → `~/jab/src/python` (supporting Python utilities)

**Minimal Environment:**
- `~/.minimal` → `~/bash/bashrc_minimal` (lightweight startup option)

**IMPORTANT:** Changes to files in this directory immediately affect the user's active shell environment. Functions defined here are live in the current shell and available as commands.

## Common Workflows

### Adding New Functions
1. Add to appropriate module (e.g., `functons.sh` for general utilities)
2. For shortcuts, add to relevant `keyboard/[letter].sh` file
3. Use `.k` to reload keyboard functions
4. Test function interactively

### Modifying Git Functions
1. Edit `git/functons.sh` or related git files
2. Source the git module: `. ~/bash/git/__init__.sh`
3. Test git workflow functions

### Python Development
1. Activate the venv: `source .venv/bin/activate` (auto-activated on startup)
2. Run tests: `tox` or `py.test`
3. Lint code: `tox -e lints`

This system represents decades of shell customization focused on maximum efficiency and minimal keystrokes for common development tasks.