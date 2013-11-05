"""Get the svn status of a directory recursively

Stop on first changed item
"""

import os
import sys
import commands


def _get_immediately_significant_status(path_to_dir):
	command = 'svn stat --depth=immediates %s' % path_to_dir
	status, output = commands.getstatusoutput(command)
	if status:
		raise ValueError(output)
	for line in output.splitlines():
		line = line.strip()
		if not line:
			continue
		char = line[0]
		if char not in 'I?':
			return True
	return False

def _get_significant_status(path_to_directory):
	"""Get the svn status for that directory

	Stop if any immediates have a significant status
		otherwise recurse into sub-directories
	"""
	isdir = os.path.isdir
	if not isdir(path_to_directory):
		return None
	path_to_svn = '%s/.svn' % path_to_directory
	if not isdir(path_to_svn):
		return None
	status = _get_immediately_significant_status(path_to_directory)
	if status:
		return status
	for path_to_dir in os.listdir(path_to_directory):
		if not isdir(path_to_dir):
			continue
		if path_to_dir[0] == '.' or path_to_dir == path_to_directory:
			continue
		status = _get_significant_status(path_to_dir)
		if status:
			return status
	return None


def main(args):
	for arg in args:
		if _get_significant_status(arg):
			return os.EX_OK
	return not os.EX_OK

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))
