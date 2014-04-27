#! /usr/bin/env python

"""
ptags

Adapted from ptags.py in the python distribution

Create a tags file for Python programs, usable with vi.
Tagged are:
    functions (even inside other defs or classes)
    classes
    filenames
    Warns about files it cannot open.
    No warnings about duplicate tags.
--
I am targeting vim, so
    the tags file format to use is specified here:
    http://ctags.sourceforge.net/ctags.html#TAG%20FILE%20FORMAT
"""

import sys
import re

import argv
argv.add_options([
    ('verbose', 'Report disk changes', False),
    ('recursive', 'Recurse into sub-directories', False)
])

from dotsite.paths import makepath, pwd, home
from repositories import svn


def def_or_class_regexp():
    """A regular expression to recognise a def/class statement in a Python line"""
    return re.compile('''
        (?P<address>
            ^[ \t]*
            (?P<type>def|class)
            [ \t]+
            (?P<name>[_a-zA-Z]([a-zA-Z0-9][a-zA-Z0-9_]*))
            [ \t]*
            [:\(]
        )
    ''', re.VERBOSE)


def find_tag_in_line(path_to_tag, string):
    """Try to match a def or class statement in the line"""
    match = def_or_class_regexp().match(string)
    if not match:
        return {}
    return Tag(path_to_tag, match.groupdict())


class Tag:
    """A tag recognised by ctags"""
    # pylint: disable-msg=R0903

    def __init__(self, path, matches):
        self.name = ''
        self.__dict__.update(matches)
        self.path = path
        self.address = re.sub('[ \t]+', ' +', '/^%s/' % self.address)
        if not self.name:
            self.name = ''

    def __str__(self):
        return '\t'.join([self.name, self.path, self.address])

    def __repr__(self):
        return '<Tag "%s">' % self.name

    def __cmp__(self, other):
        return cmp(str(self), str(other))

    def address_pattern(self):
        """The pattern in the address"""
        return self.address[2:-1]

    def split_address_pattern(self):
        """First two chars and rest of the address pattern"""
        pattern = self.address_pattern()
        return pattern[:2], pattern[2:]

class FileTag(Tag):
    """A tag which include a file path"""
    # pylint: disable-msg=R0903

    def __init__(self, path):
        try:
            self.name = path.namebase
        except AttributeError:
            path = makepath(path)
        Tag.__init__(self, path, {'address':'1'})
        self.name = path.namebase
        self.address = '1'

    def __repr__(self):
        return '<FileTag "%s">' % self.name


def more_likely_of(old, new):
    """Find the more likely of the two tags"""
    if old.path == new.path:
        if isinstance(old, FileTag):
            return None, new
        if old.address == new.address:
            return None, new
        if new.split_address_pattern() == (' +', old.address_pattern()):
            new.name = '.%s' % new.name
            return old, new
        if old.split_address_pattern() == (' +', new.address_pattern()):
            old.name = '.%s' % old.name
            return old, new
        if ('+class' in new.address and '+def' in old.address) or ('+class' in old.address and '+def' in new.address):
            return old, new
        return old, new
        #raise ValueError('%s\n%s\n\t"%s" != "%s"' % (old.path, new.path, old.address , new.address))
    raise NotImplementedError('\n\t%r\n\t%r' % (old.path, new.path))


def read_file(path_to_python):
    """Read a python file and generate tags thence"""
    previous_tag = FileTag(path_to_python)
    tags = [ previous_tag ]
    problems = []
    for line in previous_tag.path.lines():
        if not line:
            continue
        tag = find_tag_in_line(previous_tag.path, line)
        if not tag:
            continue
        want_t = None
        for previous_tag in tags:
            if previous_tag.name == tag.name:
                try:
                    want_t, tag = more_likely_of(previous_tag, tag)
                except ValueError, e:
                    problems.append( str(e) )
                break
        else:
            tags.append( tag )
            continue
        if not want_t:
            tags.remove(previous_tag)
        tags.append( tag )
    if problems:
        raise ValueError('\n'.join(problems))
    return tags


def read_dir(path_to_directory):
    """Read tags for all python files in the given directory"""
    tags = []
    for path_to_python in path_to_directory.files('*.py'):
        for tag in read_file(path_to_python):
            tags.append( tag )
    return tags


def read_dirs(path_to_directory=None):
    """Read tags for all python files in the given directory, and recursively under it"""
    if not path_to_directory:
        path_to_directory = pwd()
    tags = read_dir(path_to_directory)
    for path_to_sub_directory in path_to_directory.walkdirs():
        if svn.is_svn_path(path_to_sub_directory):
            continue
        tags += read_dir(path_to_sub_directory)
    return tags


def tags_to_text(tags):
    """Return a text of sorted tags"""
    str_tags = [ str(t) for t in tags ]
    sorted_tags = sorted(str_tags)
    return '\n'.join(sorted_tags)


def write_dir(path_to_directory, tags):
    """Write the given tags to a tags file in the given directory"""
    out = makepath('%s/tags' % path_to_directory)
    if out.isdir():
        message = 'Wrote no tags to %s' % out
    else:
        text = tags_to_text(tags)
        out.write_text(text)
        message = 'Wrote tags to %s' % out
    if argv.options.verbose:
        print message


def read_write_dir(path_to_directory=None):
    """Read tags from the files in the given directory, and write a tags file"""
    if not path_to_directory:
        if argv.directories:
            [read_write_dir(d) for d in argv.directories]
        else:
            path_to_directory = pwd()
    tags = read_dir(path_to_directory)
    write_dir(path_to_directory, tags)


def read_write_dirs(path_to_directory=None):
    """Read tags from the files in the given directory (and recursively under it), and write a tags file"""
    if not path_to_directory:
        if argv.directories:
            [read_write_dirs(d) for d in argv.directories]
        else:
            path_to_directory = pwd()
    tags = read_dirs(path_to_directory)
    write_dir(path_to_directory, tags)
    for path_to_sub_directory in path_to_directory.walkdirs():
        if svn.is_svn_path(path_to_sub_directory):
            continue
        tags = read_dirs(path_to_sub_directory)
        write_dir(path_to_sub_directory, tags)


def read_sys_dirs():
    """Read tags for each path in sys.path"""
    tags = []
    for path_to_system in sys.path:
        tags += read_dir(makepath(path_to_system))
    return tags


def all_directories_in_a_list_of_tags(tags):
    """Get a sorted list of all the directories mentioned in the given list of tags"""
    return sorted(list(set([home().relpathto(t.path.parent) for t in tags])))


def main():
    """Run the program"""
    argv.parse_args()
    if argv.options.recursive:
        read_write_dirs()
    else:
        read_write_dir()


if __name__ == '__main__':
    argv.main(main, ctrl_c=True)
