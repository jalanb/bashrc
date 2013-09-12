"""Methods to run the locate script more exactly"""


import os
import commands
import optparse


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
	if status and output:
		raise ValueError('command: %s\n output: %s' % (command, output))
	elif not output:
		return []
	return [l for l in output.split('\n') if '/.svn' not in l]


def make_check(method, options):
	"""Make a check method by combining the given method with the options"""
	if options.directories:
		def is_dir(string):
			return method(string) and os.path.isdir(string)
		return is_dir
	if options.files:
		def is_file(string):
			return method(string) and os.path.isdir(string)
		return is_file
	return method


def locate(string, options):
	"""Locate some files called string, restricted by the given options"""
	lines = run_locate(string)
	def has_basename(path):
		return os.path.basename(path) == string
	check = make_check(has_basename, options)
	result = [l for l in lines if check(l)]
	if result:
		return result
	def directory_in_path(path):
		return string in path.split(os.path.sep)
	check = make_check(directory_in_path, options)
	result = [l for l in lines if check(l)]
	if result:
		return result
	if options.directories or options.files:
		return []
	return lines


def handle_command_line():
	"""Handle options and arguments from the command line"""
	parser = optparse.OptionParser()
	parser.add_option('-d', '--directories', action='store_true', help='only locate directories')
	parser.add_option('-f', '--files', action='store_true', help='only locate files')
	parser.add_option('-U', '--Use_debugger', action='store_true', help='debug with pudb')
	options, args = parser.parse_args()
	if options.Use_debugger:
		import pudb
		pudb.set_trace()
	return options, args


def main(args):
	options, args = handle_command_line()
	for arg in args:
		paths = locate(arg, options)
		if paths:
			print '\n'.join(paths)
	return os.EX_OK
