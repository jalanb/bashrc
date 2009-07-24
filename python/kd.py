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
	
def try_others(sought):
	p = path(sought)
	if p.parent.isdir():
		return p.parent
	if p.parent:
		p = p.parent
	else:
		p = path(os.getcwd())
	try:
		return [ d for d in p.dirs() if d.startswith(sought) ][0]
	except IndexError:
		print 'No directory in %s startswith "%s"' % (p,sought)
		try:
			return [ d.parent for d in p.files() if d.startswith(sought) ][0]
		except IndexError:
			print 'No file in %s startswith "%s"' % (p,sought)
	return path(sought)

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
		whither = try_others(dirr)
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
	else:
		raise ValueError('I cannot count')
	return args

def main():
	try:
		args = parse_command_line(sys.argv[1:])
		whither = find_dir(args[0], args[1])
		if whither:
			print str(whither)
		return 0
	except Exception, e:
		print >> sys.stderr, "Error", str(e)
		return 1

if __name__ == '__main__':
	sys.exit(main())
