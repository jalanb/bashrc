"""Script to remove temporary files

The script contains a known list of globs for temporary files
"""


import os
import sys
import optparse
import fnmatch
import ConfigParser


def get_module_name():
    name, _ = os.path.splitext(os.path.basename(__file__))
    return name


def _get_path_to_config():
    path_to_config = '~/.config/%s/config' % get_module_name()
    return os.path.expanduser(path_to_config)


def has_true(value):
    return value.lower() in ['true', 't', 'yes', 'y', '1']


def read_configuration():
    parser = ConfigParser.SafeConfigParser()
    parser.read(_get_path_to_config())
    configured_options = dict([
        (key, has_true(value)) for key, value in parser.items('options')])
    globs = dict(parser.items('globs'))
    return configured_options, globs


def parse_options(arg_list=None):
    """Find out what user wants at command line"""
    configured_options, configured_globs = read_configuration()
    parser = optparse.OptionParser()
    parser.add_option('-p', '--python', action='store_true',
                      default=configured_options['python'],
                      help='remove python temporary files too')
    parser.add_option('-o', '--old', action='store_true',
                      default=configured_options['old'],
                      help='remove old files')
    parser.add_option('-r', '--recursive', action='store_true',
                      default=configured_options['recursive'],
                      help='remove from subdirectories too')
    parser.add_option('-q', '--quiet', action='store_true',
                      default=configured_options['quiet'],
                      help='do not show files being removed')
    parser.add_option('-t', '--temporary', action='store_true',
                      default=configured_options['temporary'],
                      help='remove temporary files')
    parser.add_option('-T', '--Trial-Run', action='store_true',
                      default=configured_options['trial-run'],
                      help='show which files would be removed, but do nothing')
    parser.add_option('-U', '--Use-Debugger', action='store_true',
                      default=configured_options['use-debugger'],
                      help='Run the code under pudb')
    options, args = parser.parse_args(arg_list)
    if options.Use_Debugger:
        try:
            import pudb as pdb
        except ImportError:
            import pdb
        pdb.set_trace()
    if options.quiet and options.Trial_Run:
        print 'Using --quiet and --Trial-Run: Do nothing'
        raise NotImplementedError
    if not args:
        args = ['.']
    return options, args, get_globs(options, configured_globs)


def get_globs(options, configured_globs):
    """A list of globs for all files to be deleted"""
    globs = configured_globs['temporary'].split()
    if options.python:
        globs.extend(configured_globs['python'].split())
    if options.old:
        globs.extend(configured_globs['old'].split())
    return globs


def get_names_in(directory):
    """A list of names for all items in that directory"""
    try:
        return os.listdir(directory)
    except (IOError, OSError):
        return []


def get_paths_in(directory, glob):
    """A list of all items in that directory, which match that glob"""
    names = get_names_in(directory)
    names = fnmatch.filter(names, glob)
    return [os.path.join(directory, name) for name in names]


def get_paths_under(directory, glob):
    """Get a list of directories under that directory, matching those globs"""
    result = []
    for name in get_names_in(directory):
        path = os.path.join(directory, name)
        if os.path.isdir(path):
            more = get_paths_under(path, glob)
            result.extend(more)
        if fnmatch.fnmatch(name, glob):
            result.append(path)
    return result


def get_files_under(directory, globs):
    """Get a list of files under that directory, matching those globs"""
    paths = get_paths_under(directory, globs)
    return [path for path in paths if os.path.isfile(path)]


def get_files_in(directory, globs):
    """Get a list of files in that directory, matching those globs"""
    paths = get_paths_in(directory, globs)
    return [path for path in paths if os.path.isfile(path)]


def get_files(directory, globs, recursive):
    """Get a list of files under that directory, matching those globs"""
    get_some_files = recursive and get_files_under or get_files_in
    result = []
    for glob in globs:
        result.extend(get_some_files(directory, glob))
    return result


def remove_files(files, quiet, trial_run):
    """Remove all those files

    Print out each file removed, unless quiet is True
    Do not actually delete if trial_run is True
    """
    result = os.EX_OK
    for a_file in files:
        try:
            if not trial_run:
                os.remove(a_file)
            if not quiet:
                print a_file
        except (IOError, OSError), e:
            print e
            result = os.EX_IOERR
    return result


def main():
    """Run the program"""
    try:
        options, args, globs = parse_options()
    except NotImplementedError:
        return os.EX_USAGE
    result = os.EX_OK
    for arg in args:
        files = get_files(arg, globs, options.recursive)
        file_result = remove_files(files, options.quiet, options.Trial_Run)
        if file_result != os.EX_OK:
            result = file_result
    return result


if __name__ == '__main__':
    sys.exit(main())
