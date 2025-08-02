# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the source directory (`/opt/clones/github/jalanb/bashrcs/jab/src/`) for an extensive personal shell configuration system that transforms a simple `~/.bashrc` into a comprehensive interactive shell environment. The project follows the principle of "premature abbreviation is the root of all evil" by providing thousands of ultra-short bash functions and shortcuts for maximum development efficiency.

## Architecture 

### Project Structure
- **`bash/`** - Core bash functionality with 1500+ functions and ultra-short aliases
- **`python/`** - Supporting Python utilities that integrate with bash functions  
- **`applescript/`** - macOS automation scripts
- **Integration directories** - `environ.d/`, `home/`, `etc/` for environment setup
- **Helper projects** - Links to external projects like `cde`, `whyp`, `ackvim`

### Critical Integration Points
This is not just configuration - it IS the active shell environment. Key directories are directly linked from `$HOME`:

- `~/bash` → `~/jab/src/bash` (all bash functions)
- `~/python` → `~/jab/src/python` (Python utilities)
- `~/keys` → `~/jab/src/bash/keyboard/` (ultra-short aliases)
- Core function files like `~/git.sh`, `~/prompt.sh`, `~/crayons.sh` are live links

**CRITICAL:** Changes to files in this directory immediately affect the user's active shell.

### Startup Architecture
1. `~/.bashrc` → `~/jab/__init__.sh`
2. `__init__.sh` sources external projects and `src/bash/__init__.sh`
3. `bash/__init__.sh` sources core modules and calls `keys_read`
4. `keys_read` dynamically regenerates keyboard shortcuts system

## Development Commands

### Python Testing (Primary Method)
```bash
# Run all doctest-style tests
nosetests --with-doctest --doctest-extension=test

# Run from specific directories
nosetests --with-doctest --doctest-extension=test python/test/
nosetests --with-doctest --doctest-extension=test python/site/

# Individual test files
python -m doctest python/test/vim.test
python -m doctest python/site/todo.test

# Shell-based tests
bash python/test/test_first_num.sh
```

### Bash Function Management
```bash
.k                          # Reload all keyboard functions
keys_vim [letters]          # Edit keyboard files, auto-reloads  
push_keys                   # Commit and push keyboard changes
push_changed_keys           # Auto-detect and push if needed
```

### Git Workflow (Enhanced Functions)
```bash
gsi        # Interactive git status with enhanced display
gi "msg"   # Smart git commit with validation
gff        # Comprehensive fetch/pull/status across repositories
```

### Code Quality
```bash
# Python linting (uses setup.cfg configuration)
flake8

# Install development dependencies
pip install -r python/requirements.txt
```

## Key Dependencies

### Essential Tools
- **Python 3.7+** with packages: ipython, pudb, pprintpp, pysyte>=0.7.40
- **Git** with advanced workflow functions
- **vim/MacVim** for editing (deeply integrated)
- **Standard Unix tools**: grep, awk, sed, find, tree

### External Helper Projects
- **pysyte** - Foundational Python library (external dependency)
- **cde** - Enhanced `cd` with directory prediction  
- **whyp** - Enhanced `type` command
- **ackvim** - Find files with ack, open in vim

## Architecture Patterns

### Function Organization
- **Progressive abbreviation**: `x`, `xx`, `xxx` pattern (increasing verbosity)
- **Alphabetical shortcuts**: `a.sh` through `z.sh` for ultra-short commands
- **Auto-regeneration**: Keyboard shortcuts dynamically compiled at startup
- **Everything sourced**: Functions extend interactive shell, never executed standalone

### Color System (`bash/crayons.sh`)
- `show_command` - Display commands before execution
- `show_error`/`show_fail` - Consistent error messaging  
- Auto-generated color functions in `crayons.sh.sh`
- Supports custom prompt with git status and python environment

### Git Integration
- Special branch management for keyboard shortcuts
- Enhanced status displays with color coding
- Smart commit functions with validation
- Cross-repository status monitoring

## Testing Framework

### Python (Primary)
- **Doctest-style (.test files)**: Narrative documentation with embedded tests
- **nosetests configuration**: `setup.cfg` defines test discovery
- **pytest support**: Some standard pytest files
- **Shell tests**: Bash scripts for command-line utilities

### Bash Functions
- **Interactive testing**: Functions can be tested live in shell after sourcing
- **Reload mechanism**: `.k` command reloads all keyboard functions
- **Auto-validation**: Keyboard system validates and recompiles on changes

## Common Workflows

### Adding New Shortcuts
1. Add to appropriate `bash/keyboard/[letter].sh` file  
2. Use `.k` to reload keyboard functions
3. Test function interactively
4. Use `push_keys` to commit if satisfied

### Modifying Core Functions
1. Edit appropriate module in `bash/` (e.g., `functons.sh`, `git/functons.sh`)
2. Source the module or restart shell to test
3. For git functions: `. ~/bash/git/__init__.sh`

### Python Development
1. Work in `python/` directory
2. Test with `nosetests --with-doctest --doctest-extension=test`
3. Add new utilities that integrate with bash functions

### Environment Integration
- Most changes are immediately live in current shell
- Use `source ~/jab/__init__.sh` to reload entire environment  
- Critical files like prompt, git functions, colors are hot-linked
- Keyboard shortcuts auto-reload and can be pushed to separate git branch

This system represents decades of shell optimization focused on minimal keystrokes and maximum development efficiency.