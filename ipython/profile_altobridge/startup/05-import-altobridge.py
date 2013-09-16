"""Set up access to important Altobridge data for IPython"""

class AltobridgeVariables:
	"""Holder of interesting attributes"""
	def __init__(self):
		self.open_db()
		self.open_itdb()

	def open_itdb(self):
		from altobridge.tracker import itissue_db
		self.itdb = itissue_db()
		from altobridge.dbwrapper import wrap
		self.itdbw = wrap(self.itdb)

	def reopen_db(self):
		self.db.close()
		self.open_db()

	def open_db(self):
		from altobridge.issues import mock_roundup
		self.request = mock_roundup.get_request()
		self.db = self.request.client.db
		from altobridge.dbwrapper import wrap
		self.dbw = wrap(self.db)

alto = AltobridgeVariables()
print 'dir(alto):', alto.__dict__.keys()
