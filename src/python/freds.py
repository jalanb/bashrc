"""This module supplies names of temporary fred files

"If in doubt, name it Fred"
"""


from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


from sh import ls
from dotsite.paths import makepath


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
    parser.add_argument('directories', metavar='items', type=str, nargs='*',
                        help='Only look for fred files in these directories')
    parser.add_argument('-l', '--list', action='store_true',
                        help='Use long listing')
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
    parser.add_argument('-U', '--Use_debugger', action='store_true',
                        help='Run the script with pdb (or pudb if available)')
    args = parser.parse_args()
    run_args(args, methods)
    return args


def freds():
    dirs = ('.', '~/tmp', '/tmp')
    exts = ('py', 'sh', 'txt')
    return [str('%s/fred.%s' % (d,e)) for d in dirs for e in exts]


def paths():
    return [makepath(_) for _ in freds()]


def files():
    return [_ for _ in paths() if _.isfile()]


def substantial():
    return [_ for _ in files() if _.size]


def insubstantial():
    return [_ for _ in files() if not _.size]


def purge_insubstial():
    [_.remove() for _ in insubstantial()]


def script(args):
    for fred in files():
        if args.list:
            print(ls(fred, '-l'))
        else:
            print(fred)
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
    except Exception, e:  # pylint: disable=broad-except
        if __version__[0] < '1':
            raise
        print(e, sys.stderr)
        return not os.EX_OK
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
