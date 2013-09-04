"""Dirty up the main namespace with some extra imports"""


def see(thing, regexp=None):
	"""layout a dir listing filtered by the given regexp"""
	from pprint import pprint as show
	if regexp:
		import re
		show([item for item in dir(thing) if re.match(regexp, item)])
	else:
		show(dir(thing))


def read_history(readline):
	import os
	import atexist
	history_file = os.path.expanduser('.pythonhistory')
	if os.path.isfile(history_file):
		readline.read_history_file(history_file)
	atexit.register(readline.write_history_file, history_file)


def complete():
	try:
		import rlcompleter
		import readline
		readline.parse_and_bind('tab: complete')
		read_history(readline)
	except ImportError, e:
		print 'Python shell enhancement modules not available because %s' % e


complete()
