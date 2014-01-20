"""Dirty up the main namespace with some extra imports"""


try:
	see
except NameError:
	def see(thing, regexp=None):
		"""layout a dir listing filtered by the given regexp"""
		if regexp:
			import re
			print '\n'.join(sorted([item for item in dir(thing) if re.match(regexp, item)]))
		else:
			print '\n'.join(sorted(dir(thing)))


def _path_to_history(os):
	"""Get the path to our history file - hidden in the home directory"""
	home = os.path.expanduser('~')
	path_to_history = os.path.join(home, '.pythonhistory')
	if not os.path.isfile(path_to_history):
		file(path_to_history, 'w').close()
	return path_to_history


def _write_time_stamp(path_to_history):
	"""Add a commented time stamp to that history file"""
	import datetime
	try:
		history_file = file(path_to_history, 'a')
		print >> history_file, '#', datetime.datetime.now().ctime()
	finally:
		history_file.close()


def _read_history(readline):
	"""Load the history (if any) into readline"""
	import os
	import atexit
	path_to_history = _path_to_history(os)
	if os.path.isfile(path_to_history):
		_write_time_stamp(path_to_history)
		readline.read_history_file(path_to_history)
	atexit.register(readline.write_history_file, path_to_history)


def complete():
	try:
		import readline
		readline.parse_and_bind('tab: complete')
		_read_history(readline)
	except ImportError, e:
		print 'Python shell enhancement modules not available because %s' % e


complete()
