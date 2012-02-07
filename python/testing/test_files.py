import re
from pprint import pprint

from paths import makepath

class UserMessage(Exception):
	pass

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

def any_extension(p):
	if p.isfile():
		dirr = p.parent
		glob = p.namebase + '.*'
	elif p.isdir():
		dirr = p
		glob = '*'
	else:
		if p.parent:
			dirr = p.parent
		else:
			dirr = path('.')
		glob = '%s.*' % p.namebase
	if not dirr.isdir(): return []
	return [ f for f in dirr.files(glob) ]

def some_extensions(p,exts):
	return [ f for f in any_extension(p) if f.ext in exts ]

def get_paths(args):
	here = makepath('.')
	paths = []
	for arg in args:
		if '/' in arg:
			p = makepath(arg)
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
	result = dirs
	for p in dirs:
		for sub_dir in p.walkdirs():
			if '.svn' in sub_dir:
				continue
			if sub_dir not in result:
				result += [ sub_dir ]
	return result

def get_test_scripts(args=None,recursive=False):
	if not args:
		args = []
	exts = [ '', '.py' ,'.tests' , '.test']
	test_scripts = []
	paths = get_paths(args)
	if recursive:
		files = [ f for f in paths if f.isfile() ]
		if files:
			raise UserMessage('Do not use -r (recursive) with files: %s' % files)
		paths = add_sub_dirs(paths)
	if not paths:
		here = makepath('.')
		if recursive:
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
		test_scripts = p.files('*.test*')
	result = []
	def add_to_result(check):
		for script in test_scripts:
			if check(script):
				if script not in result:
					result.append(script)
	add_to_result(lambda x: x.ext == '.tests')
	add_to_result(lambda x: x.ext == '.test')
	add_to_result(lambda x: x.ext == '.py')
	for script in test_scripts:
		if script.ext == '':
			lines = script.lines()
			if not lines: continue
			if re.match('#!.*python.*',lines[0]):
				if script not in result and str('%s.py' % script) not in result:
					result.append(script)
	return result

