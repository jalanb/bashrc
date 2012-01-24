import os
import sys
import inspect
from path import path
import argv

debugging = False

def debug(message):
	if not debugging: return
	print >> sys.stderr, '%s: %r' % (sys.argv[0], message)
	
def enter_method():
	frame = inspect.currentframe().f_back
	code = frame.f_code
	args, varargs, varkw, lokals = inspect.getargvalues(frame)
	values = [ lokals[a] for a in args ]
	return 'def %s%s' % (code.co_name,tuple(values))
	
def exit_method():
	frame = inspect.currentframe().f_back
	code = frame.f_code
	args, varargs, varkw, lokals = inspect.getargvalues(frame)
	arg_values = [ lokals[a] for a in args ]
	result = [ 'return %s%s:' % (code.co_name,tuple(arg_values)) ]
	for name, value in lokals.iteritems():
		if name in args: continue
		result.append( '%r : %r' % ( name, value ) )
	return '\n\t'.join(result)
	
def try_others(dirr,sub_dir):
	debug(enter_method())
	p = path(dirr)
	if p.parent.isdir():
		debug(exit_method())
		return p.parent
	p = path(os.getcwd())
	if sub_dir:
		try:
			return [ d for d in p.dirs() if d.startswith(sub_dir) ][0]
		except IndexError:
			try:
				return [ p for f in p.files() if f.startswith(sub_dir) ][0]
			except IndexError:
				raise ValueError('Could not find %r in %r' % ( sub_dir, p ))
	return path(dirr)

def try_sub_dirs(top, sub_dir):
	debug(enter_method())
	result = []
	for d in top.dirs():
		if sub_dir in d.name:
			result.append(d)
	if result:
		debug(exit_method())
		return result
	for d in top.dirs():
		if d.name == '.svn': continue
		result.extend( try_sub_dirs(d, sub_dir) )
	debug(exit_method())
	return result

def find_in_PATH(whither):
	if not whither.isdir():
		for directory in os.environ['PATH'].split(':'):
			path_in_PATH = path(directory)
			possible_file = path_in_PATH / whither
			if possible_file.isfile():
				return path_in_PATH
	return None

def find_dir(start_dir,sub_dir=None):
	debug(enter_method())
	if start_dir == '':
		return path('~').expanduser()
	if start_dir == '-':
		try: start_dir = os.environ['OLDPWD']
		except KeyError: start_dir = '~'
	whither = path(start_dir)
	if whither.isfile():
		whither = whither.parent
	if not whither.isdir():
		whither = try_others(start_dir,sub_dir)
	if not whither.isdir():
		whither = find_in_PATH(whither)
	if not whither or not whither.isdir():
		raise ValueError('%s is not a directory' % start_dir)
	if not sub_dir:
		return whither
	possibles = try_sub_dirs(whither,sub_dir)
	if len(possibles) == 1:
		return possibles[0]
	if not possibles:
		return whither
	if sub_dir in possibles:
		return sub_dir
	raise NotImplementedError('Too many possiblities:\n\t%s' % '\n\t'.join(possibles) )

def parse_command_line(args):
	if len(args) > 2:
		raise ValueError('Usage: kd directory [sub-dir]')
	elif len(args) < 1:
		args = '', None
	elif len(args) == 1:
		args += [ None ]
	debug('args: %s' % str(args) )
	return args

def chdir(whither):
	whither = find_dir(whither)
	oldpwd = os.environ['PWD']
	os.chdir(whither)
	os.environ['OLDPWD'] = oldpwd
	os.environ['PWD'] = whither

def main():
	try:
		args = parse_command_line(sys.argv[1:])
		whither = find_dir(args[0], args[1])
		if whither:
			print str(whither)
		return 0
	except Exception, e:
		print 'Error', e
		return 1

if __name__ == '__main__':
	sys.exit(main())
