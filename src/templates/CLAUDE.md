# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Templates Directory

This directory contains template files for the `jab` project, which is part of the extended bashrc system that provides thousands of bash functions and Python utilities for command-line productivity.

## Purpose

The `templates/` directory stores reusable template files that can be copied and customized for various purposes across the project. Currently contains a Travis CI configuration template.

## Architecture Context

This directory is part of the larger `jab` project structure:
- **Parent Project**: `/opt/clones/github/jalanb/bashrcs/jab/` - Extended bashrc system
- **Main Source**: `src/bash/` - Bash functions organized by letter (a.sh, b.sh, etc.)
- **Python Utilities**: `src/python/` - Python scripts supporting bash functions
- **Templates**: `src/templates/` - Template files for project setup

## Common Development Commands

### Testing
```bash
# Run all tests using tox
tox

# Run specific test environments
tox -e tests    # Python tests only
tox -e lints    # Linting only

# Run pytest directly
pytest --doctest-modules --doctest-glob="*.test" --doctest-glob="*.tests" src/python
```

### Linting
```bash
# Run all linters
tox -e lints

# Individual linting tools
black --check src/python
flake8 src/python
mypy --ignore-missing-imports --install-types --non-interactive src/python
```

### Development Setup
```bash
# Source the main bashrc system (from home directory)
source ~/jab/__init__.sh

# Source individual components
source ~/jab/src/bash/__init__.sh
source ~/jab/environ.d/__init__.sh
```

## Key Files in Templates

- `.travis.yml` - Travis CI configuration template for Python projects with PyPI deployment
- Templates should follow the project's naming conventions and include proper documentation

## Integration Points

Templates created here may be:
- Copied to new sub-projects within the jab ecosystem
- Referenced by bash functions that generate new files
- Used by Python scripts for file generation
- Applied when setting up new components in the broader bashrc system

## Development Guidelines

- Templates should be generic enough for reuse but specific enough to be useful
- Include comments explaining customizable sections
- Follow the project's philosophy of abbreviated commands and enhanced productivity
- Consider integration with existing bash functions in `src/bash/keyboard/` for easy access