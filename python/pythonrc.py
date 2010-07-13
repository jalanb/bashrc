#! /usr/bin/env python

# dirty up the main namespace a bit
import os
import sys
from path import path
from pprint import pprint as show

import environ
import paths

try:
	from see import see
except ImportError:
	def see(x):
		show(dir(x))
