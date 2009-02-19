import os
import sys
from path import path

def show_not_dir(p):
	while not p.isdir():
		prev = p
		p = p.parent
		if p == '/': break
	raise ValueError('%s is not a directory' % prev)
	
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
		show_not_dir(whither)
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

def chdir(whither):
	if whither.isfile():
		whither = whither.parent
	if not whither.isdir():
		show_not_dir(whither)
	oldpwd = os.environ['PWD']
	os.chdir(whither)
	os.environ['OLDPWD'] = oldpwd
	os.environ['PWD'] = whither

def main():
	try:
		args = parse_command_line(sys.argv[1:])
		whither = find_dir(args[0], args[1])
		print str(whither)
		return 0
	except Exception, e:
		print os.getcwd()
		print >> sys.stderr, str(e)
		return 1

if __name__ == '__main__':
	sys.exit(main())
