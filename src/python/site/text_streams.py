"""Module to handle streams of text"""

import os
import sys
from StringIO import StringIO

from osx import get_clipboard_data


def argvs(clipboard_arg=None):
    """Yield streams of text given to a program

    If there are files in sys.argv, use them
    Otherwise if a clipboard arg was provided use a string of clipboard
    Otherwise sys.stdin
    """
    args = sys.argv[1:]
    use_clipboard = clipboard_arg in args + [True]
    if not args:
        yield sys.stdin
    else:
        files = False
        for arg in args:
            if os.path.isfile(arg):
                files = True
                yield file(arg)
        if not files and use_clipboard:
            yield StringIO(get_clipboard_data())


def first_argv(clipboard_arg=None):
    try:
        return [argvs(clipboard_arg)][0]
    except IndexError:
        return ''


def full_lines(stream):
    for line in stream.readlines():
        stripped = line.rstrip()
        if stripped:
            yield stripped
