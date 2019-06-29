#! /usr/bin/env python
"""Script to remove temporary files

The script contains a known list of globs for temporary files
"""


from __future__ import print_function
import os
import sys
import argparse
import fnmatch


from six.moves import configparser


def get_module_name():
    name, _ = os.path.splitext(os.path.basename(__file__))
    return name


def _get_path_to_config():
    path_to_config = '~/.config/%s/config' % get_module_name()
    return os.path.expanduser(path_to_config)


def has_true(value):
    return value.lower() in ['true', 't', 'yes', 'y', '1']


def default_options():
    options = {
        'all': False,
        'recursive': False,
        'quiet': False,
        'temporary': True,
        'Trial-Run': False,
    }
    globs = {
        'development': 'tags a.out *.log',
        'old': '*.old',
        'python': '*.pyc *.pyo *.fail *$py.class *.profile',
        'temporary':
        '*.bak *.orig temp.* *.tmp *~ .*~ fred.* mary mary.* one two',
        'vim': '*.sw[opqrs]',
    }
    return options, globs


def read_configuration():
    parser = configparser.ConfigParser()
    path = _get_path_to_config()
    if not os.path.isfile(path):
        return default_options()
    parser.read(path)
    options = {k: has_true(v) for k, v in parser.items('options')}
    globs = dict(parser.items('globs'))
    return options, globs


def as_configuration_name(name):
    return '-'.join([s.lower() for s in name.split('-')])


def compare_options(a, b):
    if a[0][0].isupper() and b[0][0].islower():
        return +1
    if a[0][0].islower() and b[0][0].isupper():
        return -1
    return cmp(a[0], b[0])  # pylint: disable=undefined-variable


def get_help_text(configured_globs):
    all_glob_names = ', '.join([k for k in configured_globs.keys()])
    explanations = [
        ('all', 'remove all (%s)' % all_glob_names),
        ('recursive', 'remove from subdirectories too'),
        ('quiet', 'do not show files being removed'),
        ('Trial-Run', 'show which files would be removed, but do nothing'),
    ]
    explanation_names = [a for a, _ in explanations]
    glob_explations = [(name, 'remove "%s"' % value)
                       for name, value in configured_globs.items()
                       if name not in explanation_names]
    try:
        return sorted(explanations + glob_explations, cmp=compare_options)
    except TypeError as e:
        return sorted(explanations + glob_explations, key=lambda x: x[0])


def add_argument(parser, name, default, explanation):
    letter = '-%s' % name[0]
    word = '--%s' % name
    action = 'store_true'
    if default:
        explanation = 'do not %s' % explanation
        action = 'store_false'
    parser.add_argument(
        letter, word, action=action, default=default, help=explanation)


def add_arguments(parser, configured_options, configured_globs):
    explanations = get_help_text(configured_globs)
    for name, explanation in explanations:
        configuration_name = as_configuration_name(name)
        default = configured_options.get(configuration_name, False)
        add_argument(parser, name, default, explanation)


def wanted_globs(options, configured_globs):
    """A list of globs for all files to be deleted"""
    return [glob
            for key, value in configured_globs.items()
            if getattr(options, key)
            for glob in value.split()]


def parse_options():
    """Find out what user wants at command line"""
    configured_options, configured_globs = read_configuration()
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    add_arguments(parser, configured_options, configured_globs)
    parser.add_argument('paths', default=['.'], nargs='*',
                        help='paths to clean (default .)')
    args = parser.parse_args(None)
    paths = args.paths
    delattr(args, 'paths')
    if args.all:
        _ = [setattr(args, name, True) for name in configured_globs.keys()]
    if args.quiet and args.Trial_Run:
        raise NotImplementedError('Using --quiet and --Trial-Run: Do nothing')
    return paths, args, wanted_globs(args, configured_globs)


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
            if name == '.git':
                continue
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
    get_paths = recursive and get_files_under or get_files_in
    result = []
    for glob in globs:
        result.extend(get_paths(directory, glob))
    return result


def remove_files(files, quiet, trial_run):
    """Remove all those files

    Print out each file removed, unless quiet is True
    Do not actually delete if trial_run is True
    """
    dirs = set()
    result = os.EX_OK
    for a_file in files:
        try:
            if not trial_run:
                if os.path.isfile(a_file):
                    os.remove(a_file)
                    dirs.add(os.path.dirname(a_file))
            if not quiet:
                print(a_file)
        except (IOError, OSError) as e:
            print(e)
            result = os.EX_IOERR
    for a_dir in dirs:
        if not os.listdir(a_dir):
            os.removedirs(a_dir)
            if not quiet:
                print(a_dir)
    return result


def script(paths, args, globs):
    """Run the script"""
    result = os.EX_OK
    for path in paths:
        files = get_files(path, globs, args.recursive)
        file_result = remove_files(files, args.quiet, args.Trial_Run)
        if file_result != os.EX_OK:
            result = file_result
    return result


def main():
    """Run the program"""
    try:
        paths, args, globs = parse_options()
    except NotImplementedError as e:
        print(e, file=sys.stderr)
        return os.EX_USAGE
    return script(paths, args, globs)

if __name__ == '__main__':
    sys.exit(main())
