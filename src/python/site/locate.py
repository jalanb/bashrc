"""Methods to run the locate script more exactly"""


import os
import shlex
import commands
import optparse


from repositories import repository


def _path_to_locate():
    """Location of the locate command on most unixen"""
    homebrewed_locate = '/usr/local/Cellar/findutils/4.4.2/bin/locate'
    if os.path.isfile(homebrewed_locate):
        return homebrewed_locate
    return '/usr/bin/locate'


def _make_locate_command(string, options):
    """Make a command to locate that string"""
    option = options.ignore_case and '-i' or ''
    return '%s %s "%s"' % (_path_to_locate(), option, string)


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
    return [l for l in output.split('\n') if _locatable(l)]


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

    def _has_basename(path):
        if options.ignore_case:
            return os.path.basename(path).upper() == string.upper()
        return os.path.basename(path) == string
    check = _make_check_method(_has_basename, options)
    result = [l for l in lines if check(l)]
    if result or options.basename:
        return result

    def _directory_in_path(path):
        test_string = string
        if options.ignore_case:
            test_string = string.upper()
            path = path.upper()
        parts = path.split(os.path.sep)
        if options.basename:
            return test_string == parts[-1]
        else:
            return test_string in parts
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
    parser.add_option('-i', '--ignore-case', action='store_true',
                      help='ignore case in searches')
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
    for arg in args:
        paths = _locate(arg, options)
        if paths:
            print '\n'.join(paths)
    return os.EX_OK
