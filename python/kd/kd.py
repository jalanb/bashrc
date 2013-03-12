"""Script to find a directory to cd to

It gets a close match to a directory from command line arguments
	Then prints that to stdout
	which allows a usage in bash like
		$ cd $(python kd.py /usr local bin)
	or
		$ cd $(python kd.py /bin/ls)

First argument is a directory
	subsequent arguments are prefixes of sub-directories
	For example:
		$ python kd.py /usr/local bi
		/usr/local/bin

Or first argument is a file
	$ python kd.py /bin/ls
	/bin

Or first argument is a stem of a directory/file
	kd.py will add * on to such a stem,
	and will always find directories first,
		looking for files only if there are no such directories
	$ python kd.py /bin/l
	/bin

If nothing matches then give directories in $PATH which have matching executables
	$ python kd.py ls
	/bin
"""


import os
import sys
from fnmatch import fnmatch
from optparse import OptionParser


class ToDo(NotImplementedError):
	"""Errors raised by this script"""
	pass


def names_in_directory(path_to_directory):
	"""Get all items in the given directory

	Swallow errors to give an empty list
	"""
	try:
		return os.listdir(path_to_directory)
	except OSError:
		return []


def make_needed(pattern, path_to_directory, wanted):
	"""Make a method to check if an item matches the pattern, and is wanted

	If wanted is None just check the pattern
	"""
	if wanted:
		return lambda name: fnmatch(name, pattern) and wanted(os.path.join(path_to_directory, name))
	else:
		return lambda name: fnmatch(name, pattern)


def contains_glob(path_to_directory, pattern, wanted=None):
	"""Whether the given directory contains an item which matches the given (glob) pattern"""
	if not path_to_directory:
		return False
	needed = make_needed(pattern, path_to_directory, wanted)
	for name in names_in_directory(path_to_directory):
		if needed(name):
			return True
	return False


def list_items(path_to_directory, pattern, wanted):
	"""A list of all items in the given directory which match the given (glob) pattern and are wanted"""
	if not path_to_directory:
		return []
	needed = make_needed(pattern, path_to_directory, wanted)
	return [os.path.join(path_to_directory, name) for name in names_in_directory(path_to_directory) if needed(name)]


def contains_directory(path_to_directory, pattern):
	"""Whether the given directory contains a directory which matches the given (glob) pattern"""
	return contains_glob(path_to_directory, pattern, os.path.isdir)


def contains_file(path_to_directory, pattern):
	"""Whether the given directory contains a file which matches the given (glob) pattern"""
	return contains_glob(path_to_directory, pattern, os.path.isfile)


def list_sub_directories(path_to_directory, pattern):
	"""A list of all sub-directories of the given directory which match the given (glob) pattern"""
	return list_items(path_to_directory, pattern, os.path.isdir)


def list_files(path_to_directory, pattern):
	"""A list of all files in the given directory which match the given (glob) pattern"""
	return list_items(path_to_directory, pattern, os.path.isfile)


def matching_sub_directories(path_to_directory, prefix):
	"""A list of all sub-directories named with the given prefix

	If the prefix ends with "/" then look for an exact match only
	Otherwise look for "prefix*"
		If that gives one exact match, prefer that
	"""
	prefix_glob = prefix.endswith('/') and prefix.rstrip('/') or '%s*' % prefix
	sub_directories = list_sub_directories(path_to_directory, prefix_glob)
	if len(sub_directories) < 2:
		return sub_directories
	exacts = [directory for directory in sub_directories if os.path.basename(directory) == prefix]
	if exacts:
		return exacts
	return sub_directories

def look_under_directory(path_to_directory, prefixes):
	"""Look under the given directory for matching sub-directories

	Sub-directories match if they are prefixed with given prefixes
	If no sub-directories match, but a file matches
		then use the directory
	"""
	if not prefixes:
		return [path_to_directory]
	prefix, prefixes = prefixes[0], prefixes[1:]
	result = []
	for path_to_sub_directory in matching_sub_directories(path_to_directory, prefix):
		paths = look_under_directory(path_to_sub_directory, prefixes)
		result.extend(paths)
	if not result and contains_file(path_to_directory, '%s*' % prefix):
		result = [path_to_directory]
	return result


def find_under_directory(path_to_directory, prefixes):
	"""Find one directory under path_to_directory, matching prefixes

	Try any prefixed sub-directories
		then any prefixed files

	Can give None (no matches), or the match, or an Exception
	"""
	possibles = look_under_directory(path_to_directory, prefixes)
	if not possibles:
		return None
	if len(possibles) == 1:
		return possibles[0]
	raise ToDo('Too many possiblities\n\t%s' % '\n\t'.join(possibles))


