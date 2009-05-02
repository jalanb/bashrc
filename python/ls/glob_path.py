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
		elif '*' not in name:
			name = '%s*' % name
		self.glob = name

	def __str__(self):
		return '%s/%s' % (self.parent,self.glob)

	def __repr__(self):
		return '<glob_path %s>' % self

	def files(self):
		return self.parent.files(self.glob)

	def exists(self):
		for f in self.parent.files(self.glob):
			return True
		return False

