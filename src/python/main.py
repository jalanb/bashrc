#! /usr/bin/env python
"""Script to """

from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


__version__ = "0.1.0"


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
    print("%s %s" % (args, __version__))
    raise SystemExit


def parse_args(methods):
    """Parse out command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    pa = parser.add_argument
    pa("items", metavar="items", type=str, nargs="+", help="some items")
    pa("-v", "--version", action="store_true", help="Show version")
    args = parser.parse_args()
    run_args(args, methods)
    return args


def script(args):
    raise ScriptError(repr(args.items))


def main():
    """Run the script"""
    try:
        args = parse_args(globals())
        return os.EX_OK if script(args) else not os.EX_OK
    except BdbQuit:
        pass
    except SystemExit as e:
        return e.code
    return os.EX_OK


if __name__ == "__main__":
    sys.exit(main())
