"""Methods to run the locate script more exactly"""


import os
import commands
import optparse

from repositories import repository

def path_to_locate():
	"""Location of the locate command on most unixen"""
	homebrewed_locate = '/usr/local/Cellar/findutils/4.4.2/bin/locate'
	if os.path.isfile(homebrewed_locate):
		return homebrewed_locate
	return '/usr/bin/locate'


def make_locate_command(string, options):
	"""Make a command to locate that string"""
	option = options.ignore_case and '-i' or ''
	return '%s %s "%s"' % (path_to_locate(), option, string)


def locatable(path):
	"""Whether that path is wanted in location results

	>>> not locatable('/path/to/.svn/file')
	True
	"""
	return not repository.is_repository_path(path)


def run_locate(string, options):
	"""Run the locate command on the given string"""
	command = make_locate_command(string, options)
	status, output = commands.getstatusoutput(command)
	if status and output:
		raise ValueError('command: %s\n output: %s' % (command, output))
	elif not output:
		return []
	return [l for l in output.split('\n') if locatable(l)]


def make_check(method, options):
	"""Make a check method by combining the given method with the options"""
	if options.directories:
		def is_dir(string):
			return method(string) and os.path.isdir(string)
		return is_dir
	if options.files:
		def is_file(string):
			return method(string) and os.path.isfile(string)
		return is_file
	return method


def locate(string, options):
	"""Locate some files called string, restricted by the given options"""
	lines = run_locate(string, options)
	def has_basename(path):
		if options.ignore_case:
			return os.path.basename(path).upper() == string.upper()
		return os.path.basename(path) == string
	check = make_check(has_basename, options)
	result = [l for l in lines if check(l)]
	if result or options.basename:
		return result
	def directory_in_path(path):
		test_string = string
		if options.ignore_case:
			test_string = string.upper()
			path = path.upper()
		parts = path.split(os.path.sep)
		if options.basename:
			return test_string == parts[-1]
		else:
			return test_string in parts
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
	parser.add_option('-b', '--basename', action='store_true', help='only find basenames')
	parser.add_option('-d', '--directories', action='store_true', help='only locate directories')
	parser.add_option('-f', '--files', action='store_true', help='only locate files')
	parser.add_option('-i', '--ignore-case', action='store_true', help='ignore case in searches')
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

