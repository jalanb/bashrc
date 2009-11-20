import os
import imp
import sys
import doctest
import fnmatch
import commands
import datetime
from pprint import pprint, pformat

from path import makepath
import test_files

def public_dir(x):
	return [ d for d in dir(x) if not d.startswith('__') ]
	
def run_command(command):
	status, output = commands.getstatusoutput(command)
	if status:
		print 'FAIL: %s:%s' % (status,output)
		return False
	print output
	return True

def long_show(fred,indentation=None):
	if not indentation:
		indentation = ''
	if issubclass(type(fred), list) or issubclass(type(fred), tuple):
		if issubclass(type(fred), list):
			start, end = '[', ']'
		if issubclass(type(fred), tuple):
			start, end = '(', ')'
		sys.stdout.write( '%s%s\n' % (indentation,start) )
		for item in fred:
			long_show(item,'%s\t' % indentation)
			sys.stdout.write( ',\n' )
		sys.stdout.write( '%s%s' % (indentation,end) )
	elif issubclass(type(fred), dict):
		start, end = '{', '}'
		sys.stdout.write( '%s%s\n' % (indentation,start) )
		for key,value in fred.iteritems():
			long_show(key,'%s\t' % indentation)
			sys.stdout.write( ': ' )
			long_show(value,'%s\t' % indentation)
			sys.stdout.write( ',\n' )
		sys.stdout.write( '%s%s' % (indentation,end) )
	else:
		sys.stdout.write( '%s%s' % (indentation,fred) )

class Test_Being_Run:
	def __init__(self,that):
		self.runner = makepath(sys.argv[0])
		self.here = makepath('.')
		self.home = makepath('~')
		self.username = os.environ['USER']
		try:
			self.host = os.environ['HOST']
		except KeyError:
			try:
				self.host = os.environ['HOSTNAME']
			except KeyError:
				self.host = None
				if self.home.startswith('/Users'):
					self.host = 'jab.ook'
		self.user = '%s@%s' % ( self.username, self.host )
		self.path = self.here.relpathto(that)
		self.python_path = os.environ['PYTHONPATH']
		self.bash_path = os.environ['PATH']

	def __repr__(self):
		return pformat(self.__dict__.keys())

def command_line():
	from optparse import OptionParser
	parser = OptionParser()
	parser.add_option("-v", "--verbose", dest="verbose", help="Hello World", action='store_true')
	parser.add_option("-r", "--recusrive", dest="recursive", help="recurse into any sud-directories found", action='store_true', default=False)
	parser.add_option('-a','--all', dest='all', help='run all tests in each file (do not stop on first FAIL)', action='store_true', default=False)
	parser.add_option('-d','--directory_all', dest='directory_all', help='run all test scripts in a directory (do not stop on first FAILing script)', action='store_true', default=False)
	parser.add_option('-q','--quiet_on_success', dest='quiet_on_success', help='no output if all tests pass', action='store_true', default=False)
	result = parser.parse_args()
	del parser
	return result

def files(path,glob):
	names = fnmatch.filter(os.listdir(path),glob)
	return [ os.path.join(path,name) for name in names ]

def try_testing_sub_dir(p):
	t = p / 'testing'
	if t.isdir():
		return t
	return p

class Sys_Path_Handler:
	def __init__(self):
		self.paths = []

	def add(self,item):
		directory = makepath(item).directory()
		if directory not in self.paths:
			self.paths.insert(0,directory)
			if directory not in sys.path:
				sys.path.insert(0,directory)
			
	def remove(self,item):
		directory = makepath(item).directory()
		if directory in self.paths:
			self.paths.remove(directory)
			if directory in sys.path:
				sys.path.remove(directory)

def make_module(path_to_python):
	name = path_to_python.namebase
	try: return sys.modules[name]
	except KeyError: pass
	# If any of the following calls raises an exception,
	# there's a problem we can't handle -- let the caller handle it.
	fp, pathname, description = imp.find_module(name,[path_to_python.parent])
	try:
		# print '"%s","%s","%s","%s"' % (name, fp, pathname, description)
		x = imp.load_module(name, fp, pathname, description)
		return x
	finally:
		if fp:
			fp.close()

def test():
	sys_paths = Sys_Path_Handler()
	options, args = command_line()
	doctest_options = doctest.ELLIPSIS | doctest.NORMALIZE_WHITESPACE
	if not options.all:
		doctest_options |= doctest.REPORT_ONLY_FIRST_FAILURE
	out = [ '' ]
	pwd = os.getcwd()
	end = start_all = datetime.datetime.now()
	run_all = 0
	failures_all = 0
	sys_paths.add('.')
	try:
		for test_script in test_files.get_test_scripts(args,options.recursive):
			os.chdir(pwd)
			start = datetime.datetime.now()
			if not test_script: continue
			try:
				sys_paths.add(test_script)
				if test_script.ext == '.py':
					message = 'py %s;' % test_script
					module = make_module(test_script)
					failures, testsRun = doctest.testmod(module,optionflags=doctest_options)
					del module
				else:
					message = 'try %s;' % test_script
					failures, testsRun = doctest.testfile(
						test_script,
						optionflags=doctest_options,
						module_relative=False,
						globs = {
							'test' : Test_Being_Run(test_script),
							'sys' : sys,
							'makepath' : makepath,
							'show' : pprint,
							'long_show' : long_show,
							'bash' : run_command,
							'public_dir' : public_dir,
						}
					)
			finally:
				sys_paths.remove(test_script)
			if testsRun:
				run_all += testsRun
				end = datetime.datetime.now()
				time_taken = end - start
				if time_taken.seconds:
					if time_taken.seconds > 1:
						time_msg = 'in %d seconds' % time_taken.seconds
					else:
						time_msg = 'quickly'
				else:
					time_msg = 'very quickly'
				out += [ '%s %s tests passed %s' % (message, testsRun, time_msg) ]
			if failures:
				failures_all += failures
				if not options.directory_all:
					return failures
	finally:
		time_taken = end - start_all
		out += [ '%s tests passed, %d failed, in %s seconds' % (run_all, failures_all, time_taken.seconds) ]
		out += [ '' ]
	if failures_all == 0 and options.quiet_on_success:
		return 0
	print '\n'.join(out)
	return failures_all

def main():
	try:
		return test()
	except test_files.UserMessage, e:
		print >> sys.stderr, e
	except KeyboardInterrupt:
		print >> sys.stderr, '^c ^C ^c ^C ^c ^C ^c ^C ^c ^C ^c '
		print >> sys.stderr, 'Bye now'

if __name__ == '__main__':
	sys.exit(main())