def find_under_here(prefixes):
	"""Look for some other directories under current directory """
	here = os.getcwd()
	return find_under_directory(here, prefixes)


def find_in_environment_path(filename):
	"""Return the first directory in $PATH which contains a file called filename

	This is equivalent to "which" command for executable files
	"""
	if not filename:
		return None
	for path_to_directory in os.environ['PATH'].split(':'):
		if not path_to_directory:
			continue
		path_to_file = os.path.join(path_to_directory, filename)
		if os.path.isfile(path_to_file):
			return path_to_directory
	return None


def find_at_home(item, prefixes):
	"""Return the first directory under the home directory which matches the item

	Match on sub-directories first, then files
		Might return home directory itself

	>>> print find_at_home('bin', [])
	/.../bin
	"""
	home = os.path.expanduser('~')
	if item in prefixes:
		return find_under_directory(home, prefixes)
	return find_under_directory(home, [item] + prefixes)


def find_path_to_item(item):
	"""Find the path to the given item

	Either the directory itself, or directory of the file itself, or nothing
	"""
	if item.endswith('/'):
		if len(item) > 1:
			item = item.rstrip('/')
		return item
	if os.path.isdir(item):
		return item
	parent = os.path.dirname(item)
	if os.path.isfile(item):
		return parent
	pattern = '%s*' % os.path.basename(item)
	if contains_glob(parent, pattern):
		return parent
	return None


def previous_directory():
	"""Where we were (in bash) before this directory"""
	try:
		return os.environ['OLDPWD']
	except KeyError:
		return '~'
	return None


def find_directory(item, prefixes):
	"""Find a relevant directory relative to the item, and using prefixes (if given)

	item can be
		empty (use home directory)
		"-" (use $OLDPWD)

	Return item if it is a directory,
		or its parent if it is a file
		or one of its sub-directories (if they match prefixes)
		or a directory in $PATH
	Otherwise look for prefixes as a partial match
	"""
	path_to_item = find_path_to_item(item)
	if path_to_item:
		if not prefixes:
			return path_to_item
		path_to_prefix = find_under_directory(path_to_item, prefixes)
		if path_to_prefix:
			return path_to_prefix
	else:
		if item:
			prefixes.insert(0, item)
		if prefixes:
			path_to_item = find_under_here(prefixes)
	if path_to_item:
		return path_to_item
	path_to_item = find_in_environment_path(item)
	if path_to_item:
		return path_to_item
	path_to_item = find_at_home(item, prefixes)
	if path_to_item:
		return path_to_item
	raise ToDo('could not use %r as a directory' % item)


def parse_command_line():
	"""Get the arguments from the command line. Insist on at least one empty string"""
	usage = '''usage: %%prog directory prefix ...

	%s''' % __doc__
	parser = OptionParser(usage)
	parser.add_option('-t', '--test', dest='test', action="store_true", help='test the script')
	options, args = parser.parse_args()
	if not args:
		item, prefixes = os.path.expanduser('~'), []
	else:
		item, prefixes = args[0], args[1:]
		if args[0] == '-':
			item = previous_directory()
		args[0] = previous_directory()
	return options, item, prefixes


def test():
	"""Run all doctests based on this file

	Tell any bash-runners not to use any output by saying "Error" first

	>>> 'kd' in __file__
	True
	"""
	stem, _ext = os.path.splitext(__file__)
	stem = os.path.basename(stem)
	from doctest import testfile, testmod, ELLIPSIS
	result = testfile('%s.tests' % stem, optionflags=ELLIPSIS)
	if result.failed:
		return
	result = testfile('%s.test' % stem, optionflags=ELLIPSIS)
	if result.failed:
		return
	result = testmod()
	if result.failed:
		return
	print 'All tests passed'



def show_path_to_item(item, prefixes):
	"""Get a path for the given item and show it

	>>> show_path_to_item('/', ['us', 'lo'])
	/usr/local
	"""
	path_to_item = find_directory(item, prefixes)
	if path_to_item:
		print str(path_to_item)


def main():
	"""Show a directory from the command line arguments (or some derivative)"""
	try:
		options, item, prefixes = parse_command_line()
		if not options:
			return 1
		if options.test:
			test()
			return 1
		show_path_to_item(item, prefixes)
		return 0
	except ToDo, e:
		print 'Error:', e
		return 1
	except SystemExit:
		return 1


if __name__ == '__main__':
	sys.exit(main())
