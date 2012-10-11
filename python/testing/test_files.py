"""This module provides convenience methods to handle test files

Test files are expected to exist as triples:
	fred.py, fred.test, fred.tests
	with fred.test* being optional

We also allow for python scripts which have no extension
"""


import os
import re


from paths import makepath


class UserMessage(Exception):
	"""Tell the user something went wrong"""
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


def _existing_test_files(path_to_stem):
	"""A list of all existing extensions of the given path

	Find all such extensions by replacing any extension in a real file
		or adding "/*" if it is a directory
		or otherwise looking the current directory

	Not expecting any test scripts in the root directory
	>>> _existing_test_files(makepath('/test_files.txt')) == []
	True

	But we should expect them for this script
	>>> __file__ in _existing_test_files(makepath(__file__))
	True
	"""
	if path_to_stem.isfile():
		dirr = path_to_stem.parent
		glob = path_to_stem.namebase + '.*'
	elif path_to_stem.isdir():
		dirr = path_to_stem
		glob = '*'
	else:
		if path_to_stem.parent:
			dirr = path_to_stem.parent
		else:
			dirr = makepath('.')
		glob = '%s.*' % path_to_stem.namebase
	if not dirr.isdir():
		return []
	return [f for f in dirr.files(glob)]


def _existing_test_extensions(path_stem):
	"""A list of all text extensions of the given path stem"""
	return [f for f in _existing_test_files(path_stem) if f.ext in possible_test_extensions()]


def _get_path_stems(args, recursive):
	"""A list of any paths in args

	If there is a "/" in the args then it is used in the list
	Otherwise it is appended to the current working directory
	"""
	if not args:
		args = []
	here = makepath('.')
	paths = []
	for arg in args:
		if '/' in arg:
			path_to_arg = makepath(arg)
		else:
			path_to_arg = here / arg
		paths.append(path_to_arg)
	if recursive:
		paths = add_sub_dirs(paths)
	return paths


def add_sub_dirs(paths):
	"""Add all sub-directories for the directories of the paths"""
	dirs = set([p.directory() for p in paths])
	result = list(dirs)
	for path_to_dir in dirs:
		for sub_dir in path_to_dir.walkdirs():
			if '.svn' in sub_dir:
				continue
			if sub_dir not in result:
				result.append(sub_dir)
	return result


def positive_test_extensions():
	"""Positive extensions for python files and test files"""
	return ['.tests', '.test', '.py']


def possible_test_extensions():
	"""All possible extensions for python files and test files"""
	return positive_test_extensions() + ['']


def is_test_extension(string):
	"""Whether the string is a possible test extension"""
	return string in possible_test_extensions()


def is_positive_test_extension(string):
	"""Whether the string is a possible test extension"""
	return string in positive_test_extensions()


def has_test_extension(string):
	"""Whether the string has a possible test extension"""
	_, ext = os.path.splitext(string)
	return is_test_extension(ext)


def has_positive_test_extension(string):
	"""Whether the string has a possible test extension"""
	_, ext = os.path.splitext(string)
	return is_positive_test_extension(ext)


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
		for path_to_file in method(glob):
			result.append(path_to_file)
	return result


def _expand_stems(path_stems):
	"""Extend the list of path stems with all test-extensions"""
	result = []
	for path_stem in path_stems:
		if path_stem.isfile():
			result.append(path_stem)
		else:
			result.extend(_existing_test_extensions(path_stem))
	if not result:
		path_stem = path_stems[0]
		raise UserMessage('%s.test*, %s.py not found' % (path_stem, path_stem))
	return result


def __get_path_stems_to_test_scripts(args, recursive):
	"""Get a list of test scripts from the given args

	Only known extensions are included
	If recursive is true then include sub_directories
	"""
	path_stems = _get_path_stems(args, recursive)
	if path_stems:
		paths_to_test_scripts = _expand_stems(path_stems)
	else:
		paths_to_test_scripts = _get_scripts_here(recursive)

	if not paths_to_test_scripts:
		path_to_test_directory = _get_path_to_test_directory(args)
		paths_to_test_scripts = path_to_test_directory.files('*.test*')
	return paths_to_test_scripts


def _text_has_python_shebang(path_to_script):
	"""Whether the first line of that script looks like

	#! ...python...
	"""
	lines = path_to_script.lines()
	if not lines:
		return False
	first_line = lines[0]
	return re.match('#!.*python.*', first_line)


def _re_order_scripts(paths_to_scripts):
	"""Re order the list of scripts so that their extensions are in order

	The order to be used is same as the extensions of possible_test_extensions()
		which goes from more testy to more doccy
	"""
	result = []
	for extension in possible_test_extensions():
		result.extend([path_to_script for path_to_script in paths_to_scripts if path_to_script.ext == extension])
	return result


def get_test_scripts(args, recursive):
	"""Get all test files for the given args

	args should be a list of paths - possibly empty
	If recursive is True then include sub_directories
	"""
	paths_to_test_scripts = __get_path_stems_to_test_scripts(args, recursive)
	paths_to_positive_scripts = [p for p in paths_to_test_scripts if p.ext in positive_test_extensions()]
	for path_to_script in paths_to_test_scripts:
		if path_to_script.ext:
			continue
		if not _text_has_python_shebang(path_to_script):
			continue
		if path_to_script in paths_to_positive_scripts:
			continue
		if str('%s.py' % path_to_script) in paths_to_positive_scripts:
			continue
		paths_to_positive_scripts.append(path_to_script)
	return _re_order_scripts(paths_to_positive_scripts)
