#! /usr/bin/env python3
"""Script to provide entry to the vim script"""

import os
import sys
import argparse
from bdb import BdbQuit


__version__ = "0.1.0"


from .vim_script import script


def parse_args():
    """Parse out command line arguments

    The parsed args are not actually used, except for running --version
    The main script interprets sys.argv itself
        (Some args for here, some for vim)
    """
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "files", metavar="files", type=str, nargs="+", help="files to edit"
    )
    parser.add_argument("-p", "--tabs", action="store_true", help="put files in tabs")
    parser.add_argument("-v", "--version", action="store_true", help="Show version")
    parser.add_argument("-d", "--diff_mode", action="store_true", help="use vimdiff")
    parser.add_argument(
        "-o",
        "--open",
        action="store_true",
        help="Open N windows (default: one for each file)",
    )
    parser.add_argument(
        "-O", "--Orienteering", action="store_true", help="Like -o but split vertically"
    )
    args = parser.parse_args()
    if args.version:
        print(f"{sys.argv[0]}: {__version__}")
        sys.exit(os.EX_OK)
    return args


def main():
    """Run the program"""
    try:
        _ = parse_args()
        return script()
    except BdbQuit:
        pass
    except SystemExit as e:
        return e.code
    return os.EX_OK


if __name__ == "__main__":
    sys.exit(main())
