"""Script to find a directory to cd to

Usage: kd [options] [items]

Arguments:
	items are strings which indicate a path to a directory or file
	The first item might be a full path
	Second and other items are used to choose under that path

Options:
	-h	--help	show this help and exit
	-a	--add	add a path to history
	-o	--old	look for paths in history
	-t	--test	run all tests and exit
	-v	--version	show the version and exit
	-U	--pdb	For developers: debugging with pdb (or pudb if available)

Explanation:

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

Or first argument is part of a directory that kd has seen before
	"part of" means the name or
	the start of the name or
	the name of a parent or
	the start of a name of a parent
	(or any part of the full path if you include a "/")

If nothing matches then give directories in $PATH which have matching executables
	$ python kd.py ls
	/bin
"""


import os
import sys
from fnmatch import fnmatch
from optparse import OptionParser
import csv


import timings

__version__ = '0.3.3'

class ToDo(NotImplementedError):
	"""Errors raised by this script"""
	pass


class TryAgain(NotImplementedError):
	"""Warnings raised by this script"""
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


def as_menu_items(strings):
	return [str('%2d: %s' % (i, p)) for i, p in enumerate(strings)]


def as_menu_string(strings):
	return '\n\t'.join(as_menu_items(strings))


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
	matched_sub_directories = matching_sub_directories(path_to_directory, prefix)
	if not matched_sub_directories:
		if contains_file(path_to_directory, '%s*' % prefix):
			return [path_to_directory]
		return []
	try:
		i = int(prefixes[0])
	except (ValueError, IndexError):
		i = None
	for path_to_sub_directory in matched_sub_directories:
		paths = look_under_directory(path_to_sub_directory, prefixes)
		result.extend(paths)
	if not result:
		if i is not None:
			try:
				return [matched_sub_directories[i]]
			except IndexError:
				raise ToDo('Your choice of "%s" is not in range:\n\t%s' % (i, as_menu_string(matched_sub_directories)))
		if contains_file(path_to_directory, '%s*' % prefix):
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
	raise TryAgain('Too many possiblities\n\t%s' % as_menu_string(possibles))


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
		or an item in history (if any)
		or a directory under $HOME
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
			args = [item] + prefixes
		else:
			args = prefixes
		if args:
			path_to_item = find_under_here(args)
	if path_to_item:
		return path_to_item
	path_to_item = find_in_environment_path(item)
	if path_to_item:
		return path_to_item
	path_to_item = find_in_history(item, prefixes)
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
	parser.add_option('-a', '--add', dest='add', action="store_true", help='add a path to history')
	parser.add_option('-d', '--delete', dest='delete', action="store_true", help='delete paths from history')
	parser.add_option('-o', '--old', dest='old', action="store_true", help='look for paths in history')
	parser.add_option('-t', '--test', dest='test', action="store_true", help='test the script')
	parser.add_option('-v', '--version', dest='version', action="store_true", help='show version of the script')
	parser.add_option('-U', '--pdb', dest='pdb', action="store_true", help='For developers: debugging with pdb (or pudb if available)')
	options, args = parser.parse_args()
	if options.pdb:
		try:
			import pudb as pdb
		except ImportError:
			import pdb
		pdb.set_trace()
	if not args:
		item = not options.old and os.path.expanduser('~') or None
		prefixes = []
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
	from doctest import testfile, testmod, ELLIPSIS, NORMALIZE_WHITESPACE
	options = ELLIPSIS | NORMALIZE_WHITESPACE
	result = testfile('%s.tests' % stem, optionflags=options)
	if result.failed:
		return
	result = testfile('%s.test' % stem, optionflags=options)
	if result.failed:
		return
	result = testmod(optionflags=options)
	if result.failed:
		return
	print 'All tests passed'


def _path_to_history():
	"""Path to where history of paths is stored"""
	stem, _ext = os.path.splitext(__file__)
	return '%s.history' % stem


