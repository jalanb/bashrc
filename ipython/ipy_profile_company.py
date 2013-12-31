"""Set up access to important Employer data for IPython"""


import config_helper_functions


class EmployerVariables:
	"""Holder of interesting attributes"""
	def __init__(self):
		pass

def read_pythonrc():
	import os
	pythonrc = os.path.expanduser('~/.pythonrc.py')
	if os.path.isfile(pythonrc):
		execfile(pythonrc, globals())
	del pythonrc

config_helper_functions.set_user_namespace('work', EmployerVariables())
print 'dir(work):', EmployerVariables().__dict__.keys()
