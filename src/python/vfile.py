"""Script to make a vim command from a traceback line"""


import os
import sys


import vim_traceback


def main(args):
    if len(args) == 1:
        line = args
    else:
        line = ' '.join(args)
    path, line_number = vim_traceback.parse_line(line)
    print 'vim %s +%s' % (path, line_number)
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
