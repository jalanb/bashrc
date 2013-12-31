"""Get the svn status of a directory recursively

Stop on first changed item
"""

import os
import sys


from repositories.svn import get_significant_status


def main(args):
	for arg in args:
		if get_significant_status(arg):
			return os.EX_OK
	return not os.EX_OK

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))
