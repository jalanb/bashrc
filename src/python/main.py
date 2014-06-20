"""Script to act as a template"""

import os
import sys


def main(args):
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
