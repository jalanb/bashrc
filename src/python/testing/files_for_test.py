"""This module provides convenience methods to handle test files

Test files are expected to exist as triples:
    fred.py, fred.test, fred.tests
    with fred.test* being optional

We also allow for python scripts which have no extension
"""


from __future__ import print_function
import os
import re
import sys
import argparse


try:
    from pysyte.paths import path
except ImportError:
    from dotsite.paths import path


class UserMessage(Exception):
    """Tell the user something went wrong"""
    pass


def first_thing_that(things, predicate):
    for thing in things:
        if predicate(thing):
            return thing
    return None


def _get_path_to_test_directory(strings):
    """Get a path to the root directory that we'll be testing in

    We will test in the first directory in strings
        or the directory of the first file in strings
    """
    paths = [path(s) for s in strings]
    result = first_thing_that(paths, lambda p: p.isdir())
    if not result:
        try:
            result = first_thing_that(paths, lambda p: p.parent and p.isfile()).parent
        except AttributeError:
            raise UserMessage('No doctests found in %r' % strings)
    if not result.files('*.test*') and not result.files('*.py'):
        raise UserMessage('No doctests found in %r' % strings)
    return result


def _existing_test_files(path_to_stem):
    """A list of all existing extensions of the given path

    Find all such extensions by replacing any extension in a real file
        or adding "/*" if it is a directory
        or otherwise looking the current directory

    Not expecting any test scripts in the root directory
    >>> _existing_test_files(path('/test_files.txt')) == []
    True

    But we should expect them for this script
    >>> __file__ in _existing_test_files(path(__file__))
    True
    """
    if path_to_stem.isfile():
        dirr = path_to_stem.parent
        glob = path_to_stem.namebase + '.*'
    elif path_to_stem.isdir():
        dirr = path_to_stem
        glob = '*'
    else:
        if path_to_stem.parent:
            dirr = path_to_stem.parent
        glob = '%s.*' % path_to_stem.namebase
    if not dirr.isdir():
        return []
    return [f for f in dirr.files(glob)]


def _existing_test_extensions(path_stem):
    """A list of all text extensions of the given path stem"""
    return [f for f in _existing_test_files(path_stem) if f.ext in possible_test_extensions()]


def _get_path_stems(strings, recursive):
    """A list of any paths in strings

    If there is a "/" in the strings then it is used in the list
    Otherwise it is appended to the current working directory
    """
    strings = strings or []
    here = path('.')
    paths = ['/' in s and path(s) or here / s for s in strings]
    if not recursive:
        return paths
    return add_sub_dirs(paths)


def add_sub_dirs(paths):
    """Add all sub-directories for the directories of the paths"""
    dirs = {p.directory() for p in paths}
    result = dirs.copy()
    for path_to_dir in dirs:
        for sub_dir in path_to_dir.walkdirs():
            import pudb
            pudb.set_trace()
            if sub_dir.in_git_repo():
                continue
            result.add(sub_dir)
    return result


def python_source_extensions():
    """The extensions of files that often contain python source"""
    return ['.py', '']


def python_doctest_extensions():
    """The extensions of files that often contain python doctests"""
    return ['.tests', '.test']


def possible_test_extensions():
    """All possible extensions for python files and test files"""
    return python_doctest_extensions() + python_source_extensions()


def positive_test_extensions():
    """Positive extensions for python files and test files"""
    return [ext for ext in possible_test_extensions() if ext]


def is_python_source_extension(string):
    """Whether the string is an extension for a file with python source"""
    return string in python_source_extensions()


def is_python_doctest_extension(string):
    """Whether the string is an extension for a file with python doctests"""
    return string in python_doctest_extensions()


def is_possible_test_extension(string):
    """Whether the string is a possible test extension"""
    return string in possible_test_extensions()


def is_positive_test_extension(string):
    """Whether the string is a positive test extension"""
    return string in positive_test_extensions()


def _has_checked_extension(string, checker):
    """Whether the string has an extension validated by checker"""
    _, ext = os.path.splitext(string)
    return checker(ext)


def has_python_source_extension(string):
    """Whether the string has an extension for a file with python source"""
    return _has_checked_extension(string, is_python_source_extension)


def has_python_doctest_extension(string):
    """Whether the string has an extension for a file with python doctests"""
    return _has_checked_extension(string, is_python_doctest_extension)


def has_possible_test_extension(string):
    """Whether the string has a possible test extension"""
    return _has_checked_extension(string, is_possible_test_extension)


