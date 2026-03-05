# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This directory contains Alan's personal Python utilities that integrate with his extended bash environment. The project serves as a foundational layer of Python tools that support interactive shell functions, file management, development workflows, and personal productivity scripts. This is part of the larger `bashrcs/jab` project - an expanded `.bashrc` system.

## Architecture

### Core Integration Points
- **Bash Integration**: Python scripts are designed to be called from bash functions, not run standalone
- **Pysyte Dependency**: All utilities depend on the `pysyte` library (Alan's foundational Python library) for path handling, text processing, and common utilities
- **Script Registry**: Central command discovery via `site/script_path.py` maps shortcuts to scripts across the workspace
- **Interactive Shell Support**: Tools like `vim.py`, `rf.py`, and productivity utilities extend shell capabilities

### Key Components

#### File & Development Management
- **`rf.py`**: Temporary file removal with configurable glob patterns (development, python, temporary, etc.)
- **`files.py`**: File system utilities and path manipulation
- **`vim.py`/`vim_script.py`**: Enhanced vim integration with argument parsing and session management
- **`scripts.py`**: Script discovery and listing utilities with integration to `script_path.py`

#### Development Tools
- **`ptags.py`**: Python tag generation and code navigation support
- **`traceback_to_pudb.py`**: Enhanced Python debugging integration
- **`update_hosts.py`**: Network configuration management

#### Productivity & Navigation
- **`site/todo.py`**: Priority-based todo list system with colored output (0=bug/red, 1=yesterday/magenta, 2=today/blue, etc.)
- **`site/locate.py`**: Enhanced wrapper around Unix `locate` with glob patterns and filtering
- **`site/work.py`**: Workspace and server name utilities

#### Utilities
- **`first_num.py`**: Number extraction from command line arguments
- **`add_to_a_path.py`**: PATH manipulation utilities
- **`rounding.py`**: Number formatting and rounding functions

## Development Commands

### Testing
```bash
# Run all doctest-style tests (primary testing method)
nosetests --with-doctest --doctest-extension=test

# Run tests from specific subdirectories
nosetests --with-doctest --doctest-extension=test test/
nosetests --with-doctest --doctest-extension=test site/

# Run individual test files
python -m doctest test/vim.test
python -m doctest site/todo.test

# Run pytest-style tests (if pytest available)
python test/test_rf_extras.py

# Run shell-based tests
bash test/test_first_num.sh
```

### Installation & Setup
```bash
# Install in development mode
pip install -e .

# Install dependencies
pip install -r requirements.txt
```

### Code Quality
```bash
# Check with flake8 (configuration in setup.cfg)
flake8

# Note: Specific linting commands not defined; this is a personal utility collection
```

## Testing Framework

The project uses a hybrid testing approach:

1. **Doctest-style (.test files)**: Primary testing method with narrative documentation
   - Configuration in `setup.cfg` with nosetests
   - Files like `pythonrc.test`, `vim.test`, `add_to_a_path.test`
   - Run with: `nosetests --with-doctest --doctest-extension=test`

2. **Pytest files**: Standard pytest files like `test_rf_extras.py`
3. **Shell tests**: Bash scripts like `test_first_num.sh` for command-line utilities

## Configuration

- **setup.py**: Package configuration with pysyte dependency and pytest support
- **setup.cfg**: nosetests configuration, flake8 settings, version management
- **requirements.txt**: Dependencies including ipython, pudb, pprintpp, pysyte>=0.7.40

## Integration Notes

- This directory is part of the larger `/opt/clones/github/jalanb/bashrcs/jab/` project
- Many utilities are called from bash functions defined in `../bash/` directories
- Script discovery is centralized through `site/script_path.py` for cross-project navigation
- Python 3.7+ required (as per setup.py classifiers)
- Designed for macOS/Darwin environment (personal development machine)

## File Naming Conventions

- **`.test` files**: Doctest-style tests with narrative documentation
- **`fred.*` files**: Temporary placeholder files that can be ignored
- **`site/οs.py`**: Uses Greek omicron (ο) to avoid conflict with Python's `os` module