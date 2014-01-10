"""Script to display a collection of paths after inserting one new path

Usage:
	add_to_a_path.py [-U] PATHS PATH
	add_to_a_path.py [-U] (-s | -i INDEX ) PATHS PATH

Options:
	-h, --help               Show this help and exit
	-v, --version            Show version number and exit
	-U, --use_debugger       Run the script with pudb debugger
	-s, --start              Add the path at start of list of paths
	-i INDEX, --index=INDEX  Specify the index at which the path will be inserted


Examples of use:
	$ export PATH=/bin:/usr/bin

	$ add_to_a_path.py PATH /usr/local/bin
	/bin:/usr/bin:/usr/local/bin

	$ add_to_a_path.py PATH /usr/local/bin --start
	/usr/local/bin:/bin:/usr/bin


	$ add_to_a_path.py $PATH /usr/local/bin --index=1
	/bin:/usr/local/bin:/usr/bin

	$ add_to_a_path.py $PATH /not/a/real/path
	/bin:/usr/bin

"""


import os
import sys
import docopt


__version__ = '0.1.0'


def add_path_to_paths(paths, path, i):
	if i is False:
		i = len(paths)
	result = paths[:]
	if path and path not in result:
		result.insert(i, path)
	return result


def arg_path(args):
	path = args['PATH']
	if not path:
		return None
	user_path = os.path.expanduser(path)
	real_path = os.path.realpath(user_path)
	if not os.path.isdir(real_path):
		return None
	return real_path


def split_paths(string):
	return [p for p in string.split(os.path.pathsep) if p]



def get_paths(args):
	path_string = args['PATHS']
	if os.path.pathsep not in path_string and path_string in os.environ:
		return os.environ[path_string]
	return path_string


def add_path_to_path_string(args):
	path = arg_path(args)
	path_string = get_paths(args)
	if not path:
		return path_string
	paths = []
	index = args['--index']
	paths = split_paths(path_string)
	if os.path.isdir(path):
		paths = add_path_to_paths(paths, path, index)
	return os.path.pathsep.join(paths)


def parse_args():
	args = docopt.docopt(__doc__, version = __version__)
	if args.get('--use_debugger', False):
		try:
			import pudb as pdb
		except ImportError:
			import pdb
		pdb.set_trace()
	index = args.get('--index', '')
	if not index:
		if args['--start']:
			i = 0
		else:
			i = False
	else:
		if args['--start']:
			i = 0
		else:
			try:
				i = int(index)
			except ValueError:
				raise UsageError('--index should use a number, not %r' % index)
	args['--index'] = i
	return args


def main():
	args = parse_args()
	print add_path_to_path_string(args)

if __name__ == '__main__':
	main()
