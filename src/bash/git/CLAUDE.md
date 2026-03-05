# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Directory Overview

This directory contains a comprehensive collection of git-related bash functions that extend and enhance standard git commands. These functions are part of a larger bash configuration system and are designed to be sourced, not executed directly.

## Core Architecture

### Main Entry Points
- `__init__.sh` - Sources the main modules (completion.sh and functons.sh)
- `functons.sh` - Contains the primary git wrapper functions (1500+ lines)
- `completion.sh` - Provides bash completion for git commands
- `gsi.sh` - Interactive git status management system

### Key Design Patterns

**Function Naming Convention:**
- Single letter: `g` (git), `ga` (git add), `gb` (git branch), `gc` (git commit), etc.
- Two letters: `gl` (git log), `gp` (git push), `gs` (git status), etc.
- Three+ letters: `gaa` (git add all), `gdi` (git diff), `grr` (git pull rebase), etc.

**Common Function Structure:**
- Most functions use `show_command` before executing to display what will run
- Functions handle both directory and file arguments flexibly
- Error handling with informative messages via `show_error`
- Many functions support both quiet (`-q`) and verbose modes

## Essential Functions to Understand

### Core Git Operations
- `gi` - Smart git commit (takes message or opens editor)
- `ga` - Git add with validation and error messages
- `go` - Safe git checkout with stash protection
- `gp`/`gpf` - Git push with automatic upstream handling
- `grr` - Git pull with rebase

### Branch Management
- `gb` - Enhanced git branch with grep support
- `gob` - Create new branch from specified commit
- `gbd`/`gbD` - Safe branch deletion with confirmation
- `main_branch()` - Detects main branch (\_\_main\_\_, main, or master)

### Interactive Systems
- `gsi` - Interactive status management (add/restore/edit files)
- `gxi` - Base interactive system for git operations
- `gvi` - Vim-focused interactive git workflow

### Advanced Workflows
- `gff`/`gfff` - Comprehensive fetch/pull/status workflow
- `clone` - Enhanced git clone with automatic user config
- `git_stash_and` - Execute commands with automatic stash/unstash

## Common Development Tasks

### Working with Branches
```bash
# List branches matching pattern
gb pattern

# Create new branch from current
gob new-branch

# Switch to main branch and pull latest
gomr  # or gom && grr

# Clean up merged branches  
gbdd
```

### Interactive File Management
```bash
# Interactive status review
gsi

# Interactive add/commit workflow
ggi

# Interactive with vim integration
gvi
```

### Repository Maintenance
```bash
# Full fetch and update workflow
gff

# Clean and reset repository
clean_clone

# Comprehensive prune and cleanup
grupp
```

## Key Dependencies

### External Commands Required
- Standard git commands
- `bat` for file display
- `vim`/`MacVim` for editing
- `python` for path resolution
- `gh` for GitHub operations (hub.sh)

### Internal Dependencies
- `~/bash/crayons.sh` - Color output functions (`show_command`, `show_error`, etc.)
- `~/bash/arg_dirs.sh` - Directory argument handling
- `~/bash/keyboard/r.sh` - Keyboard shortcut functions
- Various utility functions like `python_realpath`, `readlink`, etc.

## Important Implementation Notes

### Safety Features
- Functions check for uncommitted changes before destructive operations
- Branch deletion requires confirmation (except for 'fred' branch)
- Automatic stashing/unstashing for operations requiring clean working tree
- Main branch protection in deletion operations

### Configuration Patterns
- Functions adapt to repository structure (detects main branch name)
- User email/name configuration set per repository in `clone` function
- Git aliases accessible via `gw` function

### Interactive Menu System
The `gxi` framework provides a consistent interactive interface:
- File-by-file review with diff display
- Single-key commands for common operations
- Search functionality within files
- Automatic staging and commit workflows

## Testing and Validation

These functions are extensively used in daily git workflows and include:
- Comprehensive error handling
- Dry-run capabilities where appropriate
- Verbose mode support for debugging
- Integration with external tools (bat, vim, gh)

When modifying these functions, test with various repository states (clean, dirty, during merge, during rebase) to ensure robustness.