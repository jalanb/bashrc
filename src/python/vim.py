#! /usr/bin/env python3
"""Script to provide entry to the vim script"""

from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


__version__ = '0.1.0'


from vim_script import script


class ScriptError(NotImplementedError):
    pass


def run_args(args, methods):
    """Run any methods eponymous with args"""
    if not args:
        return False
    valuable_args = {k for k, v in args.__dict__.items() if v}
    arg_methods = {methods[a] for a in valuable_args if a in methods}
    for method in arg_methods:
        method(args)


def version(args):
    print('%s %s' % (args, __version__))
    raise SystemExit


def parse_args(methods):
    """Parse out command line arguments

    The parsed args are not actually used, except for running -U and -v
    The main script interprets sys.argv itself
        (Some args for here, some for vim)
    """
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('files', metavar='files', type=str, nargs='+',
                        help='files to edit')
    parser.add_argument('-p', '--tabs', action='store_true',
                        help='put files in tabs')
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
    parser.add_argument('-d', '--diff_mode', action='store_true', help='use vimdiff')
    parser.add_argument('-o', '--open', action='store_true', help='Open N windows (default: one for each file)')
    parser.add_argument('-O', '--Orienteering', action='store_true', help='Like -o but split vertically')
    args = parser.parse_args()
    run_args(args, methods)
    return args


def main():
    """Run the program"""
    try:
        _ = parse_args(globals())
        return script()
    except BdbQuit:
        pass
    except SystemExit as e:
        return e.code
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
