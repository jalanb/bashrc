"""A collection of extended path classes and methods

The classes all inherit from the original path.path
"""

import os

from path import path

class PathError(Exception):
	"""Something went wrong with a path"""
	prefix = 'Path Error'
	def __init__(self, message):
		Exception.__init__(self, message)

class PathAssertions:
	"""Assertions that can be made about paths"""

	def assert_exists(self):
		"""Raise a PathError if this path does not exist on disk"""
		if not self.exists():
			raise PathError('%s does not exist' % self)
		return self

	def assert_isdir(self):
		"""Raise a PathError if this path is not a directory on disk"""
		if not self.isdir():
			raise PathError('%s is not a directory' % self)
		return self

	def assert_isfile(self):
		"""Raise a PathError if this path is not a file on disk"""
		if not self.isfile():
			raise PathError('%s is not a file' % self)
		return self

class FilePath(path, PathAssertions):
	"""A path to a known file"""

	def __div__(self, child):
		raise PathError, '%r has no children' % self

	def __iter__(self):
		for l in path.lines(self):
			yield l.rstrip('\n')

	def directory(self):
		"""Return a path to the file's directory"""
		return self.parent

	def try_remove(self):
		"""Try to remove the file"""
		self.remove()

	def stripped_lines(self):
		"""A list of all non-empty lines

		If lines can not be read (e.g. no such file) then an empty list is returned
		"""
		try:
			return [ l.rstrip() for l in self.lines() ]
		except IOError:
			return []

	def non_comment_lines(self):
		"""A list of all non-empty, non-comment lines"""
		return [ l for l in self.stripped_lines() if l and not l.startswith('#') ]

	def split_all_ext(self):
		copy = self[:]
		filename, ext = os.path.splitext(copy)
		if ext == '.gz':
			filename, ext = os.path.splitext(filename)
			ext += '.gz'
		return self.__class__(filename), ext

	def as_python(self):
		"""The path to the file with a .py extension

		>>> FilePath('/path/to/fred.txt').as_python()
		<FilePath u'/path/to/fred.py'>
		"""
		return self.extend_by('.py')

	def extend_by(self, extension):
		"""The path to the file changed to use the given extension

		>>> FilePath('/path/to/fred').extend_by('.txt')
		<FilePath u'/path/to/fred.txt'>
		>>> FilePath('/path/to/fred.txt').extend_by('..tmp')
		<FilePath u'/path/to/fred.tmp'>
		>>> FilePath('/path/to/fred.txt').extend_by('fred')
		<FilePath u'/path/to/fred.fred'>
		"""
		copy = self[:]
		filename, _ = os.path.splitext(copy)
		return self.__class__('%s.%s' % (filename, extension.lstrip('.')))

	def make_read_only(self):
		"""chmod the file permissions to -r--r--r--"""
		self.chmod(chmod_values.readonly_file)

	def cd(self):
		"""Change program's current directory to self"""
		return cd(self.parent)

	def dirname(self):
		return DirectPath(os.path.dirname(self))
	parent = property( dirname )

	def shebang(self):
		"""The #! entry from the first line of the file

		If no shebang is present, return an empty string
		"""
		try:
			first_line = self.lines()[0]
			if first_line.startswith('#!'):
				return first_line[2:].strip()
		except IndexError:
			pass
		return ''

	def mv(self, destination):
		return self.move(destination)

	def make_file_exist(self):
		"""Make sure the parent directory exists, then touch the file"""
		self.parent.make_directory_exist()
		self.parent.touch_file(self.name)
		return self

