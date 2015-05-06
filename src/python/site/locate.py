"""Methods to run the locate script more exactly"""


from __future__ import print_function

import re
import os
import shlex
import commands
import optparse
from fnmatch import fnmatch


from repositories import repository
from dotsite import splits


def _path_to_locate():
    """Location of the locate command on most unixen"""
    homebrewed_locate = '/usr/local/Cellar/findutils/4.4.2/bin/locate'
    if os.path.isfile(homebrewed_locate):
        return homebrewed_locate
    return '/usr/bin/locate'


def _add_option(path_to_locate, option):
    if option[:2] != '--':
        option = '--%s' % option
    if option in commands.getoutput('%s -h' % path_to_locate):
        return '%s %s' % (path_to_locate, option)
    return path_to_locate


def _locate_regexp_option():
    command = '%s --help'
    _status, output = commands.getstatusoutput(command)
    return '--regexp' if '--regexp' in output else '--regex'


def glob_to_regexp(string):
    parts = splits.split_and_strip_whole(string, '[*?[]')
    if len(parts) == 1:
        if re.match('[*?[]', string[0]):
            parts.insert(0, '')
        elif re.match('[*?[]', string[-1]):
            parts.append('')
    return '.*'.join(parts)


def _make_locate_command(string, options):
    """Make a command to locate that string"""
    option = options.ignore_case and '-i' or ''
    if options.globs:
        option = _locate_regexp_option()
        string = glob_to_regexp(string)
    path_to_locate = _path_to_locate()
    if options.files or options.directories:
        _add_option(path_to_locate, '--basename')
    return '%s %s "%s"' % (path_to_locate, option, string)


def _locatable(path):
    """Whether that path is wanted in location results

    >>> not _locatable('/path/to/.svn/file')
    True
    """
    return not repository.is_repository_path(path)


def _run_locate(string, options):
    """Run the locate command on the given string"""
    command = _make_locate_command(string, options)
    status, output = commands.getstatusoutput(command)
    if status and output:
        raise ValueError('command: %s\n output: %s' % (command, output))
    elif not output:
        return []
    locatable = [l for l in output.split('\n') if _locatable(l)]
    for exclude in options.exclude or []:
        locatable = [_ for _ in locatable if not re.search(exclude, _)]
    return locatable


def _make_check_method(method, options):
    """Make a check method by combining the given method with the options"""
    if options.directories:
        def is_dir(string):
            return method(string) and os.path.isdir(string)
        return is_dir
    if options.files:
        def is_file(string):
            return method(string) and os.path.isfile(string)
        return is_file
    return method


def _locate(string, options):
    """Locate some files called string, restricted by the given options"""
    lines = _run_locate(string, options)

    def _compare(one, two):
        if options.ignore_case:
            one = one.upper()
            two = two.upper()
        if options.globs:
            return fnmatch(one, two)
        return cmp(one, two) == 0

    def _has_basename(path):
        return _compare(os.path.basename(path), string)

    check = _make_check_method(_has_basename, options)
    result = [l for l in lines if check(l)]
    if result or options.basename:
        return result

    def _directory_in_path(path):
        test_string = string
        parts = path.split(os.path.sep)
        if options.basename:
            parts = parts[-1:]
        for part in parts:
            if _compare(part, test_string):
                return True
        return False

    check = _make_check_method(_directory_in_path, options)
    result = [l for l in lines if check(l)]
    if result:
        return result
    if options.directories or options.files:
        return []
    return lines


def _handle_command_line(args):
    """Handle options and arguments from the command line"""
    parser = optparse.OptionParser()
    parser.add_option('-b', '--basename', action='store_true',
                      help='only find basenames')
    parser.add_option('-d', '--directories', action='store_true',
                      help='only locate directories')
    parser.add_option('-f', '--files', action='store_true',
                      help='only locate files')
    parser.add_option('-g', '--globs', action='store_true',
                      help='match on globs')
    parser.add_option('-i', '--ignore-case', action='store_true',
                      help='ignore case in searches')
    parser.add_option('-l', '--lsld', action='store_true',
                      help='run "ls -ld" on locations')
    parser.add_option('-x', '--exclude', type='str', action='append',
                      help='exclude paths which match regexp(s)')
    parser.add_option('-U', '--Use_debugger', action='store_true',
                      help='debug with pudb')
    options, args = parser.parse_args(args)
    if options.Use_debugger:
        import pudb
        pudb.set_trace()
    return options, args


def locate_file(command_line):
    """Locate the file(s) in that command line"""
    return locate('%s -f' % command_line)


def locate_directory(command_line):
    """Locate the directory/ies in that command line"""
    return locate('%s -d' % command_line)


def locate(command_line):
    """Main method for calling from python"""
    args = shlex.split(command_line)
    options, args = _handle_command_line(args)
    result = {}
    if len(args) == 1:
        return _locate(args[0], options)
    for arg in args:
        result[arg] = _locate(arg, options)
    return result


def main(args):
    """Main method for calling from bash"""
    options, args = _handle_command_line(args)
    result = not os.EX_OK
    for arg in args:
        paths = _locate(arg, options)
        if paths:
            if options.lsld:
                ls_commands = [str('ls -ld %r' % str(_)) for _ in paths]
                __ = [print(commands.getoutput(_)) for _ in ls_commands]
            else:
                print('\n'.join(paths))
            result = os.EX_OK
    return result
