#! /usr/bin/env python2.7
"""Script to provide entry to the vim script"""

from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


__version__ = '0.1.0'


from vim_script import script
from vim_script import strip_puv


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


def use_debugger(_args):
    try:
        import pudb as pdb
    except ImportError:
        import pdb
    pdb.set_trace()


def parse_args(methods):
    """Parse out command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('files', metavar='files', type=str, nargs='+',
                        help='files to edit')
    parser.add_argument('-p', '--tabs', action='store_true',
                        help='put files in tabs')
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
    parser.add_argument('-U', '--use_debugger', action='store_true',
                        help='Run the script with pdb (or pudb if available)')
    parser.add_argument('-d', '--diff_mode', action='store_true', help='use vimdiff')
    parser.add_argument('-o', '--open', action='store_true', help='Open N windows (default: one for each file)')
    parser.add_argument('-O', '--Orienteering', action='store_true', help='Like -o but split vertically')
    args = parser.parse_args(strip_puv(sys.argv))
    run_args(args, methods)
    return args


def main():
    """Run the program"""
    try:
        return script(parse_args(globals()))
    except BdbQuit:
        pass
    except SystemExit as e:
        return e.code
    except Exception, e:  # pylint: disable=broad-except
        if __version__[0] < '1':
            raise
        print(e, sys.stderr)
        return not os.EX_OK
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