def has_positive_test_extension(string):
    """Whether the string has a possible test extension"""
    return _has_checked_extension(string, is_positive_test_extension)


def _positive_test_globs():
    """A glob for each of the _positive test extensions"""
    return [str('*%s' % ext) for ext in positive_test_extensions()]


def has_doctests(string):
    """Whether the string contains doctests

    This method actually checks for presence of the classic "    >>> " prefix

    >>> has_doctests('    >>> print True')
    True
    >>> has_doctests('not space    >>> print True')
    False
    """
    doctest_regexp = re.compile('^\s*>>>\s', re.MULTILINE)
    return bool(doctest_regexp.search(string))


def all_possible_test_files_in(path_to_root, recursive):
    """A list of all possibel test files in the given root

    If recursive is True then include sub-directories
    """
    find_files = recursive and path_to_root.walkfiles or path_to_root.files
    result = []
    for glob in _positive_test_globs():
        result.extend(find_files(glob))
    for path_to_file in find_files():
        if '.git' in path_to_file or path_to_file.basename()[0] == '.':
            continue
        if path_to_file.ext in ('.swp', '.swo'):
            continue
        try:
            if not path_to_file.ext and _first_line_is_python_shebang(path_to_file.lines()):
                result.append(path_to_file)
        except UnicodeDecodeError as e:
            raise ValueError('%s - %s' % (path_to_file, repr(e)))
    return result


def _get_scripts_here(recursive):
    """Find all test scripts in the current working directory"""
    here = path('.')
    result = []
    for python_file in all_possible_test_files_in(here, recursive):
        if has_python_source_extension(python_file):
            text = python_file.text()
            if has_doctests(text):
                result.append(python_file)
        else:
            result.append(python_file)
    return result


def _expand_stems(path_stems):
    """Extend the list of path stems with all test-extensions"""
    result = []
    for path_stem in path_stems:
        if path_stem.isfile():
            result.append(path_stem)
        else:
            result.extend(_existing_test_extensions(path_stem))
    if not result:
        path_stem = path_stems.pop()
        display_stem = path_stem.short_relative_path_from_here()
        raise UserMessage('%s.test*, %s.py not found' % (display_stem, display_stem))
    return result


def _get_files_from_stems(strings, recursive):
    """Get a list of test scripts from the given strings

    Only known extensions are included
    If recursive is true then include sub_directories
    """
    path_stems = _get_path_stems(strings, recursive)
    if path_stems:
        return _expand_stems(path_stems)
    return _get_scripts_here(recursive)


def _first_line_is_python_shebang(lines):
    """Whether the first line of that script looks like

    #! ...python...
    """
    if not lines:
        return False
    first_line = lines[0]
    return bool(re.match('#!.*python.*', first_line))


def _re_order_scripts(paths_to_scripts):
    """Re order the list of scripts so that their extensions are in order

    The order to be used is same as the extensions of possible_test_extensions()
        which goes from more testy to more doccy
    """
    result = []
    for extension in possible_test_extensions():
        extension_paths = [p for p in paths_to_scripts if p.ext == extension]
        result.extend(extension_paths)
    return result


def paths_to_doctests(strings, recursive):
    """Get paths to all doctest files for the given strings

    strings should be a list of stems - possibly empty
        A "stem" is the start of a path, e.g. "test_files."

    If recursive is True then include sub_directories
    """
    paths_to_files = _get_files_from_stems(strings, recursive)
    paths_to_positive_scripts = [p for p in paths_to_files if p.ext in positive_test_extensions()]
    for path_to_script in paths_to_files:
        if path_to_script.ext:
            continue
        if not _first_line_is_python_shebang(path_to_script.lines()):
            continue
        paths_to_positive_scripts.append(path_to_script)
    return _re_order_scripts(paths_to_positive_scripts)


def handle_command_line():
    """Find options and arguments on the command line"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        'stems', type=str, nargs='*', help='filename stems')
    parser.add_argument(
        '-r', '--recursive', action='store_true', help='Look in sub-directories')
    args = parser.parse_args()
    stems = args.stems if args.stems else [os.path.dirname(__file__)]
    return stems, args.recursiive


def main():
    """Run the progam"""
    stems, recursive = handle_command_line()
    try:
        scripts = paths_to_doctests(stems, recursive)
    except UserMessage as e:
        print(e, file=sys.stderr)
        return 1
    print('\n'.join(scripts))
    return 0


if __name__ == '__main__':
    sys.exit(main())
