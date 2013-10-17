from spine import Spine


class Twine(Spine, str):
	"""Twine is a kind of string.

	This twine is intended to be sub-classed,
		and provides conveniences to represent the class name nicely

	BTW:
	Inheritance from str seems OK, given
		"Remember that the Path module have existed for three years in the wild and is
		extra-ordinarily well-liked. If the fact that Path inherits from
		string is such a big deal, then *why* is the path module so hugely
		popular?? :)"
	at http://mail.python.org/pipermail/python-dev/2006-January/060115.html
	"""

	def str_class_and_list(self):
		"""A tuple with three strings for the value, class and list names

		>>> print Twine().str_class_and_list()
		('', 'Twine', 'Twines')
		"""
		return str(self), self.class_name(), self.list_name()


def twist(name, bases=None, ns=None):
	if bases is None:
		bases = []
	if ns is None:
		ns = {}
	class MyFirstMeta(type):
		def __init__(mcs, _name, _bases, _namespace):
			# # pylint: disable-msg=W0231
			mcs.lets_twist_again_like_we_did_last_summer = True
	if not ns:
		ns = {}
	escaped = name.replace(' ', '_')
	return MyFirstMeta(escaped, (Twine, ), ns)

