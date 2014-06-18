"""Script to make a vim command from a traceback line"""


import os
import sys


def main(args):
    if len(args) == 1:
        args = args[0].split()
    _, path, _, line = args[:4]
    print 'vim %s +%s' % (path.rstrip(',').strip('"'), line.rstrip(','))
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
