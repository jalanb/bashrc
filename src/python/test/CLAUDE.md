# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This directory contains the test suite for Alan's personal Python utilities that extend his bash environment. The testing framework uses a unique hybrid approach combining doctest-style `.test` files, traditional pytest files, and shell-based tests.

## Testing Architecture

### Doctest-style Tests (.test files)
The primary testing methodology uses custom `.test` files with doctest format:
- Files use `.test` extension (e.g., `pythonrc.test`, `vim.test`, `add_to_a_path.test`)
- Configured in `../setup.cfg` with nosetests configuration
- Run with: `nosetests --with-doctest --doctest-extension=test` (from parent directory)
- Tests are narrative-style documentation that doubles as executable tests

### Pytest Tests
- Standard pytest files like `test_rf_extras.py`
- Run individual pytest files directly: `python test/test_rf_extras.py`
- Note: pytest module may not be installed in all environments

### Shell Tests
- Bash test scripts like `test_first_num.sh`
- Run with: `bash test/test_first_num.sh`
- Tests specific command-line utilities with expected output verification

## Test Execution Commands

```bash
# From /opt/clones/github/jalanb/bashrcs/jab/src/python/ directory

# Run all doctest-style tests (preferred method)
nosetests --with-doctest --doctest-extension=test test/

# Run individual doctest file
python -m doctest test/pythonrc.test

# Run shell-based tests
bash test/test_first_num.sh

# Run pytest files directly (if available)
python test/test_rf_extras.py
```

## Test File Structure

### .test Files Format
The `.test` files follow a specific narrative format:
- Start with module description and RST-style headers
- Import the module being tested
- Document and test functionality with interactive Python examples
- Use `>>>` prompts for Python code, expected output follows

Example pattern from `vim.test`:
```
The vim module
==============

    >>> import vim
    >>> print vim.__doc__
    Script to set up a call to vim
```

### Key Testing Utilities
- `test_rf_extras.py`: Tests for the `rf.py` module's `wanted_globs` function
- `test_first_num.sh`: Tests the `first_num.py` utility for extracting numbers from arguments
- Mock classes like `MockOptions` for dependency injection during tests

## Development Notes

- Tests may assume they're run from the parent directory (`../`)
- Some tests use `sys.path.insert(0, '..')` to import modules from parent
- The `.test` files contain Python 2 syntax (`print` statements without parentheses) but the main codebase appears to be Python 3
- Tests often include environment-dependent logic (e.g., checking if files exist in current directory)
- Some tests use helper functions like `no_print()` to suppress output during testing

## Test Configuration

Configuration is managed in `../setup.cfg`:
- Nosetests configured with doctest extension
- Tests run from `test/` directory
- Progressive output enabled
- Ignores `*.out.py` files