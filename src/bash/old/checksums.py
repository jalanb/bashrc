#! /usr/bin/env python
"""Script to see if some standard files have changed

A 'change' is any change to size, mtime or md5sum
"""

from __future__ import print_function
import os
import csv
import hashlib
import sys
import argparse
from datetime import datetime

from bdb import BdbQuit
from pysyte.types.paths import home

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


def parse_args(methods):
    """Parse out command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
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
    return os.path.expanduser('~/jab') / 'local/login_sums.csv'


def write_files(items, path):
    """Write items to csv file"""
    with path.open('wb') as stream:
        writer = csv.writer(stream)
        for k, v in items.iteritems():
            if not v:
                continue
            row = [k] + v.strings()
            writer.writerow(row)


def default_values():
    """Gives a dict of default values for the default basenames"""
    return pad_keys({}, default_basenames())


def write_default_values():
    """Write default values to the data file"""
    values = default_values()
    write_files(values, path_to_data())
    return values


def read_old_values(basenames):
    """Read old date, size and md5sum for those basenames"""
    result = {}
    with path_to_data().open() as stream:
        reader = csv.reader(stream)
        for row in reader:
            result[row[0]] = Signature(*row[1:])
    return pad_keys(result, basenames)


def old_values(basenames):
    """Read old date, size and md5sum for those basenames

    If old values are not present, write defaults
    """
    p = path_to_data()
    if not p.isfile():
        if not p.parent.isdir():
            p.parent.makedirs_p()
        return write_default_values()
    else:
        return read_old_values(basenames)


def new_values(basenames):
    """Get date, size and md5sum for those basenames in $HOME"""
    result = {}
    for basename in basenames:
        p = home() / basename
        if not p.isfile():
            continue
        size = '%d' % p.size
        mtime = '%0.8f' % p.mtime
        m = hashlib.md5()
        m.update(p.text())
        result[basename] = Signature(mtime, size, m.hexdigest())
    return pad_keys(result, basenames)


def default_basenames():
    return [
        '.bashrc',
        '.vimrc',
        '.gitconfig',
        '.netrc',
        '.profile',
    ]


def script(_args):
    """Compare date, size and md5sum for known files in $HOME"""
    basenames = default_basenames()
    old = old_values(basenames)
    new = new_values(basenames)
    result = True
    for basename in basenames:
        if old[basename] == new[basename]:
            continue
        if old[basename]:
            print('%s changed:' % basename)
            print('\tOld: %s' % old[basename])
            print('\tNew: %s' % new[basename])
        else:
            print('%s registered:' % basename)
            print('\tNew: %s' % new[basename])
        result = False
    if not result:
        print('')
        write_files(new, path_to_data())
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
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
