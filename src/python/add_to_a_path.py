"""Script to display a collection of paths after inserting one new path

Usage:
    add_to_a_path.py [-U] PATHS PATH
    add_to_a_path.py [-U] (-s | -i INDEX ) PATHS PATH

Options:
    -h, --help               Show this help and exit
    -v, --version            Show version number and exit
    -U, --use_debugger       Run the script with pudb debugger
    -s, --start              Add the path at start of list of paths
    -i INDEX, --index=INDEX  Specify the index at which the path will be inserted


Examples of use:
    $ export PATH=/bin:/usr/bin

    $ add_to_a_path.py PATH /usr/local/bin
    /bin:/usr/bin:/usr/local/bin

    $ add_to_a_path.py PATH /usr/local/bin --start
    /usr/local/bin:/bin:/usr/bin


    $ add_to_a_path.py $PATH /usr/local/bin --index=1
    /bin:/usr/local/bin:/usr/bin

    $ add_to_a_path.py $PATH /not/a/real/path
    /bin:/usr/bin

"""


from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


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
    parser.add_argument('symbol', help='The bash symbol to be changed')
    parser.add_argument('path', help='The path to be added')
    parser.add_argument('-s', '--start', action='store_true',
                        help='Add the path at start of list of paths')
    parser.add_argument('-i', '--index', type=int,
                        help='Specify the index at which the path will be inserted')
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
    parser.add_argument('-U', '--Use_debugger', action='store_true',
                        help='Run the script with pdb (or pudb if available)')
    args = parser.parse_args()
    if not args.index:
        if args.start:
            args.index = 0
        else:
            args.index = False
    run_args(args, methods)
    return args


def add_path_to_paths(paths, path, i):
    if i is False:
        i = len(paths)
    result = paths[:]
    if path and path not in result:
        result.insert(i, path)
    return result


def arg_path(args):
    path = args.path
    if not path:
        return None
    user_path = os.path.expanduser(path)
    real_path = os.path.realpath(user_path)
    if not os.path.isdir(real_path):
        return None
    return real_path


def split_paths(string):
    return [p for p in string.split(os.path.pathsep) if p]



def get_paths(args):
    path_string = args.symbol
    if os.path.pathsep not in path_string and path_string in os.environ:
        return os.environ[path_string]
    return path_string


def script(args):
    path = arg_path(args)
    path_string = get_paths(args)
    if not path:
        print(path_string)
        return True
    paths = []
    index = args.index
    paths = split_paths(path_string)
    if os.path.isdir(path):
        paths = add_path_to_paths(paths, path, args.index)
    print(os.path.pathsep.join(paths))
    return True


def main():
    """Run the script"""
    try:
        args = parse_args(globals())
        return os.EX_OK if script(args) else not os.EX_OK
    except (SystemExit, BdbQuit):
        pass
    except Exception, e:  # pylint: disable=broad-except
        if __version__[0] < '1':
            raise
        print(e, sys.stderr)
        return not os.EX_OK
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
