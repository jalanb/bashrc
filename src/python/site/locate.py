#! /usr/bin/env python3
"""Methods to run the locate script more exactly"""


from __future__ import print_function

import re
import os
import argparse
try:
    from commands import getoutput, getstatusoutput
except ImportError:
    from subprocess import getoutput, getstatusoutput
from fnmatch import fnmatch


from repositories import repository
from pysyte.paths import path as makepath
from pysyte import splits


def _path_to_locate():
    """Location of the locate command on most unixen"""
    homebrewed_findutils = makepath('/usr/local/Cellar/findutils/4.4.2/bin/')
    for basename in ('locate', 'glocate'):
        homebrewed_locate = homebrewed_findutils / basename
        if homebrewed_locate.isfile():
            return homebrewed_locate
    return '/usr/bin/locate'


def _add_option(path_to_locate, option):
    if option[:2] != '--':
        option = '--%s' % option
    if option in getoutput('%s -h' % path_to_locate):
        return '%s %s' % (path_to_locate, option)
    return path_to_locate


def _locate_regexp_option():
    command = '%s --help' % _path_to_locate()
    _status, output = getstatusoutput(command)
    return '--regexp' if '--regexp' in output else '--regex'


def glob_to_regexp(string):
    parts = splits.split_and_strip_whole(string, '[*?[]')
    if len(parts) == 1:
        if re.match('[*?[]', string[0]):
            parts.insert(0, '')
        elif re.match('[*?[]', string[-1]):
            parts.append('')
    return '.*'.join(parts)


def _make_locate_command(args):
    """Make a command to locate sought arg"""
    option = args.ignore_case and '-i' or ''
    if args.globs:
        option = _locate_regexp_option()
        string = glob_to_regexp(args.sought)
    else:
        string = args.sought
    path_to_locate = _path_to_locate()
    if args.files or args.directories or args.executables:
        _add_option(path_to_locate, '--basename')
    return '%s %s "%s"' % (path_to_locate, option, string)


def _locatable(path):
    """Whether that path is wanted in location results"""
    return not repository.is_repository_path(path)


def _run_locate(args):
    """Run the locate command on the sought arg"""
    command = _make_locate_command(args)
    if args.verbose:
        print(command)
    status, output = getstatusoutput(command)
    if status and output:
        old = re.search('is more than .* days old', output)
        if not old:
            raise ValueError('command: %s\n output: %s' % (command, output))
    elif not output:
        return []
    locatable = [l for l in output.split('\n') if _locatable(l)]
    for exclude in args.exclude or []:
        locatable = [_ for _ in locatable if not re.search(exclude, _)]
    return locatable


def _make_check_method(method, args):
    """Make a check method by combining the given method with the args"""

    def make_method(predicate):
        def inner_method(string):
            return method(string) and predicate(string)
        return inner_method

    if args.directories:
        return make_method(os.path.isdir)
    if args.files:
        return make_method(os.path.isfile)
    if args.executables:
        return make_method(lambda x: os.path.isfile(x) and os.access(x, os.X_OK))
    if args.real:
        return make_method(os.path.exists)
    return method


def _locate(args):
    """Locate some files called sought arg, restricted by the given args"""

    def _compare(one, two):
        if args.ignore_case:
            one = one.upper()
            two = two.upper()
        if args.globs:
            if '*' not in two:
                two = f'*{two}*'
            return fnmatch(one, two)
        # cmp? pylint: disable=undefined-variable
        try:
            return cmp(one, two) == 0
        except NameError:
            if args.basename:
                return one == two
            return (one > two) - (one < two)

    def _directory_in_path(path):
        test_string = args.sought
        parts = path.split(os.path.sep)
        if args.basename:
            parts = parts[-1:]
        for part in parts:
            if _compare(part, test_string):
                return True
        return False

    lines = _run_locate(args)
    check = _make_check_method(_directory_in_path, args)
    result = [l for l in lines if check(l)]
    if result:
        return result
    if args.directories or args.files:
        return []
    return lines


def parse_args():
    """Handle options and arguments from the command line"""
    parser = argparse.ArgumentParser()
    pa = parser.add_argument
    pa('sought', help='String to locate')
    pa('-b', '--basename', action='store_true', help='only find basenames')
    pa('-d', '--directories', action='store_true', help='only locate directories')
    pa('-e', '--executables', action='store_true', help='only locate executable files')
    pa('-f', '--files', action='store_true', help='only locate files')
    pa('-g', '--globs', action='store_true', help='match on globs')
    pa('-i', '--ignore-case', action='store_true', help='ignore case in searches')
    pa('-l', '--lsld', action='store_true', help='run "ls -ld" on locations')
    pa('-r', '--real', action='store_true', help='only include real paths')
    pa('-x', '--exclude', type=str, nargs='+', help='exclude paths which match regexp(s)')
    pa('-v', '--verbose', help='Show locate command')
    args = parser.parse_args()
    return args


def main():
    """Main method for calling from bash"""
    args = parse_args()
    located_arg = _locate(args)
    if not located_arg:
        return not os.EX_OK
    if args.lsld:
        ls_commands = [str('ls -ld %r' % str(_)) for _ in located_arg]
        __ = [print(getoutput(_)) for _ in ls_commands]
    else:
        print('\n'.join(located_arg))
    return os.EX_OK
