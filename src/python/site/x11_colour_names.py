"""Methods to provide names for X11 colour names

If there is an "rgb.txt" file in a known directory get names from that
    otherwise fall back on the standard 8 names (BRGBCYMW)

The rgb.txt file is expected to contain X11 colour names
    so the "known directory" is <X11root>/lib/X11/
        Some variations on that official path are also tried
    For a non-standard path, call use_rgb_txt()
    See http://en.wikipedia.org/wiki/X11_color_names
"""


import os
import re


def _rgb_txt_directories():
    return [
        '/usr/lib/X11',
        '/usr/X11/share/X11',
        '.',
        os.path.dirname(__file__),
    ]


def use_rgb_txt(path_to_rgb_txt):
    if not os.path.isfile(path_to_rgb_txt):
        return False
    def new_method():
        return [path_to_rgb_txt]
    # Yes, we are "Redefining name '_rgb_txt_directories' from outer scope"
    # pylint: disable-msg=W0621
    _rgb_txt_directories = new_method
    if hasattr(_rgb_txt_names_and_numbers, 'result'):
        delattr(_rgb_txt_names_and_numbers, 'result')
    return True


def first_rgb_file(rgb_txt_paths):
    for path in rgb_txt_paths():
        path_to_txt_file = os.path.join(path, 'rgb.txt')
        if os.path.isfile(path_to_txt_file):
            return path_to_txt_file
    return None


def _rgb_txt_line(string):
    regexp = re.compile('([ 0-9][ 0-9][ 0-9])\s+([ 0-9][ 0-9][ 0-9])\s+([ 0-9][ 0-9][ 0-9])\s+([a-zA-Z0-9 ]+)\s*')
    match = regexp.match(string)
    if not match:
        return '', None
    red, green, blue, name = match.groups()
    return name.strip(), (int(red), int(green), int(blue))


def _rgb_txt_names_and_numbers(path_to_file):
    if not hasattr(_rgb_txt_names_and_numbers, 'result'):
        rgb_lines = [_rgb_txt_line(l) for l in file(path_to_file)]
        _rgb_txt_names_and_numbers.result = [(name, values) for name, values in rgb_lines if name]
    return _rgb_txt_names_and_numbers.result


def _local_rgb_txt_names_and_numbers():
    path_to_rgb_txt = first_rgb_file(_rgb_txt_directories)
    return _rgb_txt_names_and_numbers(path_to_rgb_txt)


def known_colour_names_and_numbers():
    known_names = 'black red green yellow blue magenta cyan white'
    dark_names_and_numbers = [(name, number) for number, name  in enumerate(known_names.split())]
    light_names_and_numbers = [('light %s' % name, number + 8) for name, number in dark_names_and_numbers]
    return dark_names_and_numbers + light_names_and_numbers


def names():
    names_and_numbers = _local_rgb_txt_names_and_numbers()
    if not names_and_numbers:
        names_and_numbers = known_colour_names_and_numbers()
    return dict(names_and_numbers)


