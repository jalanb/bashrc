#! /usr/bin/env python2
"""Script to show the first number in its arguments"""

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


_invert = False

def Invert(_args):
    global _invert
    _invert = True


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
    parser.add_argument('-I', '--Invert', action='store_true',
                        help='Show all args except the first number')
    parser.add_argument('-U', '--Use_debugger', action='store_true',
                        help='Run the script with pdb (or pudb if available)')

    def my_arg(string):
        return string in ['-I', '-U', '--Invert', '--Use_debugger']

    my_args = [a for a in sys.argv[1:] if my_arg(a)]
    args = parser.parse_args(my_args)
    run_args(args, methods)
    return [a for a in sys.argv[1:] if not my_arg(a)]


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
    digit, others = _extract_first_digit(args)
    if _invert:
        print(' '.join(others))
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
