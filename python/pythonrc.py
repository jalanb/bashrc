"""Dirty up the main namespace with some extra imports"""

import os
import sys
from pprint import pprint as show


def pir(thing):
	"""Layout a dir listing more nicely"""
	show(dir(thing))


def pirr(thing, regexp):
	"""layout a dir listing filtered by the given regexp"""
	import re
	show([item for item in dir(thing) if re.match(regexp, item)])

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
