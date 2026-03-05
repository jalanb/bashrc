# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This directory (`site/`) contains site-specific Python utilities that are part of Alan's extended bash environment. These utilities focus on task management, script discovery, file location, and workspace navigation within the broader `jab` project ecosystem.

## Key Components

### Script Registry & Discovery
- **`script_path.py`**: Central registry mapping command names to their file locations across the workspace (line 6-19). Maps shortcuts like "v" to vim-related scripts, "rf" to file removal tools, "jpm" to package manager scripts, etc.
- **`locate.py`**: Enhanced wrapper around the Unix `locate` command with glob pattern support, case-insensitive search, and filtering by file type (files/directories/executables)

### Task & Workspace Management  
- **`todo.py`**: Priority-based todo list system with colored output support. Reads from `~/jab/todo.txt` or `~/jab/todo.md` and displays items with priority-based coloring (0=bug/red, 1=yesterday/magenta, 2=today/blue, etc.)
- **`work.py`**: Minimal utility for constructing work-related server names using environment variables

### Development Utilities
- **`see_code.py`**: Code inspection and navigation tools
- **`remove_arg.py`**: Argument processing utilities
- **`οs.py`**: OS-specific utilities (note the Greek omicron character)

## Architecture Integration

This `site/` directory is tightly integrated with the parent Python environment:

1. **Script Discovery**: `script_path.py` serves as the central registry for locating scripts across the entire `jab` workspace, enabling quick navigation between related tools
2. **Pysyte Dependency**: All utilities depend on the `pysyte` library (Alan's foundational Python library) for path handling, text processing, and common utilities
3. **Bash Integration**: These scripts are designed to be called from bash functions and integrate seamlessly with the shell environment

## Testing Framework

The `site/` directory uses doctest-style testing:
- Test files use `.test` extension (e.g., `todo.test`, `locate.test`, `οs.test`)
- Tests are configured to run via `nosetests --with-doctest --doctest-extension=test` from the parent directory
- Run tests from `/opt/clones/github/jalanb/bashrcs/jab/src/python/` directory

## Development Commands

Since this is part of the larger Python project, use commands from the parent directory:

```bash
# Run doctests for site utilities
cd /opt/clones/github/jalanb/bashrcs/jab/src/python
nosetests --with-doctest --doctest-extension=test

# Install in development mode (from python/ directory)
pip install -e .

# Test specific site utilities
python -m site.locate --help
python -m site.todo
```

## Dependencies

- **pysyte**: Core dependency for path handling and utilities
- **Standard library**: os, sys, argparse, subprocess, fnmatch, re
- **Optional**: namedtuple (falls back to collections.namedtuple)

## File Naming Convention

Note that `οs.py` uses a Greek omicron (ο) rather than the Latin letter 'o', which allows it to coexist with Python's built-in `os` module while providing OS-specific extensions.