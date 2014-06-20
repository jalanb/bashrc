"""Facilities for handling pylint"""


import os
import sys


from sh import pylint  # pylint: disable=no-name-in-module


def name(number):
    """Convert a pylint nuber to a name

    >>> print name('E0611')
    no-name-in-module
    """
    number_line = [l for l in pylint('--help-msg', number) if number in l][0]
    return number_line.split(':')[1].split()[0]


def disable(number):
    """A comment to diable that pylint error number

    >>> print disable('E0611')
    # pylint: disable=no-name-in-module
    """
    return '  # pylint: disable=%s' % name(number)


def main(args):
    if len(args) == 1:
        print disable(args[0])
    else:
        for arg in args:
            print arg
            print disable(arg)
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
