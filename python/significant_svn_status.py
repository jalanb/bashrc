"""Get the svn status of a directory recursively

Stop on first changed item
"""

import os
import sys
import commands


from paths import makepath



def _get_immediately_significant_status(path_to_file):
	command = 'svn stat --depth=immediates %s' % path_to_file
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
	if not path_to_directory.isdir():
		return None
	svn_dir = path_to_directory / '.svn'
	if not svn_dir.isdir():
		return None
	status = _get_immediately_significant_status(path_to_directory)
	if status:
		return status
	for path_to_dir in path_to_directory.dirs():
		if path_to_dir.ishidden():
			continue
		status = _get_significant_status(path_to_dir)
		if status:
			return status
	return None


def main(args):
	for arg in args:
		if _get_significant_status(makepath(arg)):
			return os.EX_OK
	return not os.EX_OK

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))
