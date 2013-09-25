"""Dirty up the main namespace with some extra imports"""


try:
	see
except NameError:
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
	import atexit
	import datetime
	history_path = os.path.expanduser('~/.pythonhistory')
	if os.path.isfile(history_path):
		try:
			history_file = file(history_path, 'a')
			print >> history_file, '#'
			print >> history_file, '#', datetime.datetime.now().isoformat()
			print >> history_file, '#'
		finally:
			history_file.close()
		readline.read_history_file(history_path)
	atexit.register(readline.write_history_file, history_path)


def complete():
	try:
		import readline
		readline.parse_and_bind('tab: complete')
		read_history(readline)
	except ImportError, e:
		print 'Python shell enhancement modules not available because %s' % e


complete()
