import sys
from path import path as path_path

paths = None

def sys_path():
	global paths
	paths = [ path_path(p) for p in sys.path ]

def get_sys_path():
	sys_path()
	return paths

def sites(some_paths=None):
	if not some_paths: some_paths = paths
	return [ l for l in some_paths if 'site-' in l ]

def site_packages(some_paths=None):
	if not some_paths: some_paths = paths
	return [ p for p in some_paths if p.basename() =='site-packages' ]

get_sys_path()
