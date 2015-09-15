#! /usr/bin/env python2
"""Script to see if some standard files have changed

A 'change' is any change to size, mtime or md5sum
"""

from __future__ import print_function
import os
import csv
import md5
import sys
import argparse
from datetime import datetime

from bdb import BdbQuit
from dotsite import paths

__version__ = '1.0.0'


def run_args(args, methods):
    """Run any methods eponymous with args"""
    if not args:
        return False
    valuable_args = {k for k, v in args.__dict__.items() if v}
    arg_methods = {methods[a] for a in valuable_args if a in methods}
    for method in arg_methods:
        method(args)


def version(args):
    print('%s %s' % (args, __version__))
    raise SystemExit


def Use_debugger(_args):
    try:
        import pudb as pdb
    except ImportError:
        import pdb
    pdb.set_trace()


def parse_args(methods):
    """Parse out command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
    parser.add_argument('-U', '--Use_debugger', action='store_true',
                        help='Run the script with pdb (or pudb if available)')
    args = parser.parse_args()
    run_args(args, methods)
    return args


def plastic_date():
    """Looks like a date, quacks like a date. Not a date"""
    return 'Zun, 99 Zun 9999 99:61:61'


class Signature(object):
    """Identifying details for a file

    Includes time, size and md5sum
    """
    def __init__(self, t, z, s):
        self._time = t
        self._size = z
        self._sum = s

    def __str__(self):
        return ', '.join([self._time_str(), str(self._size)])

    def __nonzero__(self):
        return bool(self._time) or self._size > -1 or bool(self._sum)

    def __cmp__(self, other):
        return cmp(self.strings(), other.strings())

    def _time_str(self):
        """A formatted string for the time"""
        try:
            if not self._time:
                raise ValueError
            format_ = '%a, %d %b %Y %H:%M:%S'
            return datetime.fromtimestamp(float(self._time)).strftime(format_)
        except ValueError:
            return plastic_date()

    def strings(self):
        """A list of time, size and sum as strings"""
        return [str(self._time), str(self._size), str(self._sum)]


class EmptySignature(Signature):
    def __init__(self):
        super(EmptySignature, self).__init__(0, -1, '')


def pad_keys(items, keys):
    """Make sure all keys are in items

    If any key is missing add an empty signature"""
    for key in keys:
        if key not in items:
            items[key] = EmptySignature()
    return items


def path_to_data():
    """Where we store old values"""
    return paths.environ_path('JAB') / 'local/login_sums.csv'


def write_files(items):
    """Write items to csv file"""
    with path_to_data().open('wb') as stream:
        writer = csv.writer(stream)
        for k, v in items.iteritems():
            if not v:
                continue
            row = [k] + v.strings()
            writer.writerow(row)


def old_values(basenames):
    """Read old date, size and md5sum for those basenames"""
    result = {}
    with path_to_data().open() as stream:
        reader = csv.reader(stream)
        for row in reader:
            result[row[0]] = Signature(*row[1:])
    return pad_keys(result, basenames)


def new_values(basenames):
    """Get date, size and md5sum for those basenames in $HOME"""
    result = {}
    for basename in basenames:
        p = paths.home() / basename
        if not p.isfile():
            continue
        size = '%d' % p.size
        mtime = '%0.8f' % p.mtime
        m = md5.new()
        m.update(p.text())
        result[basename] = Signature(mtime, size, m.hexdigest())
    return pad_keys(result, basenames)


def script(args):
    """Compare date, size and md5sum for known files in $HOME"""
    basenames = [
        '.bashrc',
        '.vimrc',
        '.gitconfig',
        '.netrc',
        '.profile',
    ]
    old = old_values(basenames)
    new = new_values(basenames)
    result = True
    for basename in basenames:
        if old[basename] == new[basename]:
            continue
        print('%s changed:' % basename)
        print('\tOld: %s' % old[basename])
        print('\tNew: %s' % new[basename])
        result = False
    if not result:
        print('')
        write_files(new)
    return result


def main():
    """Run the script"""
    try:
        args = parse_args(globals())
        return os.EX_OK if script(args) else not os.EX_OK
    except BdbQuit:
        pass
    except SystemExit as e:
        return e.code
    except Exception, e:  # pylint: disable=broad-except
        if __version__[0] < '1':
            raise
        print(e, sys.stderr)
        return not os.EX_OK
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
