"""This script handles fred files

"If in doubt, name it Fred"
"""


from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


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
    parser.add_argument('-d', '--debug', action='store_true',
                        help='Debug the first fred.py with pudb')
    parser.add_argument('-e', '--edit', action='store_true',
                        help='Edit the freds with vim')
    parser.add_argument('-l', '--list', action='store_true',
                        help='Use long listing')
    parser.add_argument('-r', '--remove', action='store_true',
                        help='Remove the freds')
    parser.add_argument('-p', '--python', action='store_true',
                        help='Run the first fred.py script')
    parser.add_argument('-s', '--shell', action='store_true',
                        help='Run the first fred.sh script')
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
    parser.add_argument('-U', '--Use_debugger', action='store_true',
                        help='Run this script with pdb (or pudb if available)')
    args = parser.parse_args()
    run_args(args, methods)
    return args


def dirs():
    return ('.', '~/tmp', '/tmp')


def freds():
    exts = ('', '.py', '.sh', '.txt', '.now')
    return [str('%s/fred%s' % (d,e)) for d in dirs() for e in exts]


def paths():
    return [makepath(_) for _ in freds()]


def files():
    return [_ for _ in paths() if _.isfile()]


def substantial():
    return [_ for _ in files() if _.size]


def insubstantial():
    return [_ for _ in files() if not _.size]


def purge_insubstantial():
    [_.remove() for _ in insubstantial()]


def as_path(fred):
    string = str(fred)
    if not ' ' in string:
        return string
    return '"%s"' % string


def as_paths(freds):
    return [as_path(_) for _ in freds]


def script(args):
    purge_insubstantial()
    command = 'ls'
    if args.directories:
        global dirs
        dirs = lambda : args.directories
    freds = substantial()
    if args.debug:
        freds = [_ for _ in freds if _.ext == '.py'][:1]
        if not freds:
            raise ScriptError('No pythonic freds found')
        command = 'pudb'
    elif args.list:
        command = 'ls -l'
    elif args.edit:
        command = 'vim -p'
    elif args.remove:
        command = 'rm -vrf'
    elif args.python:
        freds = [_ for _ in freds if _.ext == '.py'][:1]
        if not freds:
            raise ScriptError('No pythonic freds found')
        command = 'mython'
    elif args.shell:
        freds = [_ for _ in freds if _.ext == '.sh'][:1]
        if not freds:
            raise ScriptError('No bashable freds found')
        command = 'bash -x'
    else:
        print(' '.join(freds))
        return True
    if not freds:
        raise ScriptError('No freds found')
    print('%s %s' % (command, ' '.join(as_paths(freds))))
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
    except ScriptError as e:
        print(e, file=sys.stderr)
        return not os.EX_OK
    except Exception, e:  # pylint: disable=broad-except
        if __version__[0] < '1':
            raise
        print(e, file=sys.stderr)
        return not os.EX_OK
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
