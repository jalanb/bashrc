"""Support for dotjab's scripts

See https://github.com/jalanb/dotjab for context
"""

import os


from dotsite.paths import makepath


def _get_environ_path(name):
    path = os.environ.get(name, None)
    if not path:
        return None
    path = makepath(path)
    if path.isdir():
        return path
    return None


def JAB():
    return _get_environ_path('JAB')


def github_sources():
    return _get_environ_path('GITHUB_SOURCES')
