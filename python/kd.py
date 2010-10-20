import os
import sys
from path import path

def show_not_dir(p):
	if not p:
		raise ValueError('bad argument: %r' % p)
	while not p.isdir():
		prev = p
		p = p.parent
		if not p or p == '/': break
	raise ValueError('%s is not a directory' % prev)
	
def try_others(dirr,sub_dir):
	p = path(dirr)
	if p.parent.isdir():
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

def find_dir(dirr,sub_dir=None):
	if dirr == '':
		return path('~').expanduser()
	if dirr == '-':
		try: dirr = os.environ['OLDPWD']
		except KeyError: dirr = '~'
	whither = path(dirr)
	if whither.isfile():
		whither = whither.parent
	if not whither.isdir():
		whither = try_others(dirr,sub_dir)
	if not whither.isdir():
		show_not_dir(whither)
		return None
	if sub_dir:
		possibles = [ x for x in whither.walkdirs() if sub_dir in x.name ]
		if len(possibles) == 1:
			whither = possibles[0]
		elif not possibles:
			pass
		else:
			raise NotImplementedError('Too many possiblities:\n\t%s' % '\n\t'.join(possibles) )
	return whither

def parse_command_line(args):
	if len(args) > 2:
		raise ValueError('Usage: kd directory [sub-dir]')
	elif len(args) < 1:
		args = '', None
	elif len(args) == 1:
		args += [ None ]
	return args

def chdir(whither):
	if whither.isfile():
		whither = whither.parent
	if not whither.isdir():
		raise ValueError('%s is not a directory' % whither)
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
		return 1

if __name__ == '__main__':
	sys.exit(main())
