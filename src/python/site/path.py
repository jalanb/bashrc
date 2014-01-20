"""path.py - An object representing a path to a file or directory.

Example:

	>>> from path import path
	>>> path('/home/guido/bin').isdir()
	False

This module requires Python 2.2 or later.
	URL:	 http://www.jorendorff.com/articles/python/path
	Author:  Jason Orendorff <jason@jorendorff.com> (and others - see the url!)
	Date:	7 Mar 2004
"""

from __future__ import generators
import sys, os, fnmatch, glob, shutil, codecs

# Not very pylint friendly:

# pylint: disable-msg=E1101, C0103, C0111, C0321, W0141, W0142, W0612, W0622, W0702, R0904, R0912, R0913

__version__ = '2.0.4'
__all__ = ['path']

_base = unicode

# Pre-2.3 workaround for basestring.
try:
	basestring
except NameError:
	basestring = (str, unicode)

# Universal newline support
_textmode = 'r'
if hasattr(file, 'newlines'):
	_textmode = 'U'

class path(_base):
	""" Represents a filesystem path.

	For documentation on individual methods, consult their
	counterparts in os.path.
	"""

	# --- Special Python methods.
	def __repr__(self):
		"""A nice representation of a path

		>>> path('/home/guido')
		<path u'/home/guido'>
		"""
		return '<%s %s>' % (self.__class__.__name__, _base.__repr__(self))

	def __add__(self, more):
		"""Add a string to a path

		>>> p = path('/home/guido/path') + '.py'
		>>> p.name == 'path.py'
		True
		"""
		return self.__class__(_base(self) + more)

	def __radd__(self, other):
		"""Add a path to a string

		>>> p = '/home/guido/path' + path('.py')
		>>> p.name == 'path.py'
		True
		"""
		return self.__class__(other + _base(self))

	def as_file(self, filepath):
		"""Return the file_class of the file, or self's class"""
		if hasattr(self,'__file_class__'):
			return self.__file_class__(filepath)
		return self.__class__(filepath)

	def as_existing_file(self, filepath):
		"""Return the file class for existing files only"""
		if os.path.isfile(filepath) and hasattr(self,'__file_class__'):
			return self.__file_class__(filepath)
		return self.__class__(filepath)

	# The / operator joins paths.
	def __div__(self, child):
		""" Join two path components, adding a separator character if needed.

		If the result is a file return self.__file_class__(result)

		>>> p = path('/home/guido')
		>>> p.__div__('fred') == p / 'fred' == p.joinpath('fred')
		True
		"""
		if child:
			result = os.path.join(self, child)
		else:
			result = str(self)
		return self.as_existing_file(result)

	# Make the / operator work even when true division is enabled.
	__truediv__ = __div__

	def getcwd():
		""" Return the current working directory as a path object. """
		return path(os.getcwd())
	getcwd = staticmethod(getcwd)

	# --- Operations on path strings.
	def abspath(self):	   return self.__class__(os.path.abspath(self))
	def normcase(self):	  return self.__class__(os.path.normcase(self))
	def normpath(self):	  return self.__class__(os.path.normpath(self))
	def realpath(self):	  return self.__class__(os.path.realpath(self))
	def expanduser(self):	return self.__class__(os.path.expanduser(self))
	def expandvars(self):	return self.__class__(os.path.expandvars(self))
	def dirname(self):	   return self.__class__(os.path.dirname(self))
	basename = os.path.basename

	def expand(self):
		""" Clean up a filename by calling expandvars(), expanduser(), and normpath() on it.

		This is commonly everything needed to clean up a filename
		read from a configuration file, for example.
		"""
		return self.__class__(self.expandvars().expanduser().normpath())

	def _get_namebase(self):
		"""The same as path.name, but with one file extension stripped off.

		>>> print path('/home/guido/fred.tar')._get_namebase()
		fred
		"""
		base, ext = os.path.splitext(self.name)
		return base

	def _get_ext(self):
		"""The extension of the file

		>>> print path('/home/guido/python.tar')._get_ext()
		.tar
		"""
		f, ext = os.path.splitext(_base(self))
		return ext

	def _get_drive(self):
		"""The drive specifier, for example 'C:'

		>>> not path('/home/guido/python.tar')._get_drive()
		True
		"""
		drive, r = os.path.splitdrive(self)
		return self.__class__(drive)

	def dirnames(self):
		"""Split the dirname into individual directory names

		An absolute path starts with an empty string, a relative path does not

		>>> path(u'/path/to/module.py').dirnames() == [ u'', u'path', u'to']
		True
		>>> path(u'path/to/module.py').dirnames() == [ u'path', u'to']
		True
		"""
		return self.dirname().split(os.path.sep)

	def directories(self):
		"""Split the dirname into individual directory names

		No empty parts are included

		>>> path(u'path/to/module.py').directories() == [ u'path', u'to']
		True
		>>> path(u'/path/to/module.py').directories() == [ u'path', u'to']
		True
		"""
		return [d for d in self.dirnames() if d]

	parent = property(
		dirname, None, None,
		""" This path's parent directory, as a new path object.

		>>> path('/path/to/module.py').parent == path('/path/to')
		True
		""")

	parents = property(
		dirnames, None, None,
		""" This path's parent directories, as a list of strings.

		>>> path(u'/path/to/module.py').parents == [ u'', u'path', u'to']
		True
		""")

	name = property(
		basename, None, None,
		""" The name of this file or directory without the full path.

		>>> path('/path/to/module.py').name == 'module.py'
		True
		""")

	namebase = property(
		_get_namebase, None, None,
		""" The same as path.name, but with one file extension stripped off.

		>>> path('/home/guido/python.tar.gz').name == 'python.tar.gz'
		True
		>>> path('/home/guido/python.tar.gz').namebase == 'python.tar'
		True
		""")

	ext = property(
		_get_ext, None, None,
		""" The file extension, for example '.py'. """)

	drive = property(
		_get_drive, None, None,
		""" The drive specifier, for example 'C:'.
		This is always empty on systems that don't use drive specifiers.
		""")

	def splitpath(self):
		"""Split a path into directory and file parts

		>>> path('/home/guido/python.tar.gz').splitpath()
		(<path u'/home/guido'>, u'python.tar.gz')
		"""
		parent, child = os.path.split(self)
		return self.__class__(parent), child

	def splitdrive(self):
		""" p.splitdrive() -> Return (p.drive, <the rest of p>).

		Split the drive specifier from this path.  If there is
		no drive specifier, p.drive is empty, so the return value
		is simply (path(''), p).  This is always the case on Unix.

		>>> path('/home/guido/python.tar.gz').splitdrive()
		(<path u''>, <path u'/home/guido/python.tar.gz'>)
		"""
		drive, child = os.path.splitdrive(self)
		return self.__class__(drive), child

	def splitext(self):
		""" p.splitext() -> Return (p.stripext(), p.ext).

		Split the filename extension from this path and return
		the two parts.  Either part may be empty.
		The extension is everything from '.' to the end of the
		last path segment.  This has the property that if
		(a, b) == p.splitext(), then a + b == p.

		>>> path('/home/guido/python.tar.gz').splitext()
		(<path u'/home/guido/python.tar'>, u'.gz')
		"""
		filename, ext = os.path.splitext(self)
		return self.__class__(filename), ext

	def joinpath(self, *args):
		""" Join two or more path components, adding a separator
		character (os.sep) if needed.  Returns a new path
		object.

		>>> path('/home/guido').joinpath('.bashrc')
		<path u'/home/guido/.bashrc'>
		"""
		return self.__class__(os.path.join(self, *args))

	def splitall(self):
		""" Return a list of the path components in this path.

		The first item in the list will be a path.  Its value will be
		either os.curdir, os.pardir, empty, or the root directory of
		this path (for example, '/' or 'C:\\').  The other items in
		the list will be strings.
		path.path.joinpath(*result) will yield the original path.

		>>> path('/home/guido/.bashrc').splitall()
		[<path u'/'>, u'home', u'guido', u'.bashrc']

		>>> path('build/python.tar').splitall()
		[<path u''>, u'build', u'python.tar']
		"""
		parts = []
		loc = self
		while loc != os.curdir and loc != os.pardir:
			prev = loc
			loc, child = prev.splitpath()
			if loc == prev:
				break
			parts.append(child)
		parts.append(loc)
		parts.reverse()
		return parts

	def relpathto(self, dest):
		""" Return a relative path from self to dest.

		If there is no relative path from self to dest, for example if
		they reside on different drives in Windows, then this returns
		dest.abspath().

		>>> print path('/home/guido/bin').relpathto('/home/guido/build/python.tar')
		../build/python.tar
		"""
		origin = self.abspath()
		dest = self.__class__(dest).abspath()
		orig_list = origin.normcase().splitall()
		# Don't normcase dest!  We want to preserve the case.
		dest_list = dest.splitall()
		if orig_list[0] != os.path.normcase(dest_list[0]):
			# Can't get here from there.
			return dest
		elif orig_list[0] == '/':
			if origin == '/' or dest == '/':
				return dest
			if orig_list[1] != os.path.normcase(dest_list[1]):
				return dest
		# Find the location where the two paths start to differ.
		i = 0
		for start_seg, dest_seg in zip(orig_list, dest_list):
			if start_seg != os.path.normcase(dest_seg):
				break
			i += 1
		# Now i is the point where the two paths diverge.
		# Need a certain number of "os.pardir"s to work up
		# from the origin to the point of divergence.
		segments = [os.pardir] * (len(orig_list) - i)
		# Need to add the diverging part of dest_list.
		segments += dest_list[i:]
		if len(segments) == 0:
			# If they happen to be identical, use os.curdir.
			return self.__class__(os.curdir)
		else:
			return self.__class__(os.path.join(*segments))

	def short_relative_path_to(self, destination):
		"""The shorter of either the absolute path of the destination, or the relative path to it

		>>> print path('/home/guido/bin').short_relative_path_to('/home/guido/build/python.tar')
		../build/python.tar
		>>> print path('/home/guido/bin').short_relative_path_to('/mnt/guido/build/python.tar')
		/mnt/guido/build/python.tar
		"""
		relative = self.relpathto(destination)
		absolute = self.__class__(destination).abspath()
		if len(relative) < len(absolute):
			return relative
		return absolute

	def short_relative_path_to_here(self):
		"""A short path relative to current working directory"""
		return self.short_relative_path_to(os.getcwd())

	def short_relative_path_from_here(self):
		"""A short path relative to self to the current working directory"""
		return self.__class__(os.getcwd()).short_relative_path_to(self)

	# --- Listing, searching, walking, and matching
	def listdir(self, pattern=None):
		""" D.listdir() -> List of items in this directory.

		Use D.files() or D.dirs() instead if you want a listing
		of just files or just subdirectories.
		The elements of the list are path objects.
		With the optional 'pattern' argument, this only lists
		items whose names match the given pattern.

		>>> '.bashrc' in [ p.name for p in path('~').expand().listdir('*rc') ]
		True
		"""
		try: names = os.listdir(self)
		except: return []
		if pattern is not None:
			names = fnmatch.filter(names, pattern)
		return [self / child for child in names]

	def dirs(self, pattern=None):
		""" D.dirs() -> List of this directory's subdirectories.

		The elements of the list are path objects.
		This does not walk recursively into subdirectories
		(but see path.walkdirs).
		With the optional 'pattern' argument, this only lists
		directories whose names match the given pattern.

		>>> 'usr' in [ p.name for p in path('/').dirs('*r') ]
		True
		"""
		return [self.__class__(p) for p in self.listdir(pattern) if p.isdir()]

	def files(self, pattern=None):
		""" D.files() -> List of the files in this directory.

		The elements of the list are path objects.
		This does not walk into subdirectories (see path.walkfiles).
		With the optional 'pattern' argument, this only lists files
		whose names match the given pattern.

		>>> '.bashrc' in [ p.name for p in path('~').expand().files('*rc') ]
		True
		"""
		return [self.as_file(p) for p in self.listdir(pattern) if p.isfile()]

	def walk(self, pattern=None):
		""" D.walk() -> iterator over files and subdirs, recursively.

		The iterator yields path objects naming each child item of
		this directory and its descendants.  This requires that
		D.isdir().
		This performs a depth-first traversal of the directory tree.
		Each directory is returned just before all its children.
		"""
		for child in self.listdir():
			if pattern is None or child.fnmatch(pattern):
				yield child
			if child.isdir():
				for item in child.walk(pattern):
					yield item

	def walkdirs(self, pattern=None):
		""" D.walkdirs() -> iterator over subdirs, recursively.

		With the optional 'pattern' argument, this yields only
		directories whose names match the given pattern.  For
		example, mydir.walkdirs('*test') yields only directories
		with names ending in 'test'.
		"""
		for child in self.dirs():
			if pattern is None or child.fnmatch(pattern):
				yield child
			for subsubdir in child.walkdirs(pattern):
				yield subsubdir

	def walkfiles(self, pattern=None):
		""" D.walkfiles() -> iterator over files in D, recursively.

		The optional argument, pattern, limits the results to files
		with names that match the pattern.  For example,
		mydir.walkfiles('*.tmp') yields only files with the .tmp
		extension.
		"""
		for child in self.listdir():
			if child.isfile():
				if pattern is None or child.fnmatch(pattern):
					yield self.as_file(child)
			elif child.isdir():
				for f in child.walkfiles(pattern):
					yield self.as_file(f)

	def walk_some_dirs(self, levels = -1, pattern=None):
		""" D.walkdirs() -> iterator over subdirs, recursively.

		With the optional 'pattern' argument, this yields only
		directories whose names match the given pattern.  For
		example, mydir.walkdirs('*test') yields only directories
		with names ending in 'test'.
		"""
		if not levels:
			yield self
			raise StopIteration
		levels -= 1
		for child in self.dirs():
			if pattern is None or child.fnmatch(pattern):
				yield child
			if levels:
				for subsubdir in child.walk_some_dirs(levels, pattern):
					yield subsubdir

	def fnmatch(self, pattern):
		""" Return True if self.name matches the given pattern.

		pattern - A filename pattern with wildcards,
			for example '*.py'.

		>>> path('/home/guido/, bashrc').fnmatch('*rc')
		True
		"""
		return fnmatch.fnmatch(self.name, pattern)

	def glob(self, pattern):
		""" Return a list of path objects that match the pattern.

		pattern - a path relative to this directory, with wildcards.
		For example, path('/users').glob('*/bin/*') returns a list
		of all the files users have in their bin directories.
		"""
		return map(path, glob.glob(_base(self / pattern)))

	# --- Reading or writing an entire file at once.

	def open(self, mode='r'):
		""" Open this file.  Return a file object. """
		return file(self, mode)

	def bytes(self):
		""" Open this file, read all bytes, return them as a string. """
		f = self.open('rb')
		try:
			return f.read()
		finally:
			f.close()

	def write_bytes(self, bytes, append=False):
		""" Open this file and write the given bytes to it.

		Default behavior is to overwrite any existing file.
		Call this with write_bytes(bytes, append=True) to append instead.
		"""
		if append:
			mode = 'ab'
		else:
			mode = 'wb'
		f = self.open(mode)
		try:
			f.write(bytes)
		finally:
			f.close()

	def text(self, encoding=None, errors='strict'):
		""" Open this file, read it in, return the content as a string.

		This uses 'U' mode in Python 2.3 and later, so '\r\n' and '\r'
		are automatically translated to '\n'.
		Optional arguments:
		encoding - The Unicode encoding (or character set) of
			the file.  If present, the content of the file is
			decoded and returned as a unicode object; otherwise
			it is returned as an 8-bit str.
		errors - How to handle Unicode errors; see help(str.decode)
			for the options.  Default is 'strict'.
		"""
		if encoding is None:
			# 8-bit
			f = self.open(_textmode)
			try:
				return f.read()
			finally:
				f.close()
		else:
			# Unicode
			f = codecs.open(self, 'r', encoding, errors)
			# (Note - Can't use 'U' mode here, since codecs.open
			# doesn't support 'U' mode, even in Python 2.3.)
			try:
				t = f.read()
			finally:
				f.close()
			return (t.replace(u'\r\n', u'\n')
					.replace(u'\r\x85', u'\n')
					.replace(u'\r', u'\n')
					.replace(u'\x85', u'\n')
					.replace(u'\u2028', u'\n'))

	def write_text(self, text, encoding=None, errors='strict', linesep=os.linesep, append=False):
		""" Write the given text to this file.

		The default behavior is to overwrite any existing file;
		to append instead, use the 'append=True' keyword argument.
		There are two differences between path.write_text() and
		path.write_bytes(): newline handling and Unicode handling.
		See below.
		Parameters:
		  - text - str/unicode - The text to be written.
		  - encoding - str - The Unicode encoding that will be used.
			This is ignored if 'text' isn't a Unicode string.
		  - errors - str - How to handle Unicode encoding errors.
			Default is 'strict'.  See help(unicode.encode) for the
			options.  This is ignored if 'text' isn't a Unicode
			string.
		  - linesep - keyword argument - str/unicode - The sequence of
			characters to be used to mark end-of-line.  The default is
			os.linesep.  You can also specify None; this means to
			leave all newlines as they are in 'text'.
		  - append - keyword argument - bool - Specifies what to do if
			the file already exists (True: append to the end of it;
			False: overwrite it.)  The default is False.
		--- Newline handling.
		write_text() converts all standard end-of-line sequences
		('\n', '\r', and '\r\n') to your platform's default end-of-line
		sequence (see os.linesep; on Windows, for example, the
		end-of-line marker is '\r\n').
		If you don't like your platform's default, you can override it
		using the 'linesep=' keyword argument.  If you specifically want
		write_text() to preserve the newlines as-is, use 'linesep=None'.
		This applies to Unicode text the same as to 8-bit text, except
		there are three additional standard Unicode end-of-line sequences:
		u'\x85', u'\r\x85', and u'\u2028'.
		(This is slightly different from when you open a file for
		writing with fopen(filename, "w") in C or file(filename, 'w')
		in Python.)
		--- Unicode
		If 'text' isn't Unicode, then apart from newline handling, the
		bytes are written verbatim to the file.  The 'encoding' and
		'errors' arguments are not used and must be omitted.
		If 'text' is Unicode, it is first converted to bytes using the
		specified 'encoding' (or the default encoding if 'encoding'
		isn't specified).  The 'errors' argument applies only to this
		conversion.
		"""
		if isinstance(text, unicode):
			if linesep is not None:
				# Convert all standard end-of-line sequences to
				# ordinary newline characters.
				text = (text.replace(u'\r\n', u'\n')
							.replace(u'\r\x85', u'\n')
							.replace(u'\r', u'\n')
							.replace(u'\x85', u'\n')
							.replace(u'\u2028', u'\n'))
				text = text.replace(u'\n', linesep)
			if encoding is None:
				encoding = sys.getdefaultencoding()
			bytes = text.encode(encoding, errors)
		else:
			# It is an error to specify an encoding if 'text' is
			# an 8-bit string.
			assert encoding is None
			if linesep is not None:
				text = (text.replace('\r\n', '\n')
							.replace('\r', '\n'))
				bytes = text.replace('\n', linesep)
		self.write_bytes(bytes, append)

	def lines(self, encoding=None, errors='strict', retain=True):
		""" Open this file, read all lines, return them in a list.

		Optional arguments:
			encoding - The Unicode encoding (or character set) of
				the file.  The default is None, meaning the content
				of the file is read as 8-bit characters and returned
				as a list of (non-Unicode) str objects.
			errors - How to handle Unicode errors; see help(str.decode)
				for the options.  Default is 'strict'
			retain - If true, retain newline characters; but all newline
				character combinations ('\r', '\n', '\r\n') are
				translated to '\n'.  If false, newline characters are
				stripped off.  Default is True.
		This uses 'U' mode in Python 2.3 and later.

		>>> lines = path(__file__).lines()
		>>> these_lines = [ l for l in lines if 'these_lines' in l ]
		>>> len(these_lines) == 2
		True
		"""
		if encoding is None and retain:
			f = self.open(_textmode)
			try:
				return f.readlines()
			finally:
				f.close()
		else:
			return self.text(encoding, errors).splitlines(retain)

	def write_lines(self, lines, encoding=None, errors='strict',
					linesep=os.linesep, append=False):
		""" Write the given lines of text to this file.

		By default this overwrites any existing file at this path.
		This puts a platform-specific newline sequence on every line.
		See 'linesep' below.
		lines - A list of strings.
		encoding - A Unicode encoding to use.  This applies only if
			'lines' contains any Unicode strings.
		errors - How to handle errors in Unicode encoding.  This
			also applies only to Unicode strings.
		linesep - The desired line-ending.  This line-ending is
			applied to every line.  If a line already has any
			standard line ending ('\r', '\n', '\r\n', u'\x85',
			u'\r\x85', u'\u2028'), that will be stripped off and
			this will be used instead.  The default is os.linesep,
			which is platform-dependent ('\r\n' on Windows, '\n' on
			Unix, etc.)  Specify None to write the lines as-is,
			like file.writelines().
		Use the keyword argument append=True to append lines to the
		file.  The default is to overwrite the file.  Warning:
		When you use this with Unicode data, if the encoding of the
		existing data in the file is different from the encoding
		you specify with the encoding= parameter, the result is
		mixed-encoding data, which can really confuse someone trying
		to read the file later.
		"""
		if append:
			mode = 'ab'
		else:
			mode = 'wb'
		f = self.open(mode)
		try:
			for line in lines:
				isUnicode = isinstance(line, unicode)
				if linesep is not None:
					# Strip off any existing line-end and add the
					# specified linesep string.
					if isUnicode:
						if line[-2:] in (u'\r\n', u'\x0d\x85'):
							line = line[:-2]
						elif line[-1:] in (u'\r', u'\n', u'\x85', u'\u2028'):
							line = line[:-1]
					else:
						if line[-2:] == '\r\n':
							line = line[:-2]
						elif line[-1:] in ('\r', '\n'):
							line = line[:-1]
					line += linesep
				if isUnicode:
					if encoding is None:
						encoding = sys.getdefaultencoding()
					line = line.encode(encoding, errors)
				f.write(line)
		finally:
			f.close()

	# --- Methods for querying the filesystem.
	exists = os.path.exists
	isabs = os.path.isabs
	isdir = os.path.isdir
	isfile = os.path.isfile
	islink = os.path.islink
	ismount = os.path.ismount
	def ishidden(self):
		"""Whether the path is a (posix) hidden file

		>>> path('~/.bashcr').ishidden()
		True
		"""
		if os.name != 'posix':
			return None
		return self.name[0] == '.'

	if hasattr(os.path, 'samefile'):
		samefile = os.path.samefile
	getatime = os.path.getatime
	atime = property(
		getatime, None, None,
		""" Last access time of the file. """)
	getmtime = os.path.getmtime
	mtime = property(
		getmtime, None, None,
		""" Last-modified time of the file. """)
	if hasattr(os.path, 'getctime'):
		getctime = os.path.getctime
		ctime = property(
			getctime, None, None,
			""" Creation time of the file. """)
	getsize = os.path.getsize
	size = property(
		getsize, None, None,
		""" Size of the file, in bytes. """)
	if hasattr(os, 'access'):
		def access(self, mode):
			""" Return true if current user has access to this path.

			mode - One of the constants os.F_OK, os.R_OK, os.W_OK, os.X_OK
			"""
			return os.access(self, mode)

	def stat(self):
		"""Perform a stat() system call on this path. """
		return os.stat(self)

	def lstat(self):
		""" Like path.stat(), but do not follow symbolic links. """
		return os.lstat(self)

	if hasattr(os, 'statvfs'):
		def statvfs(self):
			""" Perform a statvfs() system call on this path. """
			return os.statvfs(self)

	if hasattr(os, 'pathconf'):
		def pathconf(self, name):
			return os.pathconf(self, name)

	# --- Modifying operations on files and directories
	def utime(self, times):
		""" Set the access and modified times of this file. """
		os.utime(self, times)

	def chmod(self, mode):
		os.chmod(self, mode)

	if hasattr(os, 'chown'):
		def chown(self, uid, gid):
			os.chown(self, uid, gid)

	def rename(self, new):
		os.rename(self, new)

	def renames(self, new):
		os.renames(self, new)

	# --- Create/delete operations on directories

	def mkdir(self, mode=0777):
		os.mkdir(self, mode)

	def makedirs(self, mode=0777):
		os.makedirs(self, mode)

	def rmdir(self):
		os.rmdir(self)

	def removedirs(self):
		os.removedirs(self)

	# --- Modifying operations on files
	def touch(self):
		""" Set the access/modified times of this file to the current time.
		Create the file if it does not exist.
		"""
		fd = os.open(self, os.O_WRONLY | os.O_CREAT, 0666)
		os.close(fd)
		os.utime(self, None)
		if hasattr(self,'__file_class__'):
			return self.__file_class__(self)
		return self

	def remove(self):
		os.remove(self)

	def unlink(self):
		os.unlink(self)

	# --- Links
	if hasattr(os, 'link'):
		def link(self, newpath):
			""" Create a hard link at 'newpath', pointing to this file. """
			os.link(self, newpath)

	if hasattr(os, 'symlink'):
		def symlink(self, newlink):
			""" Create a symbolic link at 'newlink', pointing here. """
			os.symlink(self, newlink)

	if hasattr(os, 'readlink'):
		def readlink(self):
			""" Return the path to which this symbolic link points.

			The result may be an absolute or a relative path.
			"""
			return self.__class__(os.readlink(self))

		def readlinkabs(self):
			""" Return the path to which this symbolic link points.

			The result is always an absolute path.
			"""
			p = self.readlink()
			if p.isabs():
				return p
			else:
				return (self.parent / p).abspath()

	# --- High-level functions from shutil
	copyfile = shutil.copyfile
	copymode = shutil.copymode
	copystat = shutil.copystat
	copy = shutil.copy
	copy2 = shutil.copy2
	copytree = shutil.copytree
	if hasattr(shutil, 'move'):
		def move(self, destination):
			shutil.move(self, destination)
	rmtree = shutil.rmtree

	# --- Special stuff from os
	if hasattr(os, 'chroot'):
		def chroot(self):
			os.chroot(self)

	if hasattr(os, 'startfile'):
		def startfile(self):
			os.startfile(self)



if __name__ == '__main__':
	import doctest
	doctest.testmod()
