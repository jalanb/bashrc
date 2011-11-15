'''A class to encapsulate a glob pattern, which may match some files'''

import path

class glob_path:
	def __init__(self,p):
		self.path = path.path(p)
		self.get_parent(self.path.parent)
		self.get_glob(self.path.name)

	def get_parent(self,parent):
		if not parent:
			parent = path.path('.')
		self.dirs = parent.dirs
		self.expand = parent.expand
		self.parent = parent

	def get_glob(self,name):
		if not name:
			name = '*'
		elif '*' not in name and '?' not in name:
			name = '%s*' % name
		self.glob = name

	def __str__(self):
		return '%s/%s' % (self.parent,self.glob)

	def __repr__(self):
		return '<glob_path %s>' % self

	def files(self):
		return self.parent.files(self.glob)

	def dirs(self):
		return self.parent.dirs(self.glob)

	def isfile(self):
		for f in self.parent.files(self.glob):
			return True
		return False

	def isdir(self):
		for f in self.parent.dirs(self.glob):
			return True
		return False

	def exists(self):
		return self.isfile() or self.isdir()

def any_fnmatch(path_to_something,globs):
	'''Whether the path is matched by any of the globs

	>>> any_fnmatch(path.path('fred.py'),[ 'other.*', 'f??d.*' ])
	True
	'''
	for glob in globs:
		if path_to_something.fnmatch(glob):
			return True
	return False

