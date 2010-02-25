import os
import sys
from fail_file import read_fail_file

def main(args):
	for arg in args:
		if os.path.isfile(arg):
			fail_file = read_fail_file(arg)
			if fail_file:
				fail_file.fix()
				print fail_file.filename
	return 0

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))
