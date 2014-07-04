#! /usr/bin/env python2
"""Script to act as a template"""

import os
import sys


def main(_args):
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
