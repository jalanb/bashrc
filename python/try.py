import os
import imp
import sys
import doctest
import fnmatch
import datetime
from pprint import pprint
from optparse import OptionParser

try:
	from path import path
except ImportError:
	from altobridge.path import path

runtime_path = path(os.path.abspath('.'))

class UserMessage(Exception):
	pass

def command_line():
	parser = OptionParser()
	parser.add_option("-v", "--verbose", dest="verbose", help="Hello World", action='store_true')
	parser.add_option("-r", "--recusrive", dest="recursive", help="recurse into any sud-directories found", action='store_true', default=False)
	parser.add_option('-a','--all', dest='all', help='run all tests in each file (do not stop on first FAIL)', action='store_true', default=False)
	parser.add_option('-d','--directory_all', dest='directory_all', help='run all test scripts in a directory (do not stop on first FAILing script)', action='store_true', default=False)
	parser.add_option('-q','--quiet_on_success', dest='quiet_on_success', help='no output if all tests pass', action='store_true', default=False)
	return parser.parse_args()

def files(path,glob):
	names = fnmatch.filter(os.listdir(path),glob)
	return [ os.path.join(path,name) for name in names ]

def try_testing_sub_dir(p):
	t = p / 'testing'
	if t.isdir():
		return t
	return p

def get_test_dir():
	args = sys.argv[1:]
	result = path('.')
	for arg in args:
		arg_path = path(arg)
		if arg_path.isdir():
			result = arg_path
			break
	else:
		for arg in args:
			arg_path = path(arg)
			if arg_path.parent and arg_path.isfile():
				result = arg_path.parent
				break
	result = try_testing_sub_dir(result)
	if not result.isdir():
		raise UserMessage('%s is not a directory' % result)
	if not result.files('*.test*') or result.files('*.py'):
		raise UserMessage('%s/*.test*, *.py not found' % result)
	return result

def find_test_file(arg):
	test_dir = get_test_dir()
	if arg == str(test_dir): return None
	p = path(arg)
	if p.isfile(): return p
	t = p.splitext()[0] + '.test'
	if t.isfile(): return t
	if p.parent:
		return None
	p = test_dir / arg
	if p.isfile(): return p
	t = p.splitext()[0] + '.test'
	if t.isfile(): return t
	return None

def get_dir_path(item):

	p = path(item)
	if p.isdir():
		return p
	return p.parent

class Sys_Path_Handler:
	def __init__(self):
		self.paths = []

	def add(self,item):
		item_path = get_dir_path(item)
		if item_path not in self.paths:
			self.paths.insert(0,item_path)
			if item_path not in sys.path:
				sys.path.insert(0,item_path)
			
	def remove(self,item):
		item_path = get_dir_path(item)
		if item_path in self.paths:
			self.paths.remove(item_path)
			if item_path in sys.path:
				sys.path.remove(item_path)

def any_extension(p):
	if p.isfile():
		dirr = p.parent
		glob = p.namebase + '*'
	elif p.isdir():
		dirr = p
		glob = '*'
	else:
		if p.parent:
			dirr = p.parent
		else:
			dirr = path('.')
		glob = '%s*' % p.namebase
	if not dirr.isdir(): return []
	return [ f for f in dirr.files(glob)  ]

def some_extensions(p,exts):
	return [ f for f in any_extension(p) if f.ext in exts ]
			
def get_paths(args):
	here = path('.')
	paths = []
	for arg in args:
		if '/' in arg:
			p = path(arg)
		else:
			p = here / arg
		paths += [ p ]
	return paths

def add_sub_dirs(paths):
	dirs = []
	for p in paths:
		if p.isdir():
			top_dir = p
		else:
			top_dir = p.parent
		if top_dir not in dirs:
			dirs += [ top_dir ]
	result = []
	for p in dirs:
		for sub_dir in p.walkdirs():
			if sub_dir not in result:
				result += [ sub_dir ]
	return result

def get_test_scripts(options,args):
	exts = [ '.py' ,'.tests' , '.test']
	test_scripts = []
	paths = get_paths(args)
	if options.recursive:
		paths = add_sub_dirs(paths)
	if not paths:
		here = path('.')
		if options.recursive:
			method = here.walkfiles
		else:
			method = here.files
		test_scripts = [ ]
		for ext in exts:
			a_glob = '*%s' % ext
			for f in method(a_glob):
				test_scripts.append(f)
	else:
		extension_scripts = []
		for p in paths:
			if p.isfile():
				extension_scripts += [ p ]
			else:
				extension_scripts += some_extensions(p,exts)
		if extension_scripts:
			test_scripts += extension_scripts
		else:
			raise UserMessage('%s.test*, %s.py not found' % (paths[0],paths[0]))

	if not test_scripts:
		p = get_test_dir()
		test_scripts = p.files('*.test')
	result = [ s for s in test_scripts if s.ext == '.tests' ]
	result += [ s for s in test_scripts if s.ext == '.test' ]
	result += [ s for s in test_scripts if s.ext == '.py' ]
	return result

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
	options, args = command_line()
	sys_paths = Sys_Path_Handler()
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
		for test_script in get_test_scripts(options,args):
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
					message = 'try %s;' % runtime_path.relpathto(test_script)
					failures, testsRun = doctest.testfile(test_script,optionflags=doctest_options,module_relative=False)
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
	except UserMessage, e:
		print >> sys.stderr, e
	except KeyboardInterrupt:
		print >> sys.stderr, '^c ^C ^c ^C ^c ^C ^c ^C ^c ^C ^c '
		print >> sys.stderr, 'Bye now'

if __name__ == '__main__':
	sys.exit(main())