def read_history():
	"""Recall a remembered path"""
	csvfile = None
	try:
		try:
			csvfile = open(_path_to_history(), 'rb')
		except IOError:
			return []
		reader = csv.reader(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
		return [row for row in reader]
	finally:
		if csvfile:
			csvfile.close()


def sort_history(history):
	def compare(one, two):
		rank1, path1, time1 = one
		rank2, path2, time2 = two
		diff = cmp(int(rank1), int(rank2))
		if diff:
			return diff
		diff = cmp(float(time2), float(time1))
		if diff:
			return -diff
		return cmp(path1, path2)
	return sorted(history, cmp=compare)


def sorted_history():
	"""A list of history items

	Sorted by ascending rank, descending time
	"""
	history = read_history()
	return sort_history(history)


def frecent_history():
	"""A list of paths from history

	Sorted by descending rank, ascending time
	"""
	return reversed(sorted_history())


def frecent_history_paths():
	"""A list of paths, sorted from history"""
	return [path for _rank, path, _time in frecent_history()]


def increment(string):
	"""Add 1 to the int in that string

	>>> increment('1') == '2'
	True
	"""
	return str(int(string) + 1)


def include_new_path_in_items(history_items, new_path):
	"""Add the given path to the existing history

	Or update it if already present"""
	is_new_path = True
	result = []
	new_time = timings.now()
	for old_rank, old_path, old_time in history_items:
		if new_path == old_path:
			result.append((increment(old_rank), new_path, new_time))
			is_new_path = False
		else:
			result.append((old_rank, old_path, old_time))
	if is_new_path:
		new_rank = 1
		result.append((new_rank, new_path, new_time))
	return sorted(result)


def rewrite_history_with_path(item):
	"""Remember the given path for later use"""
	new_path = os.path.realpath(os.path.expanduser(os.path.expandvars(item)))
	new_path = find_path_to_item(new_path)
	history_items = read_history()
	items = include_new_path_in_items(history_items, new_path)
	write_paths(items)


def write_paths(paths):
	"""Write the given paths to the history file"""
	csvfile = None
	try:
		csvfile = open(_path_to_history(), 'wb')
		writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
		writer.writerows(paths)
	finally:
		if csvfile:
			csvfile.close()


def rewrite_history_without_path(path_to_item):
	"""Delete the given path from the history"""
	history_items = read_history()
	new_items, changed = exclude_path_from_items(history_items, path_to_item)
	if changed:
		write_paths(new_items)

def exclude_path_from_items(history_items, path_to_item):
	new_items = []
	changed = False
	for rank, path, time in history_items:
		if path == path_to_item:
			changed = True
		else:
			new_items.append((rank, path, time))
	return new_items, changed


def list_paths():
	"""Show all paths in history in user-terminology"""
	old_rank = None
	for order, (rank, path, atime) in enumerate(frecent_history()):
		if old_rank != rank:
			print '      %s time%s:' % (rank, int(rank) > 1 and 's' or '')
			old_rank = rank
		print '%3d: %s, %s ago' % (order + 1, path, timings.time_since(atime))


def find_in_history(item, prefixes):
	"""If the given item and prefixes are in the history return that path

	Otherwise None
	"""
	paths = frecent_history_paths()
	try:
		return paths[int(item) - 1]
	except ValueError:
		return _find_in_paths(item, prefixes, paths)


def _find_in_paths(item, prefixes, paths):
	"""Get the first of those paths which meets one of the criteria:

	1. has any substring that macthes (as long as the item contains a "/")
	2. is same as item
	3. has same basename as item
	4. has same basename as "item*"
	5. has a parent with same basename as item
	6. has a parent with same basename as "item*"

	paths are assumed to be ordered, so first path which matches wins
	"""
	def globbed(p):
		return fnmatch(p, '%s*' % item)

	matchers = [
		lambda path: item == path,
		lambda path: item == os.path.basename(path),
		lambda path: globbed(os.path.basename(path)),
		lambda path: item in path.split(os.path.sep),
		lambda path: any([p for p in path.split(os.path.sep) if globbed(p)]),
	]
	if os.path.sep in item:
		matchers.insert(0, lambda path: item in path)
	try:
		i = int(prefixes[0])
	except (ValueError, IndexError):
		i = None
	for match in matchers:
		matched = [path for path in paths if match(path)]
		if not matched:
			continue
		elif len(matched) == 1:
			return matched[0]
		if i is not None:
			try:
				return matched[i]
			except IndexError:
				raise ToDo('Your choice of "%s" is out of range:\n\t%s' % (i, as_menu_string(matched)))
		raise TryAgain('Too many possiblities\n\t%s' % as_menu_string(matched))


def show_path_to_historical_item(item, prefixes):
	"""Get a path for the given item from history and show it"""
	path_to_item = find_in_history(item, prefixes)
	show_found_item(path_to_item)


def delete_path_to_historical_item(item, prefixes):
	"""Get a path for the given item from history and remove it from history"""
	path_to_item = find_in_history(item, prefixes)
	delete_found_item(path_to_item)


def show_path_to_item(item, prefixes):
	"""Get a path for the given item and show it

	>>> show_path_to_item('/', ['us', 'lo'])
	/usr/local
	"""
	path_to_item = find_directory(item, prefixes)
	show_found_item(path_to_item)


def show_found_item(path_to_item):
	"""Show the path to the user, and the history"""
	if path_to_item:
		rewrite_history_with_path(path_to_item)
		print str(path_to_item)


def delete_found_item(path_to_item):
	"""Delete the path from the history"""
	if path_to_item:
		rewrite_history_without_path(path_to_item)


def version():
	"""Show version of the script"""
	print 'kd %s' % __version__


def main():
	"""Show a directory from the command line arguments (or some derivative)"""
	# pylint: disable-msg=R0912
	# Of course there are too many branches - it's an event dispatcher
	try:
		options, item, prefixes = parse_command_line()
		if not options:
			return 1
		if options.test:
			test()
			return 1
		elif options.version:
			version()
			return 1
		elif options.add:
			rewrite_history_with_path(item)
			return 1
		elif options.old:
			if item:
				show_path_to_historical_item(item, prefixes)
			else:
				list_paths()
				return 1
		elif options.delete:
			if item:
				delete_path_to_historical_item(item, prefixes)
			else:
				list_paths()
				return 1
		else:
			show_path_to_item(item, prefixes)
		return 0
	except TryAgain, e:
		print 'Try again:', e
		return 1
	except ToDo, e:
		print 'Error:', e
		return 1
	except SystemExit:
		return 1


if __name__ == '__main__':
	sys.exit(main())
