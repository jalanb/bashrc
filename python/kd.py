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
	print >> sys.stderr, '%s: %r' % (sys.argv[0], message)
	
def enter_method():
	"""Get a message appropriate when entering a method"""
	frame = inspect.currentframe().f_back
	code = frame.f_code
	args, _varargs, _varkw, lokals = inspect.getargvalues(frame)
	values = [ lokals[a] for a in args ]
	return 'def %s%s' % (code.co_name, tuple(values))
	
def exit_method():
	"""Get a message appropriate when leaving a method"""
	frame = inspect.currentframe().f_back
	code = frame.f_code
	args, _varargs, _varkw, lokals = inspect.getargvalues(frame)
	arg_values = [ lokals[a] for a in args ]
	result = [ 'return %s%s:' % (code.co_name, tuple(arg_values)) ]
	for name, value in lokals.iteritems():
		if name in args:
			continue
		result.append( '%r : %r' % ( name, value ) )
	return '\n\t'.join(result)
	
def try_others(directory, sub_dir):
	"""Look for some other directories around the given directory

	Try the parent
		then any sub-directories (prefixed with sub_dir),
		then any files prefixed with sub_dir
	"""
	debug(enter_method())
	path_to_directory = path(directory)
	if path_to_directory.parent.isdir():
		debug(exit_method())
		return path_to_directory.parent
	path_to_directory = path(os.getcwd())
	if sub_dir:
		try:
			return [ d for d in path_to_directory.dirs() if d.startswith(sub_dir) ][0]
		except IndexError:
			try:
				return [ path_to_directory for f in path_to_directory.files() if f.startswith(sub_dir) ][0]
			except IndexError:
				raise ValueError('Could not find %r in %r' % ( sub_dir, path_to_directory ))
	return path(directory)

def try_sub_dirs(path_to_directory, sub_dir):
	"""Look in path_to_directory for sub_dir

	Return a list of names for 
		each sub-directory containing sub_dir
	Or
		each sub-sub-directory containing sub_dir
	"""
	debug(enter_method())
	result = []
	for path_to_child in path_to_directory.dirs():
		if sub_dir in path_to_child.name:
			result.append(path_to_child)
	if result:
		debug(exit_method())
		return result
	for path_to_child in path_to_directory.dirs():
		if path_to_child.name == '.svn':
			continue
		result.extend( try_sub_dirs(path_to_child, sub_dir) )
	debug(exit_method())
	return result

def find_in_environment_path(filename):
	"""Return the first directory in $PATH which contains a file called filename"""
	for directory in os.environ['PATH'].split(':'):
		path_to_directory = path(directory)
		possible_file = path_to_directory / filename
		if possible_file.isfile():
			return path_to_directory
	return None

def find_dir(start_dir, sub_dir=None):
	"""Find a relevant directory relative to the start_dir, and using a sub_dir (if given)
	
	start_dir can be
		empty (use home directory)
		"-" (use $OLDPWD)

	Return start_dir if it is a directory,
		or its parent if it is a file
		or one of its sub-directories (if they match sub_dir)
		or a directory in $PATH
	Otherwise look for sub_dir as a partial match
	"""
	debug(enter_method())
	if start_dir == '':
		return path('~').expanduser()
	if start_dir == '-':
		try:
			start_dir = os.environ['OLDPWD']
		except KeyError:
			start_dir = '~'
	path_whither = path(start_dir)
	if path_whither.isfile():
		path_whither = path_whither.parent
	if not path_whither.isdir():
		path_whither = try_others(start_dir, sub_dir)
	if not path_whither.isdir():
		path_whither = find_in_environment_path(path_whither)
	if not path_whither or not path_whither.isdir():
		raise ValueError('%s is not a directory' % start_dir)
	if not sub_dir:
		return path_whither
	possibles = try_sub_dirs(path_whither, sub_dir)
	if len(possibles) == 1:
		return possibles[0]
	if not possibles:
		return path_whither
	if sub_dir in possibles:
		return sub_dir
	raise NotImplementedError('Too many possiblities:\n\t%s' % '\n\t'.join(possibles) )

def parse_command_line(args):
	"""Get the arguments from the command line. Insist on 1, 2nd is optional"""
	if len(args) > 2:
		raise ValueError('Usage: kd directory [sub-dir]')
	elif len(args) < 1:
		args = '', None
	elif len(args) == 1:
		args += [ None ]
	debug('args: %s' % str(args) )
	return args

def chdir(path_whither):
	"""Trying cd'ing to the given directory"""
	path_whither = find_dir(path_whither)
	oldpwd = os.environ['PWD']
	os.chdir(path_whither)
	os.environ['OLDPWD'] = oldpwd
	os.environ['PWD'] = path_whither

def main():
	"""Show a directory from the command line arguments (or some derivative"""
	try:
		args = parse_command_line(sys.argv[1:])
		path_whither = find_dir(args[0], args[1])
		if path_whither:
			print str(path_whither)
		return 0
	except Exception, e: # pylint: disable-msg=W0703
		print 'Error', e
		return 1

if __name__ == '__main__':
	sys.exit(main())
