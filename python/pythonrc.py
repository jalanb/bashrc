#! /usr/bin/env python

# dirty up the main namespace a bit
import os
import sys
from path import path
from pprint import pprint as show

try: import environ
except ImportError: pass
try: import paths
except ImportError: pass

try:
	from see import see, code, see_methods, see_attributes
except ImportError:
	def see(x):
		show(dir(x))
