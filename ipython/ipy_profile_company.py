"""Set up access to important Employer data for IPython"""


import config_helper_functions


def wrap(db):
	from altobridge.dbwrapper import DBWrapper
	return DBWrapper(db)

class EmployerVariables:
	"""Holder of interesting attributes"""
	def __init__(self):
		self.open_db()
		self.open_itdb()

	def open_itdb(self):
		from altobridge.tracker import itissue_db
		self.itdb = itissue_db()
		self.itdbw = wrap(self.itdb)

	def reopen_db(self):
		self.db.close()
		self.open_db()

	def open_db(self):
		from altobridge.issues import mock_roundup
		self.request = mock_roundup.get_request()
		self.db = self.request.client.db
		self.dbw = wrap(self.db)

def read_pythonrc():
	import os
	pythonrc = os.path.expanduser('~/.pythonrc.py')
	os.path.isfile(pythonrc) and execfile(pythonrc, globals())
	del pythonrc

config_helper_functions.set_user_namespace('work', EmployerVariables())
print 'dir(work):', EmployerVariables().__dict__.keys()
