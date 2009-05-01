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
		try: return self.as_str()
		except TypeError: return self.to_str()

	def __repr__(self):
		try: return "<%s '%s'>" % (self.class_name(),self.as_str())
		except TypeError: return "<%s %s>" % (self.class_name(),self.to_str())

	def as_str(self,separator=None):
		if separator is None: separator = ''
		return separator.join(self)

	def to_str(self,i=None,j=None,separator=None):
		if i is None and j is None:
			items = self
		elif i is None:
			items = self[:j]
		elif j is None:
			items = self[i:]
		else:
			items = self[i:j]
		if separator is None: separator = ', '
		return '[%s]' % separator.join([repr(s) for s in items])

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
		try:
			list_of_items = self[0].list_name()
		except AttributeError:
			list_of_items = ''
		if self.class_name() == list_of_items:
			return self.class_name()
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

def enjoin(lyst):
	return lyst
