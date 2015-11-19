#! /usr/bin/env python2
"""Script to """

from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


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
    parser.add_argument('items', metavar='items', type=str, nargs='*',
                        help='some items')
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
    parser.add_argument('-U', '--Use_debugger', action='store_true',
                        help='Run the script with pdb (or pudb if available)')
    clean_args = [a for a in sys.argv[1:] if a[0] != '-' or a[1] in 'Uv']
    args = parser.parse_args(clean_args)
    run_args(args, methods)
    return sys.argv[1:]


def _globalize(items, predicate, name):
    from pprint import pprint
    pprint(items)

def _extract_first(predicate, items):
    result = items[:]
    first = None
    for item in items:
        if predicate(item):
            result.remove(item)
            return item, result
    return None, items

def _extract_all(predicate, items):
    found = bool([_ for _ in items if predicate(_)])
    return

def _extract_first_digit(items):
    return _extract_first(lambda x: x.isdigit(), items)


def script(args):
    want_everything_else = 'NOT_FIRST_NUM' in args
    _, args = _extract_first(lambda x: x == 'NOT_FIRST_NUM', args)
    digit, args = _extract_first_digit(args)
    if want_everything_else:
        print(' '.join(args))
        return True
    if digit is not None:
        print(digit)
        return True
    return False


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
        print(e, file=sys.stderr)
        return not os.EX_OK
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
