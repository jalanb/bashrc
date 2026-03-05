#!/usr/bin/env python3
"""Test rf.py extras logic - pytest style"""

import sys
sys.path.insert(0, '..')
from rf import wanted_globs

class MockOptions:
    def __init__(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)

def check_globs(python=False, extras=False, expected=None):
    """Syntax sugar to reduce DRY"""
    options = MockOptions(python=python, extras=extras)
    actual = wanted_globs(options, GLOBS)
    assert actual == expected, f"{python=}, {extras=}: got {actual}, expected {expected}"

GLOBS = {
    'python': '*.pyc htmlcov *.egg-info',
    'extras': '.venv .tox dist .coverage'
}

check_globs(python=True, extras=False, expected=['*.pyc', 'htmlcov', '*.egg-info'])
check_globs(python=False, extras=True, expected=[])
check_globs(python=True, extras=True, expected=['*.pyc', 'htmlcov', '*.egg-info', '.venv', '.tox', 'dist', '.coverage'])
check_globs(python=False, extras=False, expected=[])