"""Some config helper functions you can use"""
import os

import IPython.ipapi
ip = IPython.ipapi.get()

def import_mod(modules):
	""" Usage: import_mod("os sys") """ 
	for m in modules.split():
		ip.ex("import %s" % m)
		
def import_all(modules):
	""" Usage: import_all("os sys") """ 
	for m in modules.split():
		ip.ex("from %s import *" % m)
		
def import_some(module,things):
	"""Usage: import_some('path','path')"""
	for thing in things.split():
		ip.ex('from %s import %s' % (module,thing))

def execf(fname):
	""" Execute a file in user namespace """
	ip.ex('execfile("%s")' % os.path.expanduser(fname))

