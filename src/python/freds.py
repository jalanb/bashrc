"""This script handles fred files

"If in doubt, name it Fred"
"""


import os
import sys
import argparse
from bdb import BdbQuit

from rich import print
from pysyte.cli.arguments import ArgumentsParser
from pysyte.cli.main import run
from pysyte.freds.freds import Freds
from pysyte.types.paths import path

__version__ = '0.1.0'


class TypedError(FileNotFoundError):
    def __init__(self, type_, name):
        super().__init__(f'{type_} {name} not found')


class PythonError(TypedError):
    def __init__(self, name):
        super().__init__('pythonic', name)


class BashError(TypedError):
    def __init__(self, name):
        super().__init__('bashable', name)



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
    args = parser.parse_args()
    run_args(args, methods)
    return args

def add_args(parser: ArgumentsParser) -> ArgumentsParser:
    parser.positional('directories', metavar='items', type=str, 
                        help='Only look for fred files in these directories')
    parser.add_option('-d', '--debug', action='store_true',
                        help='Debug the first fred.py with pudb')
    parser.add_option('-e', '--edit', action='store_true',
                        help='Edit the freds with vim')
    parser.add_option('-l', '--list', action='store_true',
                        help='Use long listing')
    parser.add_option('-r', '--remove', action='store_true',
                        help='Remove the freds')
    parser.add_option('-p', '--python', action='store_true',
                        help='Run the first fred.py script')
    parser.add_option('-s', '--shell', action='store_true',
                        help='Run the first fred.sh script')
    parser.add_option('-v', '--version', action='store_true',
                        help='Show version')
    return parser


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
    freds.remove_empties()
    fred_files = freds.sized()
    if args.debug:
        fred_files = [_ for _ in fred_files if _.ext == '.py'][:1]
        if not fred_files:
            raise PythonError('freds')
        command = 'pudb'
    elif args.list:
        command = 'ls -l'
    elif args.edit:
        command = 'vim -p'
    elif args.remove:
        command = 'rm -vrf'
    elif args.python:
        freds = [_.name for _ in fred_files if _ and _.ext == '.py'][:1]
        if not freds:
            raise PythonError('freds')
        command = '; '.join(
            f"""python -c "
            try:
                breakpoint()
                import {_}
            except ImportError:
                pass
            "
            """ for _ in freds
        )
    elif args.shell:
        freds = [_ for _ in fred_files if _ and _.ext == '.sh'][:1]
        if not freds:
            raise BashError('freds')
        commands = [f"bash -x {_}" for _ in freds]
        command = "; ".join(commands)
        print(command)
        return True
    else:
        print(' '.join(fred_files))
        return True
    if not fred_files:
        if args.edit:
            fred_files = ["fred",]
        elif args.list:
            fred_files = ["fred*",]
        elif args.remove:
            return True
        else:
            raise FileNotFoundError('No freds found')
    print('%s %s' % (command, ' '.join(as_paths(fred_files))))
    return True


def main(args):
    try:
        return script(args)
    except TypedError as e:
        print(str(e), file=sys.stderr)
        return False

run(main, add_args)
