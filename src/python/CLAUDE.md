# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This directory contains personal Python utilities and scripts that extend Alan's bash environment. The codebase serves as a collection of helper tools, path utilities, vim integration scripts, and development conveniences.

## Project Structure

- **Core utilities**: File path manipulation (`add_to_a_path.py`, `relpath.py`), file operations (`files.py`, `rf.py`)
- **Development tools**: Script discovery (`scripts.py`), vim integration (`vim.py`, `vim_script.py`, `vimserver.py`)
- **Shell integration**: Python REPL enhancements (`pythonrc.py`), debugging tools (`traceback_to_pudb.py`)
- **Site-specific utilities**: In `site/` subdirectory for location, path resolution, and task management
- **Testing**: Uses both doctest format (`.test` files) and pytest (`test_rf_extras.py`)

## Key Dependencies

- **pysyte**: Core dependency (version >=0.7.40) - Alan's foundational Python library
- **ipython**: Enhanced Python REPL
- **pudb**: Python debugger
- **pprintpp**: Pretty printing

Install dependencies: `pip install -r requirements.txt`

## Testing Framework

The project uses a hybrid testing approach:

### Doctest-style tests
- Test files use `.test` extension (e.g., `pythonrc.test`, `vim.test`)
- Configured in `setup.cfg` with nosetests
- Run with: `nosetests --with-doctest --doctest-extension=test`

### Pytest tests
- Standard pytest files (e.g., `test_rf_extras.py`)
- Run with: `pytest`

### Shell-based tests
- Some utilities have shell test scripts (e.g., `test_first_num.sh`)

## Script Architecture

Most Python files follow a common pattern:
1. Standard argument parsing with `argparse`
2. Version handling (`--version` flag)
3. Main script logic in `script()` function
4. Error handling for `BdbQuit` (debugger interrupts)
5. Exit code management

Key architectural components:
- `site/script_path.py`: Central registry of known scripts and their locations
- `pythonrc.py`: Customizes Python REPL with history, completion, and utilities
- `vim*.py` files: Provide integration between Python tools and vim editor

## Development Commands

```bash
# Install in development mode
pip install -e .

# Run doctests
nosetests --with-doctest --doctest-extension=test

# Run pytest tests
pytest

# Check code style (if flake8 configured)
flake8 .
```

## Configuration

- `setup.cfg`: Contains test configuration, flake8 settings, and package metadata
- Version management through bumpversion (current: 0.8.88)
- Tests configured to run from `test/` directory with doctest extension support

## Integration Notes

This Python directory is part of a larger bash environment system:
- Many scripts are designed to be called from bash functions
- Path utilities integrate with shell PATH manipulation
- Vim integration provides seamless editor workflow
- Script discovery tools help navigate the broader bashrc project structure