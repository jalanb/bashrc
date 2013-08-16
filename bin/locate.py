"""Methods to run the locate script more exactly"""


import os
import commands


def path_to_locate():
	"""Location of the locate command on most unixen"""
	return '/usr/bin/locate'


def make_locate_command(string):
	"""Make a command to locate that string"""
	return '%s %s' % (path_to_locate(), string)


def run_locate(string):
	"""Run the locate command on the given string"""
	command = make_locate_command(string)
	status, output = commands.getstatusoutput(command)
	if status:
		raise ValueError('command: %s\n output: %s' % (command, output))
	return [l for l in output.split('\n') if '/.svn' not in l]


def locate(string):
	lines = run_locate(string)
	result = [l for l in lines if os.path.basename(l) == string]
	if result:
		return result
	result = [l for l in lines if string in l.split(os.path.sep)]
	if result:
		return result
	return lines


def main(args):
	for arg in args:
		paths = locate(arg)
		if paths:
			print '\n'.join(paths)
	return os.EX_OK
