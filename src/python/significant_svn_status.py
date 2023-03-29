"""Get the svn status of a directory recursively

Stop on first changed item
"""

from __future__ import print_function
import os
import sys


try:
    from repositories.svn import get_significant_status
except ImportError:

    def get_significant_status(_):
        return False


def main(args):
    for arg in args:
        if get_significant_status(arg):
            return os.EX_OK
    return not os.EX_OK


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
