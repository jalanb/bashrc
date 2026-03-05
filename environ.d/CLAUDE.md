# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# environ.d Directory

This directory contains environment setup scripts for the jab bashrc system. It's part of the larger bashrcs project that extends the traditional `~/.bashrc` into a comprehensive shell environment.

## Architecture

The environ.d directory follows a modular sourcing pattern where `__init__.sh` orchestrates the loading of all environment configuration files in a specific order:

1. **jab.sh** - Core utilities and ls configuration
2. **environ.sh** - PATH setup, bucket configuration, and shell options
3. **colour.sh** - ANSI color definitions
4. **python.sh** - Python environment configuration  
5. **company.sh** - Company-specific settings (sourced with error suppression)
6. **ssh_completion.sh** - SSH hostname completion setup
7. **travis.sh** - Travis CI integration

## Key Components

### PATH Management (environ.sh)
- Uses `add_to_a_path.sh` from `~/jab/src/bash/` for intelligent PATH manipulation
- Sets up comprehensive PATH including:
  - Local bins (`~/bin`, `~/jab/bin`, `~/.local/bin`)
  - Homebrew (`/opt/homebrew/bin`)
  - System paths with proper ordering
  - Virtual environment support (`${VIRTUAL_ENV}/bin`)

### Bucket System (environ.sh)
- Configures `GIT_BUCKET`, `HG_BUCKET`, and `BUCKET` variables
- Points to version control working directories under `~/src/git/bucket` and `~/src/hg/bucket`

### Color System (colour.sh)
- Comprehensive ANSI color code definitions
- Two sets: regular (`NIGHT_*`, `LIGHT_*`) and prompt-escaped (`OTHER_*`)
- Includes foreground, background, and formatting options

### Python Environment (python.sh)
- Configures pip behavior with virtual environment settings
- Sets up `PYTHONPATH` to include `~/jab/src/python/site`
- Configures `PYTHONSTARTUP` for interactive Python sessions
- Sets `PYTHONBREAKPOINT` to use `pudb` debugger

## Development Commands

Since this is a sourced environment system rather than a standalone application:

### Testing Changes
```bash
# Source the entire environ.d system
source ~/jab/environ.d/__init__.sh

# Source individual components for testing
source ~/jab/environ.d/environ.sh
source ~/jab/environ.d/python.sh
```

### Debugging PATH Issues
```bash
# Show current PATH (function from add_to_a_path.sh)
show_path

# Show Python path
show_ppath

# Check bucket configuration
echo $BUCKET $GIT_BUCKET $HG_BUCKET
```

### Verifying SSH Completion
```bash
# Test SSH hostname completion
ssh <TAB><TAB>
```

## File Relationships

- **Depends on**: `~/jab/src/bash/add_to_a_path.sh` for PATH management
- **Used by**: Main bashrc initialization via `jab/__init__.sh`
- **Integrates with**: The broader jab shell environment system

## Important Notes

- All files use `#! /bin/cat` or `#! /bin/bash` headers but are meant to be sourced, not executed
- The `company.sh` file is intentionally empty and sourced with error suppression
- Color definitions support both terminal output and bash prompt usage
- The system assumes `~/jab` directory structure exists and is properly linked from `$HOME`

## Shell Options Set

- `cdspell` - Auto-correct minor spelling errors in cd commands
- `autocd` - Change directory without typing `cd`
- `set -o vi` - Vi-style command line editing