"""Dirty up the main namespace with some extra imports"""

import os
import sys
from pprint import pprint as show

try:
	import environ
except ImportError:
	pass
try:
	import paths
except ImportError:
	pass

try:
	from see import see, code, see_methods, see_attributes, spread
except ImportError:
	def see(thing):
		show(dir(thing))
