"""Script to find a new directory to cd to"""


import os
import sys
import inspect
from path import path


DEBUGGING = False


def debug(message):
	"""Show the message if (global) DEBUGGING is true"""
	if not DEBUGGING:
		return
	print >> sys.stderr, '%s: %s' % (sys.argv[0], message)


def enter_method():
	"""Get a message appropriate when entering a method"""
	frame = inspect.currentframe().f_back
	code = frame.f_code
	args, _varargs, _varkw, lokals = inspect.getargvalues(frame)
	values = [lokals[a] for a in args]
	return 'def %s%s' % (code.co_name, tuple(values))


def exit_method():
	"""Get a message appropriate when leaving a method"""
	frame = inspect.currentframe().f_back
	code = frame.f_code
	args, _varargs, _varkw, lokals = inspect.getargvalues(frame)
	arg_values = [lokals[a] for a in args]
	result = ['return %s%s:' % (code.co_name, tuple(arg_values))]
	for name, value in lokals.iteritems():
		if name in args:
			continue
		result.append('%r : %r' % (name, value))
	return '\n\t'.join(result)


def find_under_here(sub_directories):
	"""Look for some other directories under current directory

	Try any sub-directories (prefixed with sub_directories),
		then any files prefixed with sub_directories
	"""
	path_to_here = path(os.getcwd())
	return find_under_directory(path_to_here, sub_directories)


def look_under_directory(path_to_directory, prefixes):
	"""Look under the given path_to_directory for matching sub-directories

	Sub-directories match if they are prefixed with given prefixes
	If no sub-directories match, but a file matches
		then use the directory
	"""
	if not prefixes:
		return [path_to_directory]
	prefix, prefixes = prefixes[0], prefixes[1:]
	prefix_glob = '%s*' % prefix
	result = []
	for path_to_sub_directory in path_to_directory.dirs(prefix_glob):
		paths = look_under_directory(path_to_sub_directory, prefixes)
		result.extend(paths)
	if not result and path_to_directory.files(prefix_glob):
		result = [path_to_directory]
	return result


def find_under_directory(path_to_directory, sub_directories):
	possibles = look_under_directory(path_to_directory, sub_directories)
	if not possibles:
		return None
	if len(possibles) == 1:
		return possibles[0]
	raise NotImplementedError('Too many possiblities:\n\t%s' % '\n\t'.join(possibles))


def find_in_environment_path(filename):
	"""Return the first directory in $PATH which contains a file called filename

	This is equivalent to "which" command for executable files
	"""
	if not filename:
		return None
	for directory in os.environ['PATH'].split(':'):
		if not directory:
			continue
		path_to_directory = path(directory)
		path_to_file = path_to_directory / filename
		if path_to_file.isfile():
			return path_to_directory
	return None


def find_path_to_item(item):
	"""Find the path to the given item

	Either the directory itself, or directory of the file itself, or nothing
	"""
	path_to_item = path(item)
	if path_to_item.isdir():
		return path_to_item
	if path_to_item.isfile():
		return path_to_item.parent
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
	debug(enter_method())
	if item == '':
		return path('~').expanduser()
	if item == '-':
		item = previous_directory()
	path_to_item = find_path_to_item(item)
	if path_to_item:
		if not prefixes:
			return path_to_item
		path_to_item = find_under_directory(path_to_item, prefixes)
	else:
		if prefixes:
			path_to_item = find_under_here(prefixes)
		raise ValueError('%r is not a directory' % item)
	if path_to_item:
		return path_to_item
	return find_in_environment_path(item)


def parse_command_line():
	"""Get the arguments from the command line. Insist on at least one empty string"""
	args = sys.argv[1:]
	if not args:
		return '', []
	return args[0], args[1:]


def chdir(path_to_item):
	"""Trying cd'ing to the given directory"""
	path_to_item = find_dir(path_to_item)
	oldpwd = os.environ['PWD']
	os.chdir(path_to_item)
	os.environ['OLDPWD'] = oldpwd
	os.environ['PWD'] = path_to_item


def main():
	"""Show a directory from the command line arguments (or some derivative"""
	try:
		item, prefixes = parse_command_line()
		path_to_item = find_directory(item, prefixes)
		if path_to_item:
			print str(path_to_item)
		return 0
	except Exception, e:  # pylint: disable-msg=W0703
		print 'Error', e
		return 1


if __name__ == '__main__':
	sys.exit(main())
