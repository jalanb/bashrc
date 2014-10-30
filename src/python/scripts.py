#! /usr/bin/env python2
"""Script to """

from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


import script_paths

__version__ = '0.1.0'


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


def Use_debugger(_args):
    try:
        import pudb as pdb
    except ImportError:
        import pdb
    pdb.set_trace()


def parse_args(methods):
    """Parse out command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('keys', metavar='keys', type=str, nargs='+',
                        help='keys to find')
    parser.add_argument('-i', '--inverse', action='store_true',
                        help='show inverse')
    parser.add_argument('-m', '--mains', action='store_true',
                        help='show python scripts with main methods')
    parser.add_argument('-p', '--python', action='store_true',
                        help='show python scripts only')
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
    parser.add_argument('-U', '--Use_debugger', action='store_true',
                        help='Run the script with pdb (or pudb if available)')
    args = parser.parse_args()
    run_args(args, methods)
    return args


def lines(path_to_item):
    if path_to_item.isfile():
        return path_to_item.lines()
    return ['']


def script(args):
    paths_to_items = script_paths.get(args.keys)
    result = False
    for path_to_item in paths_to_items:
        if args.python:
            if path_to_item.ext != '.py':
                if 'python' not in lines(path_to_item)[0]:
                    continue
        elif args.mains:
            for line in lines(path_to_item):
                if line.startswith('def main('):
                    break
            else:
                continue
        print(path_to_item)
        result = True
    return result


def main():
    """Run the script"""
    try:
        args = parse_args(globals())
        return os.EX_OK if script(args) else not os.EX_OK
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
