"""This module provides git handling"""


def is_git_path(path):
    """Whether the path is to a git sub-directory

    >>> is_git_path('/path/to/.git/file')
    True
    """
    return '/.git' in path
