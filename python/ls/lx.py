"""Program to list extensions in given directories"""


import sys
import collections


import argv
import l
import lout



class ListAccumulator(collections.defaultdict):
	def __init__(self):
		collections.defaultdict.__init__(self, lambda: [])

	def append(self, key, value):
		values = self[key]
		values.append(value)
		self[key] = values

def hidden_extension(path_to_file):
	"""Return the extension for that file

	If the file startswith '.', just use '.'

	>>> from path import path
	>>> hidden_extension(path(__file__)) in ['.py', '.pyc']
	True
	>>> hidden_extension(path('.bashrc')) == '.'
	True
	"""
	if path_to_file.name.startswith('.'):
		return '.'
	return path_to_file.ext


def get_exts(paths_to_files):
	"""Collect those paths into a dictionary, keyed by extension

	>>> from path import path
	>>> exts = get_exts([path('one.py'), path('one.pyc'), path('two.py')])
	>>> exts['.py'] == [path('one.py'), path('two.py')]
	True
	>>> exts['.pyc'] == [path('one.pyc')]
	True
	"""
	exts = ListAccumulator()
	for path_to_file in paths_to_files:
		exts.append(hidden_extension(path_to_file), path_to_file)
	return exts


def main():
	argv.parse_args()
	dirs = l.get_dirs(argv.args)
	lout.show_dirs(dirs)
	exts = get_exts(l.get_files(dirs))
	if exts:
		lout.show(exts)
	return 0


if __name__ == '__main__':
	sys.exit(main())
