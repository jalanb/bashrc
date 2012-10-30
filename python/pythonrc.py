"""Dirty up the main namespace with some extra imports"""


from pprint import pprint as show


def see(thing, regexp=None):
	"""layout a dir listing filtered by the given regexp"""
	if regexp:
		import re
		show([item for item in dir(thing) if re.match(regexp, item)])
	else:
		show(dir(thing))
