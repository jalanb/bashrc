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


def add_option(parser, name, default, explanation):
    letter = '-%s' % name[0]
    word = '--%s' % name
    action = 'store_true'
    if default:
        explanation = 'do not %s' % explanation
        action = 'store_false'
    parser.add_option(
        letter, word, action=action, default=default, help=explanation)


def as_configuration_name(name):
    return '-'.join([s.lower() for s in name.split('-')])


def compare_options(a, b):
    if a[0][0].isupper() and b[0][0].islower():
        return +1
    if a[0][0].islower() and b[0][0].isupper():
        return -1
    return cmp(a[0], b[0])


def get_help_text(configured_globs):
    all_glob_names = ', '.join([k for k in configured_globs.keys()])
    explanations = [
        ('all', 'remove all (%s)' % all_glob_names),
        ('recursive', 'remove from subdirectories too'),
        ('quiet', 'do not show files being removed'),
        ('Trial-Run', 'show which files would be removed, but do nothing'),
        ('Use-Debugger', 'run the program in a debugger'),
    ]
    explanation_names = [a for a, _ in explanations]
    glob_explations = [(name, 'remove "%s"' % value)
                       for name, value in configured_globs.items()
                       if name not in explanation_names]
    return sorted(explanations + glob_explations, cmp=compare_options)


def add_options(parser, configured_options, configured_globs):
    explanations = get_help_text(configured_globs)
    for name, explanation in explanations:
        configuration_name = as_configuration_name(name)
        default = configured_options.get(configuration_name, False)
        add_option(parser, name, default, explanation)


def start_debugging():
    try:
        import pudb as pdb
    except ImportError:
        import pdb
    pdb.set_trace()


def wanted_globs(options, configured_globs):
    """A list of globs for all files to be deleted"""
    return [glob
            for key, value in configured_globs.items()
            if getattr(options, key)
            for glob in value.split()]


def parse_options(arg_list=None):
    """Find out what user wants at command line"""
    configured_options, configured_globs = read_configuration()
    parser = optparse.OptionParser()
    add_options(parser, configured_options, configured_globs)
    options, args = parser.parse_args(arg_list)
    if options.Use_Debugger:
        start_debugging()
    if options.all:
        [setattr(options, name, True) for name in configured_globs.keys()]
    if options.quiet and options.Trial_Run:
        print 'Using --quiet and --Trial-Run: Do nothing'
        raise NotImplementedError
    args = args if args else ['.']
    return options, args, wanted_globs(options, configured_globs)


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
