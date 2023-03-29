#! /usr/bin/env python
"""Script to """

from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


from pysyte.types.paths import pwd
from pysyte.types.paths import path as makepath
import freds


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
    parser.add_argument(
        "items", metavar="items", type=str, nargs="*", help="some items"
    )
    parser.add_argument("-v", "--version", action="store_true", help="Show version")
    args = parser.parse_args()
    run_args(args, methods)
    return args


def get_freds(paths):
    if not paths:
        freds.purge_insubstial()
        result = freds.substantial()
    else:
        result = set()
        for path in paths:
            path = makepath(path)
            if path.isdir():
                result |= {p for p in path.files("fred*") if p[-1] != "~"}
            elif path.isfile() and path.name.startswith("fred"):
                result.add(path)
    return [pwd().relpathto(p) for p in result]


def script(args):
    freds_ = get_freds(args.items)
    if not freds_:
        return False
    print("v %s" % " ".join(freds_))
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
