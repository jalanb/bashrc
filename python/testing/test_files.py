"""This module provides convenience methids to handle test files

Test files are expected to exist as triples:
	fred.py, fred.test, fred.tests
	with fred.test* being optional

We also allow for python scripts which have no extension
"""


import re


from paths import makepath


class UserMessage(Exception):
	pass


def _get_path_to_test_directory(args):
	"""Get a path to the root directory that we'll be testing in

	We will test in the first directory in args
		or the directory of the first file in args
	"""
	result = makepath('.')
	for arg in args:
		arg_path = makepath(arg)
		if arg_path.isdir():
			result = arg_path
			break
	else:
		for arg in args:
			arg_path = makepath(arg)
			if arg_path.parent and arg_path.isfile():
				result = arg_path.parent
				break
	if not result.isdir():
		raise UserMessage('%s is not a directory' % result)
	if not result.files('*.test*') and not result.files('*.py'):
		raise UserMessage('%s/*.test*, *.py not found' % result)
	return result


def _any_extension(p):
	"""A list of all existing extensions of the given path"""
	if p.isfile():
		dirr = p.parent
		glob = p.namebase + '.*'
	elif p.isdir():
		dirr = p
		glob = '*'
	else:
		if p.parent:
			dirr = p.parent
		else:
			dirr = makepath('.')
		glob = '%s.*' % p.namebase
	if not dirr.isdir():
		return []
	return [f for f in dirr.files(glob)]


def existing_test_extensions(path_stem):
	"""A list of all text extensions of the given paths stem"""
	return [f for f in _any_extension(path_stem) if f.ext in possible_test_extensions()]


def get_paths(args, recursive):
	"""A list of any paths in args

	Of there is a "/" in the args then it is used in the list
	Otherwise it is appended to the current working directory
	"""
	if not args:
		args = []
	here = makepath('.')
	paths = []
	for arg in args:
		if '/' in arg:
			p = makepath(arg)
		else:
			p = here / arg
		paths.append(p)
	if recursive:
		paths = add_sub_dirs(paths)
	return paths


def add_sub_dirs(paths):
	"""Add all sub-directories for the directories of the paths"""
	dirs = set([p.directory() for p in paths])
	result = list(dirs)
	for p in dirs:
		for sub_dir in p.walkdirs():
			if '.svn' in sub_dir:
				continue
			if sub_dir not in result:
				result.append(sub_dir)
	return result


def positive_test_extensions():
	"""Positive extensions for python files and test files"""
	return ['.py', '.tests', '.test']


def possible_test_extensions():
	"""All possible extensions for python files and test files"""
	return [''] + positive_test_extensions()


def possible_test_globs():
	"""A glob for each of the possible test extensions"""
	return [str('*%s' % ext) for ext in possible_test_extensions()]


def _get_scripts_here(recursive):
	"""Find all test scripts in the current working directory"""
	here = makepath('.')
	if recursive:
		method = here.walkfiles
	else:
		method = here.files
	result = []
	for glob in possible_test_globs():
		for f in method(glob):
			result.append(f)
	return result


def _expand_stems(path_stems):
	"""Extend the list of path stems with all test-extensions"""
	result = []
	for path_stem in path_stems:
		if path_stem.isfile():
			result.append(path_stem)
		else:
			result.extend(existing_test_extensions(path_stem))
	if not result:
		path_stem = path_stems[0]
		raise UserMessage('%s.test*, %s.py not found' % (path_stem, path_stem))
	return result


def _get_paths_to_test_scripts(args, recursive):
	"""Get a list of test scripts from the given args

	Only known extensions are included
	If recursive is true then include sub_directories
	"""
	path_stems = get_paths(args, recursive)
	if not path_stems:
		paths_to_test_scripts = _get_scripts_here(recursive)
	else:
		paths_to_test_scripts = _expand_stems(path_stems)

	if not paths_to_test_scripts:
		path_to_test_directory = _get_path_to_test_directory(args)
		paths_to_test_scripts = path_to_test_directory.files('*.test*')
	return paths_to_test_scripts


def get_test_scripts(args, recursive):
	"""Get all test files for the given args

	args should be a list of paths - possible empty
	If recursove is True then include sub_directories
	"""
	paths_to_test_scripts = _get_paths_to_test_scripts(args, recursive)
	result = [p for p in paths_to_test_scripts if p.ext in positive_test_extensions()]
	for script in paths_to_test_scripts:
		if script.ext == '':
			lines = script.lines()
			if not lines:
				continue
			if re.match('#!.*python.*', lines[0]):
				if script not in result and str('%s.py' % script) not in result:
					result.append(script)
	return result
