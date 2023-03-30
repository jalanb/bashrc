#! /usr/bin/env python
"""Script to """

import os
import sys
import argparse
from bdb import BdbQuit

from pysyte.types.paths import pwd


__version__ = "0.1.0"


class ScriptError(NotImplementedError):
    pass


def parse_args(methods):
    """Parse out command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "items", metavar="items", type=str, nargs="+", help="some items"
    )
    parser.add_argument(
        "-s",
        "--short",
        action="store_true",
        help="The shorter of absolute or relative path",
    )
    parser.add_argument("-v", "--version", action="store_true", help="Show version")
    args = parser.parse_args()
    if args.version:
        print(f"version: {__version__}")
        sys.exit(0)
    return args


def script(args):
    p = pwd()
    method = p.short_relative_path_to if args.short else p.relpathto
    print(method(" ".join(args.items)))
    return True


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
