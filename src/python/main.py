#! /usr/bin/env python2
"""Script to act as a template"""

import os
import sys
import argparse
from bdb import BdbQuit


def start_debugging():
    try:
        import pudb as pdb
    except ImportError:
        import pdb
    pdb.set_trace()


def parse_args():
    """Parse out command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('-U', '--Use_debugger', action='store_true',
                        help='Run the script with pdb (or pudb if available)')
    args = parser.parse_args()
    if args.Use_debugger:
        start_debugging()
    return args


def main():
    """Run the script"""
    try:
        _args = parse_args()
    except (SystemExit, BdbQuit):
        pass
    except Exception, e:
        print >> sys.stderr, e
        return not os.EX_OK
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
