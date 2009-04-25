from words import pluralize

class Twine(str):
	'''Twine is a kind of string.

	This twine is intended to be sub-classed,
		and provides conveniences to represent the class name nicely

	BTW:
	Inheritance from str seems OK, given 
		"Remember that the Path module have existed for three years in the wild and is
		extra-ordinarily well-liked. If the fact that Path inherits from
		string is such a big deal, then *why* is the path module so hugely
		popular?? :)"
	at http://mail.python.org/pipermail/python-dev/2006-January/060115.html
	'''
	def __repr__(self):
		return "<%s '%s'>" % (self.class_name(),str(self))

	def full_class_name(self):
		class_repr = str(self.__class__)
		prefix = "<class '"
		suffix = "'>"
		trimmed = class_repr.replace(prefix,'').replace(suffix,'')
		return trimmed

	def class_name(self):
		result = self.full_class_name()
		i = 0
		try:
			i = result.rindex('.') + 1
		except ValueError:
			i = 0
		return result[i:]

	def list_name(self):
		return pluralize( self.class_name() )

	def str_class_and_list(self):
		return str(self), self.class_name(), self.list_name()

def associates(thing):
	if hasattr(thing,'associate'):
		return [ thing ]
	if hasattr(thing[0],'associate'):
		return thing
	raise ValueError('%r cannot associate' % thing)

class Tangle(Twine):
	'''A Tangle is a Twine associated with another twine.'''
	def associate(self,thing):
		children = associates(thing)
		for child in children:
			self.add_to_class(child)
			child.add_to_class(self)
		return self

	def add_to_class(self,child):
		class_name = child.class_name().lower()
		known_classname = hasattr(self,class_name)
		if not known_classname:
			setattr(self,class_name,child)

		list_name = child.list_name().lower()
		known_listname = hasattr(self,list_name)
		if not known_listname:
			setattr(self,list_name,{})
		cousins = getattr(self,list_name)
		if child not in cousins:
			cousins[str(child)] = child

def twist(name,bases=None,ns=None):
	if bases is None: bases = []
	if ns is None: ns = {}
	class MyFirstMeta(type):
		def __init__(cls, name, bases, ns):
			cls.lets_twist_again_like_we_did_last_summer = True
	if not ns: ns = {}
	escaped = name.replace(' ','_')
	return MyFirstMeta(escaped, (Twine,), ns)

