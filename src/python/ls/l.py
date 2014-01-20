"""Basic functionality for the various ls scripts"""

import argv
import path
from glob_path import glob_path, any_fnmatch
from repositories import svn


argv.add_options([
	('notice', 'Notice files (that subversion ignores)', False),
	('recursive', 'Recurse into sub-directories', False),
])


def common_start(a, b):
	for i, j in enumerate(zip(a, b)):
		c, d = j
		if c != d:
			return i
	return min(len(a), len(b))


def common_start_dirs(a, b):
	last_slash = 0
	for i, j in enumerate(zip(a, b)):
		c, d = j
		if c == '/':
			last_slash = i
		if c != d:
			if last_slash:
				return last_slash + 1
			return 0
	return None



def default_ignores():
	ignores = set(svn.global_ignores())
	ignores.update(['*~', '.*.sw[lmnop]'])
	return list(ignores)


def all_ignores(ignores=None, extra_ignores=None):
	if not ignores:
		ignores = default_ignores()
	if extra_ignores:
		ignores.extend(extra_ignores)
	return ignores

def remove_ignored(files, ignores=None, extra_ignores=None):
	if argv.options.notice:
		return files
	globs = all_ignores(ignores, extra_ignores)
	return [f for f in files if not any_fnmatch(f, globs)]


def add_dir(dirs, d):
	if d in dirs:
		return
	if d == '':
		d = path.path('.')
	result = set(dirs)
	result.add(d)
	try:
		recursive = argv.options.recursive
	except AttributeError:
		recursive = False
	if recursive:
		for child in d.walkdirs():
			result.add(child)
	return list(result)


def get_dirs(args=None):
	if not args:
		dirs = [path.path('.')]
	else:
		arg_paths = [path.path(a) for a in as_paths(args)]
		dirs = []
		for p in arg_paths:
			if p.isdir():
				dirs = add_dir(dirs, p)
			elif p.isfile():
				dirs = add_dir(dirs, p.parent)
			else:
				gp = glob_path(p)
				if gp.exists():
					dirs = add_dir(dirs, gp)
		if not dirs:
			singular = hasattr(args, 'startswith') or len(args) == 1
			suffix = singular and 'y' or 'ies'
			raise ValueError('No such director%s: %s' % (suffix, ', '.join(arg_paths)))
	return dirs

def as_paths(thing=None):
	'''Convert thing to a list of path.path() instances.

	Will always return a list, which might be empty
	'''
	if thing is None:
		return []
	try:
		thing.relpathto('.')
		return [thing]
	except AttributeError:
		try:
			if hasattr(thing, 'parent'):
				p = thing
			else:
				if hasattr(thing, 'startswith'):
					p = path.path(thing)
				else:
					raise AttributeError('thing has bad attributes')
			for c in '~$':
				if c in str(thing):
					p = p.expand()
					break
			return [p]
		except AttributeError:
			things = thing
			result = []
			try:
				for thing in things:
					result.extend(as_paths(thing))
			except TypeError:
				raise NotImplementedError('Cannot convert %r to a path' % thing)
			except ValueError:
				raise NotImplementedError('Cannot convert %r to a path' % thing)
			return result
	raise NotImplementedError('Forgot a case: %s' % thing)


def get_files(dirs):
	dirs = as_paths(dirs)
	files = []
	here = path.path('.')
	for d in dirs:
		files.extend([here.relpathto(f) for f in d.files()])
	return files

def get_names(files):
	if not files:
		return {}
	names = {}
	for f in files:
		name = f.namebase
		got = names.get(name, [])
		got.append(f)
		try:
			names[name] = sorted(got)
		except Exception:
			raise ', '.join([str(got), str(names), name, f])
	return names
