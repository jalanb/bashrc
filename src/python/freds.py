"""This script handles fred files

"If in doubt, name it Fred"
"""


from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit

from dotsite.paths import path


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


def version(_):
    print('%s %s' % (os.path.basename(sys.argv[0]), __version__))
    raise SystemExit


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
    args = parser.parse_args()
    run_args(args, methods)
    return args


class Freds(object):
    """Handle fred.* as strings, paths, files, ..."""
    def __init__(self, dirs):
        self._dirs = dirs

    def _strings(self):
        exts = ('', '.py', '.sh', '.txt', '.now', '.html')
        return [str('%s/fred%s' % (d, e)) for d in self._dirs for e in exts]

    def _paths(self):
        return [path(_) for _ in self._strings()]

    def _files(self):
        return [_ for _ in self._paths() if _.isfile()]

    def substantial(self):
        return set(_ for _ in self._files() if _.size)

    def _insubstantial(self):
        return [_ for _ in self._files() if not _.size]

    def purge_insubstantial(self):
        [_.remove() for _ in self._insubstantial()]


def as_path(fred):
    string = str(fred)
    if ' ' not in string:
        return string
    return '"%s"' % string


def as_paths(strings):
    return [as_path(_) for _ in strings]


def script(args):
    command = 'ls'
    freds = Freds(args.directories or ['.', '~/tmp', '/tmp'])
    freds.purge_insubstantial()
    fred_files = freds.substantial()
    if args.debug:
        fred_files = [_ for _ in fred_files if _.ext == '.py'][:1]
        if not fred_files:
            raise ScriptError('No pythonic freds found')
        command = 'pudb'
    elif args.list:
        command = 'ls -l'
    elif args.edit:
        command = 'vim -p'
    elif args.remove:
        command = 'rm -vrf'
    elif args.python:
        fred_files = [_ for _ in fred_files if _.ext == '.py'][:1]
        if not fred_files:
            raise ScriptError('No pythonic freds found')
        command = 'pyth'
    elif args.shell:
        fred_files = [_ for _ in fred_files if _.ext == '.sh'][:1]
        if not fred_files:
            raise ScriptError('No bashable freds found')
        command = 'bash -x'
    else:
        print(' '.join(fred_files))
        return True
    if not fred_files:
        raise ScriptError('No freds found')
    print('%s %s' % (command, ' '.join(as_paths(fred_files))))
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
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