class DirectPath(path, PathAssertions):
	"""A path which knows it might be a directory

	And that files are in directories
	"""

	__file_class__ = FilePath

	def __iter__(self):
		for p in path.listdir(self):
			yield p

	def directory(self):
		"""Return a path to a directory.

		Either the path itself (if it is a directory), or its parent)
		"""
		if self.isdir():
			return self
		return self.parent

	def try_remove(self):
		"""Try to remove the path

		If it is a directory, try recursive removal of contents too
		"""
		if self.islink():
			self.unlink()
		elif self.isfile():
			self.remove()
		elif self.isdir():
			self.empty_directory()
			if self.isdir():
				self.rmdir()
		else:
			return False
		return True

	def empty_directory(self):
		"""Remove all contents of a directory

		Including any sub-directories and their contents"""
		for child in self.walkfiles():
			child.remove()
		for child in reversed([ d for d in self.walkdirs() ]):
			if child == self or not child.isdir():
				continue
			child.rmdir()

	def cd(self):
		"""Change program's current directory to self"""
		return cd(self)

	def listdir(self, pattern = None):
		return [ self.as_existing_file(p) for p in path.listdir(self, pattern) ]

	def make_directory_exist(self):
		if self.isdir():
			return False
		if os.path.exists(self) :
			raise PathError('%s exists but is not a directory' % self)
		self.makedirs()

	def make_file_exist(self, filename = None):
		"""Make the directory exist, then touch the file

		If the filename is None, then use self.name as filename
		"""
		if filename is None:
			path_to_file = FilePath(self)
			path_to_file.make_file_exist()
			return path_to_file
		else:
			self.make_directory_exist()
			path_to_file = self.touch_file(filename)
			return FilePath( path_to_file )

	def make_read_only(self):
		"""chmod the directory permissions to -r-xr-xr-x"""
		self.chmod(chmod_values.readonly_directory)

	def touch_file(self, filename):
		"""Touch a file in the directory"""
		path_to_file = self.__file_class__(os.path.join(self, filename))
		path_to_file.touch()
		return path_to_file

	def existing_sub_paths(self, sub_paths):
		"""Those in the given list of sub_paths which do exist"""
		paths_to_subs = [ self / p for p in sub_paths ]
		return [p for p in paths_to_subs if p.exists()]

	def clear_directory(self):
		"""Make sure the directory exists and is empty"""
		self.make_directory_exist()
		self.empty_directory()

class chmod_values:
	readonly_file = 0444
	readonly_directory = 0555

def makepath(string, as_file = False):
	"""Make a path from a string

	Expand out any variables, home squiggles, and normalise it
	"""
	if string is None:
		return None
	string_path = path(string).expand()
	if string_path.isfile() or as_file:
		result = FilePath(string_path)
	else:
		result = DirectPath(string_path)
	return result.expand().realpath().abspath()

def cd(path_to):
	"""cd to the given path

	If the path is a file, then cd to its parent directory

	Remember current directory before the cd
		so that we can cd back there with cd('-')
	"""
	if path_to == '-':
		if not cd.previous:
			raise PathError('No previous directory to return to')
		return cd(cd.previous)
	if not hasattr(path_to, 'cd'):
		path_to = makepath(path_to)
	previous = os.getcwd()
	if path_to.isdir():
		os.chdir(path_to)
	elif path_to.isfile():
		os.chdir(path_to.parent)
	elif not os.path.exists(path_to):
		return False
	else:
		raise PathError('Cannot cd to %s' % path_to)
	cd.previous = previous
	return True

try:
	cd.previous = makepath(os.getcwd())
except OSError:
	cd.previous = None

def as_path(string_or_path):
	"""Return the argument as a DirectPath

	If it is already one, return it unchanged
	If not, return the makepath()
	"""
	if isinstance(string_or_path, DirectPath):
		return string_or_path
	return makepath(string_or_path)

def string_to_paths(string):
	for c in ':, ;':
		if c in string:
			return strings_to_paths( string.split(c) )
	return [ makepath(string) ]

def strings_to_paths(strings):
	return [ makepath(s) for s in strings ]

def split_directories(strings):
	strings = strings_to_paths(strings)
	return [ p for p in strings if p.isdir() ], [ p for p in strings if not p.isdir() ]

def split_files(strings):
	strings = strings_to_paths(strings)
	return [ p for p in strings if p.isfile() ], [ p for p in strings if not p.isfile() ]

def split_directories_files(strings):
	strings = strings_to_paths(strings)
	return [ p for p in strings if p.isdir() ], [ p for p in strings if p.isfile() ], [ p for p in strings if not (p.isfile() or p.isdir())]

def files(strings):
	return split_files(strings)[0]

def directories(strings):
	return split_directories(strings)[0]

def home():
	return makepath('~')

def pwd():
	return makepath(os.getcwd())


def	first_dir(path_string):
	"""Get the first directory in that path

	>>> first_dir('usr/local/bin') == 'usr'
	True
	"""
	parts = path_string.split(os.path.sep)
	return parts[0]


def first_dirs(path_strings):
	"""Get the roots of those paths

	>>> first_dirs(['usr/local/bin', 'usr/bin', 'bin']) == ['usr', 'usr', 'bin']
	True
	"""
	return [first_dir(p) for p in path_strings]


def unique_first_dirs(path_strings):
	"""Get the unique roots of those paths

	>>> unique_first_dirs(['usr/local/bin', 'usr/bin', 'bin']) == set(['usr', 'bin'])
	True
	"""
	return set(first_dirs(path_strings))
