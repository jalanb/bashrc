#! /usr/bin/env python
"""Script to """

import os
import sys
import argparse
from bdb import BdbQuit


__version__ = "0.1.0"


class ScriptError(NotImplementedError):
    pass


def parse_args(methods):
    """Parse out command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    pa = parser.add_argument
    pa("items", metavar="items", type=str, nargs="+", help="some items")
    pa("-v", "--version", action="store_true", help="Show version")
    args = parser.parse_args()
    if args.version:
        print(f"version: {__version__}")
        sys.exit(0)
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
