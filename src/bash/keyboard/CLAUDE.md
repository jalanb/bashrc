# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the "keyboard" directory within the `jab` bashrc project - a collection of ultra-short command aliases organized alphabetically. Each letter gets its own `.sh` file (a.sh, b.sh, c.sh, etc.) containing 1-3 character command shortcuts.

## Architecture

### File Structure
- **Individual letter files**: `a.sh`, `b.sh`, `c.sh`, etc. - Each contains functions starting with that letter
- **Numeric files**: `1.sh`, `2.sh`, `3.sh` - Special numeric shortcuts
- **Special files**: `puncts.sh` - Punctuation-based shortcuts
- **Generated file**: `__init__.sh` - Auto-generated concatenation of all keyboard scripts

### Naming Convention
Functions follow a strict pattern:
- `x` - Primary single-letter command
- `xx` - Two-letter variant (usually more verbose)
- `xxx` - Three-letter variant (often opens config files)
- Additional functions may exist but should start with the same letter

Examples from `v.sh`:
- `v` - Opens MacVim with remote tabs
- `vv` - Command-line vim  
- `vvv` - Opens ~/.vimrc

### Integration Flow
The keyboard system integrates with the bash startup sequence:

1. `~/.bashrc` sources `~/jab/__init__.sh`
2. `~/jab/__init__.sh` sources `~/jab/src/bash/__init__.sh`
3. `~/jab/src/bash/__init__.sh` sources `~/jab/src/bash/keys.sh`
4. `keys.sh` calls `keys_read()` which:
   - Calls `keys_write()` to regenerate `__init__.sh`
   - Sources the generated `__init__.sh`

### Auto-Generation Process
The `keys_write()` function in `keys.sh` automatically:
- Concatenates all `*.sh` files in the keyboard directory
- Strips shebang lines (`#! `) from individual files
- Creates a unified `__init__.sh` with all keyboard functions

## Development Commands

### Key Management Functions (from keys.sh)
- `.k` - Reload keyboard functions (sources keys.sh and calls keys_read)
- `keys_read()` - Regenerate and source keyboard functions
- `keys_vim [letters]` - Edit keyboard files in vim, auto-reloads after
- `push_keys()` - Git workflow for committing keyboard changes
- `push_changed_keys()` - Auto-detects changes and pushes if needed

### Git Integration
The keyboard directory has special git handling:
- Changes are committed to a separate "keyboard" branch
- Each file gets its own commit named after the letter (e.g., "v" for v.sh changes)
- `commit_key_file()` either creates new commits or amends existing ones
- The system tracks when keyboard files change via MD5 hashing

## Working with Keyboard Files

### Adding New Functions
1. Edit the appropriate letter file (e.g., `vim ~/keys/g.sh` for git functions)
2. Follow naming conventions: `g`, `gg`, `ggg`, etc.
3. Functions should be sourced, not executed
4. Use `.k` to reload after changes

### Common Patterns
- Files often source related external scripts (e.g., `a.sh` sources ackvim.sh)
- Many functions are wrappers around common tools (git, grep, ack, vim)
- Directory navigation and file manipulation are common themes
- Color output functions are frequently used

### Integration Points
- `~/jalanb/avs/__main__/ackvim.sh` - Provides `a`, `aa`, `aaa` functions
- `~/keys/m.sh` - Sourced by `v.sh` for shared functions
- Helper projects: cde, whyp, ackvim, pysyte

## File Organization Philosophy

This directory embodies the principle that "any command used more than once should be a function, and any function used frequently should have the shortest possible name." It's a decades-long accumulation of shortcuts for a power user's most common operations.

The keyboard system is designed for speed and muscle memory - allowing complex operations to be triggered with minimal keystrokes.