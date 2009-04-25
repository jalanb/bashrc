from words import pluralize

class Tally(list):
	'''Tally is a kind of list.

	This tally is intended to be sub-classed,
		and provides conveniences to represent the class name nicely

	BTW:
	Inheritance from str seems OK, given 
		"Remember that the Path module have existed for three years in the wild and is
		extra-ordinarily well-liked. If the fact that Path inherits from
		string is such a big deal, then *why* is the path module so hugely
		popular?? :)"
	at http://mail.python.org/pipermail/python-dev/2006-January/060115.html
	'''
	def __str__(self):
		return '[%s]' % ', '.join([repr(s) for s in self])

	def __repr__(self):
		return "<%s %s>" % (self.class_name(),str(self))

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

def tlist(name,bases=None,ns=None):
	if bases is None: bases = []
	if ns is None: ns = {}
	class MySecondMeta(type):
		def __init__(cls, name, bases, ns):
			cls.lets_tlist_again_like_we_did_last_summer = True
	escaped = name.replace(' ','_')
	return MySecondMeta(escaped, (Tally,), ns)

