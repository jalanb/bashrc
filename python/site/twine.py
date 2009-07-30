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
		'''Represent the Twine

		>>> Twine('stuff')
		<Twine 'stuff'>
		'''
		return "<%s '%s'>" % (self.class_name(),str(self))

	def full_class_name(self):
		'''The fully qualified class name for the Twine (or sub-class)

		>>> Twine('stuff').full_class_name()
		'twine.Twine'
		'''
		class_repr = str(self.__class__)
		prefix = "<class '"
		suffix = "'>"
		trimmed = class_repr.replace(prefix,'').replace(suffix,'')
		return trimmed

	def class_name(self):
		'''The class name for the Twine (or sub-class)

		>>> Twine('stuff').class_name()
		'Twine'
		'''
		result = self.full_class_name()
		i = 0
		try:
			i = result.rindex('.') + 1
		except ValueError:
			i = 0
		return result[i:]

	def list_name(self):
		'''The list name for the Twine (or sub-class)

		What should a collection of these things be called ?

		>>> Twine('stuff').list_name()
		'Twines'
		'''
		return pluralize( self.class_name() )

	def str_class_and_list(self):
		'''A tuple with three strings for the value, class and list names

		>>> print Twine().str_class_and_list()
		('', 'Twine', 'Twines')
		'''
		return str(self), self.class_name(), self.list_name()

def twist(name,bases=None,ns=None):
	if bases is None: bases = []
	if ns is None: ns = {}
	class MyFirstMeta(type):
		def __init__(cls, name, bases, ns):
			cls.lets_twist_again_like_we_did_last_summer = True
	if not ns: ns = {}
	escaped = name.replace(' ','_')
	return MyFirstMeta(escaped, (Twine,), ns)

