"""Methods to colour files by same rules as ls"""


import os
import re
from fnmatch import fnmatch


from dotsite.decorators import memoize
import ansi_escapes


def _is_extension_glob(string):
    if not string:
        return False
    recogniser = re.compile('\*\.[^ ]+')
    try:
        return recogniser.match(string) is not None
    except TypeError:
        raise TypeError(repr(string))


@memoize
def load_ls_colours():
    """Load values from env's $LS_COLORS"""
    ls_colors = os.environ.get('LS_COLORS', '')
    ls_colour_list = ls_colors.split(':')
    ls_colour_values = [
        ls_colour.split('=') for ls_colour in ls_colour_list if ls_colour]
    ext_colours = {}
    glob_colours = set()
    for glob, colour in ls_colour_values:
        if _is_extension_glob(glob):
            ext_colours[glob[1:]] = colour
        else:
            glob_colours.add((glob, colour))
    return ext_colours, glob_colours


def _get_file_colour(filename):
    """Get the relevant colour for that file

    Try file extension first
        then try any other globs we know
    """
    ext_colours, glob_colours = load_ls_colours()
    _, ext = os.path.splitext(filename)
    try:
        return ext_colours[ext]
    except KeyError:
        for glob, colour in glob_colours:
            if fnmatch(glob, os.path.basename(filename)):
                return colour
    return None


def _get_extension_colour(ext):
    if not ext:
        return ''
    ext = ext[0] == '.' and ext or str('.%s' % ext)
    ext_colours, _ = load_ls_colours()
    return ext_colours.get(ext, None)


def _colourize(string, getter):
    colour = getter(string)
    escape_string = ansi_escapes.escape_sequence(colour)
    return '%s%s%s' % (escape_string, string, ansi_escapes.no_colour())


def colourize_file(filename):
    return _colourize(filename, _get_file_colour)


def colourize_extension(ext):
    return _colourize(ext, _get_extension_colour)
